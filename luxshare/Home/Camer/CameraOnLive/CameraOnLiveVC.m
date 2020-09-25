//
//  CameraOnLiveVC.m
//  luxshare
//
//  Created by 黄振 on 2020/7/7.
//  Copyright © 2020 KingYellow. All rights reserved.
//

#import "CameraOnLiveVC.h"
#import "CameraListCell.h"
#import "CameraTBtnCell.h"
#import "CameraThreeBtnCell.h"
#import "OnLiveCell.h"
#import "ZYGlKImageView.h"
#import "DeviceSettingVC.h"
#import "CameraPlayView.h"
#import "PhotosVC.h"
#import "BackPlayVC.h"
#import "UIImageView+Gif.h"
#import "MBProgressHUD+NJ.h"
@interface CameraOnLiveVC ()<TuyaSmartCameraDelegate,UITableViewDelegate,UITableViewDataSource,TuyaSmartCameraDPObserver,TuyaSmartDeviceDelegate>
@property (strong, nonatomic)UITableView *qzTableView;
@property (copy, nonatomic)NSMutableArray *listArr;
@property (copy, nonatomic)NSMutableArray *logoArr;
@property (strong, nonatomic)id<TuyaSmartCameraType> camera;
@property (strong, nonatomic)UIView<TuyaSmartVideoViewType> * preview;
@property (assign, nonatomic)BOOL connected;
@property (assign, nonatomic)BOOL previewing;
@property (strong, nonatomic)TuyaSmartCameraDPManager *dpManager;
@property (strong, nonatomic)TuyaSmartDevice *device;
@property (strong, nonatomic)CameraPlayView *playView;
@property (strong, nonatomic)UIImageView *playPreGif;
//高清
@property (assign, nonatomic)BOOL HD;
//静音
@property (assign, nonatomic)BOOL isMuted;
@property (strong, nonatomic)NSTimer *recordTimer;
@property (strong, nonatomic)NSTimer *talkTimer;

@property (assign, nonatomic)NSInteger recordSecond;
@property (assign, nonatomic)NSInteger talkSecond;

@property (assign, nonatomic)BOOL private;
@property (strong, nonatomic)UIView *privateView;
@property (assign, nonatomic)BOOL recording;
@property (assign, nonatomic)int recordTime;

@property (assign, nonatomic)BOOL talking;
@property (assign, nonatomic)BOOL talkType;//1单 0双

//单讲对话控制
@property (strong, nonatomic)UIView *talkBigView;
@property (strong, nonatomic)UIButton *talkBtn;
@property (assign, nonatomic)BOOL isHor;
@property(nonatomic,assign) BOOL statusHiden;
@property (assign, nonatomic)BOOL isAwake;
@property (strong, nonatomic)MBProgressHUD *talkHud;
@end

@implementation CameraOnLiveVC
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    UIApplication *app = [UIApplication sharedApplication];
    [QZHNotification addObserver:self
    selector:@selector(applicationWillEnterForeground)
                                                 name:UIApplicationDidBecomeActiveNotification
    object:app];
    [QZHNotification addObserver:self
    selector:@selector(applicationWillEnterBackground)
                                                 name:UIApplicationDidEnterBackgroundNotification
    object:app];
    [QZHNotification addObserver:self
    selector:@selector(applicationWillResignActive)
                                                 name:UIApplicationWillResignActiveNotification
    object:app];
//    [QZHNotification addObserver:self
//    selector:@selector(applicationDidBecomeActive)
//                                                 name:UIApplicationDidBecomeActiveNotification
//    object:app];
    self.device.delegate = self;
    self.talkType = [[QZHDataHelper readValueForKey:@"talkType"] boolValue];
    self.private =  [[self.dpManager valueForDP:TuyaSmartCameraBasicPrivateDPName] boolValue];
    self.isAwake = YES;
    if ([QZHDeviceStatus deviceIsBattery:self.deviceModel]) {
        self.isAwake = [self.deviceModel.dps[@"149"] boolValue];
        [self setConfigsWhenIsAwake];
    }

    if (self.private) {
        [self startPrivateModel];
    }else{
        [self.camera stopPlayback];
        [self closePrivateModel];
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if (_camera) {
        self.camera.delegate = nil;
        self.device.delegate = nil;
        [self.talkHud hide:YES];
        [self cameraStopPreview];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = QZHKIT_COLOR_LEADBACK;
    [self UIConfig];
    [self setConfigs];
    [self.camera getHD];
    self.isMuted = YES;
    self.dpManager = [[TuyaSmartCameraDPManager alloc] initWithDeviceId:self.deviceModel.devId];
    self.device = [TuyaSmartDevice deviceWithDeviceId:self.deviceModel.devId];
    self.deviceModel = self.device.deviceModel;
      // 添加 DP 监听
    self.device.delegate = self;
    [self.dpManager addObserver:self];
    if ([QZHDeviceStatus deviceIsBattery:self.deviceModel]) {
        bool isAwake = [self.deviceModel.dps[@"149"] boolValue];
        if (!isAwake) {
            [self startAwakeDevice];
        }
    }
    [self getWifiSignalStrength];
    [self getBatteryStrength];
}

- (void)UIConfig{

    [self.view addSubview:self.qzTableView];
    [_qzTableView addSubview:self.talkBigView];
    [_talkBigView addSubview:self.talkBtn];
    _talkBigView.hidden = YES;
    [self.talkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.width.height.mas_equalTo(70);
        make.top.mas_equalTo(50);
    }];
    float height = 70;
    if ([self.deviceModel.productId isEqualToString:AC_PRODUCT_ID]) {
        height = 0;
    }
    float talkHeight = 90 * QZHScaleWidth + QZHScreenWidth *1080/1920.0 + height;
    self.talkBigView.frame = CGRectMake(0, talkHeight, QZHScreenWidth, QZHScreenHeight - talkHeight);
    [self.qzTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0 ));
    }];
    
    [self exp_addRightItemTitle:QZHLoaclString(@"setting_setting") itemIcon:@""];
}
- (void)exp_rightAction{

    if (self.recording) {
        [[QZHHUD HUD] textHUDWithMessage:@"录制中,请先停止录制" afterDelay:1.0];
        return;
    }
    if (self.talking || self.talkBigView.hidden == NO) {
        [[QZHHUD HUD] textHUDWithMessage:@"对话中,请先停止对话" afterDelay:1.0];
        return;
    }
    
    [self disconnectCamera];
    self.connected = NO;
    DeviceSettingVC *vc = [[DeviceSettingVC alloc] init];
    vc.deviceModel = self.deviceModel;
    vc.homeModel = self.homeModel;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)setConfigs{
    if (self.connected) {
        [self cameraStartPreview];
        return;
    }

    self.playView.playBtn.hidden = YES;
    [self creatP2PConnectChannel];
}
#pragma mark -建立P2P连接通道,创建相机
- (void)creatP2PConnectChannel{
    // deviceModel 为设备列表中的摄像机设备的数据模型
    id p2pType = [self.deviceModel.skills objectForKey:@"p2pType"];
       [[TuyaSmartRequest new] requestWithApiName:kTuyaSmartIPCConfigAPI postData:@{@"devId": self.deviceModel.devId} version:kTuyaSmartIPCConfigAPIVersion success:^(id result) {
           TuyaSmartCameraConfig *config = [TuyaSmartCameraFactory ipcConfigWithUid:[TuyaSmartUser sharedInstance].uid localKey:self.deviceModel.localKey configData:result];
           self.camera = [TuyaSmartCameraFactory cameraWithP2PType:p2pType config:config delegate:self];
           if (!self.private) {
               [self connectCamera];
           }

       } failure:^(NSError *error) {
          [[QZHHUD HUD] textHUDWithMessage:error.userInfo[@"NSLocalizedDescription"] afterDelay:0.5];
       }];
}
#pragma mark -- 连接摄像机
- (void)connectCamera{
    if (self.camera) {
        [self.camera.videoView tuya_clear];
    }
    [self startPlayGif];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [self.camera connect];

    });
    
}
#pragma mark -- 断开连接摄像机
- (void)disconnectCamera{

    if (self.camera) {
        [self.camera.videoView tuya_clear];
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [self.camera disConnect];

    });
    
}
#pragma mark -- 开始播放视频
- (void)cameraStartPreview{
    [self startPlayGif];
    [self.camera.videoView tuya_clear];
    [self.camera startPreview];
}
#pragma mark -- 停止播放视频
- (void)cameraStopPreview{
    [self.camera.videoView tuya_clear];
    [self.camera stopPreview];
}
#pragma mark -- 播放加载动画
- (void)startPlayGif{
    [self.playView.playPreGif startPlayGifWithImages:@[@"img_loading_anima1",@"img_loading_anima2",@"img_loading_anima3"]];
    self.playView.playPreGif.hidden = NO;

}
#pragma mark -- 关闭加载动画
- (void)stopPlayGif{
    [self.playView.playPreGif stopGif];
}
#pragma mark -- 开启隐私模式
- (void)startPrivateModel{
    [[QZHHUD HUD] textHUDWithMessage:@"隐私模式开启" afterDelay:1.0];
    [self cameraStopPreview];
    [self disconnectCamera];
    self.privateView.hidden = !self.private;
    [self.qzTableView reloadData];
}
#pragma mark -- 关闭隐私模式
- (void)closePrivateModel{
    self.camera.delegate = self;
    if (self.connected) {
        [self cameraStartPreview];
    }else{
        [self connectCamera];
    }
    self.privateView.hidden = !self.private;
    [self.qzTableView reloadData];

}
- (void)showAlertViewHor:(NSString *)text{
    [MBProgressHUD showError:text toView:self.playView];

}
#pragma mark -tableView
-(UITableView *)qzTableView{
    if (!_qzTableView) {
        _qzTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [_qzTableView exp_tableViewDefault];
        self.qzTableView.backgroundColor = QZHKIT_COLOR_LEADBACK;
        self.qzTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _qzTableView.delegate = self;
        _qzTableView.dataSource = self;
        [self.qzTableView registerClass:[CameraTBtnCell class] forCellReuseIdentifier:QZHCELL_REUSE_IMAGE];
        [self.qzTableView registerClass:[CameraThreeBtnCell class] forCellReuseIdentifier:QZHCELL_REUSE_TEXT];
        [self.qzTableView registerClass:[OnLiveCell class] forCellReuseIdentifier:QZHCELL_REUSE_FIELD];

        [self.qzTableView registerClass:[CameraListCell class] forCellReuseIdentifier:QZHCELL_REUSE_DEFAULT];
    }
    return _qzTableView;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = indexPath.row;
    QZHWS(weakSelf)
    if (row == 0) {
        
        if ([self.deviceModel.productId isEqualToString:AC_PRODUCT_ID]) {
            return [UITableViewCell new];
        }
        CameraTBtnCell *cell = [tableView dequeueReusableCellWithIdentifier:QZHCELL_REUSE_IMAGE];
        cell.btnBlock = ^(NSInteger tag) {
            [weakSelf deviceHandle:tag];
        };

        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if (row == 1) {
        OnLiveCell *cell = [tableView dequeueReusableCellWithIdentifier:QZHCELL_REUSE_FIELD];
        [cell.contentView addSubview:self.playView];
        self.playView.frame= CGRectMake(0, 0, QZHScreenWidth, QZHScreenWidth * 1080/1920);
        [_playView addSubview:self.camera.videoView];
        [_playView addSubview:self.privateView];
        [self.camera.videoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0  ));
        }];
        [self.privateView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0  ));
        }];
        [self.playView sendSubviewToBack:self.camera.videoView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if (row == 2) {
        
        CameraThreeBtnCell *cell = [tableView dequeueReusableCellWithIdentifier:QZHCELL_REUSE_TEXT];
        cell.btnBlock = ^(UIButton *sender, BOOL select) {
            if (weakSelf.private ) {
                [[QZHHUD HUD] textHUDWithMessage:@"隐私模式下不能操作" afterDelay:1.0];
                return ;
            }
            if (!weakSelf.previewing) {
                
                [[QZHHUD HUD] textHUDWithMessage:@"正常播放时才能进行操作" afterDelay:1.0];
                return;
            }

            if (weakSelf.previewing) {
                [weakSelf videoHandle:sender isselected:sender.selected];
            }
        };
        if (self.private) {
            cell.contentView.alpha = 0.5;
            cell.contentView.userInteractionEnabled = NO;
        }else{
            cell.contentView.alpha = 1.0;
            cell.contentView.userInteractionEnabled = YES;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if (row == 3) {
        CameraListCell *cell = [tableView dequeueReusableCellWithIdentifier:QZHCELL_REUSE_DEFAULT];
        cell.nameLab.text = @"    相册管理";
        cell.IMGView.image = QZHLoadIcon(@"ic_all_doc");
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        return cell;
    }else{
        CameraListCell *cell = [tableView dequeueReusableCellWithIdentifier:QZHCELL_REUSE_DEFAULT];
        cell.nameLab.text = @"    历史回看";
        cell.IMGView.image = QZHLoadIcon(@"ic_all_safety");
        if (self.private) {
            cell.contentView.alpha = 0.5;
            cell.userInteractionEnabled = NO;
        }else{
            cell.contentView.alpha = 1.0;
            cell.userInteractionEnabled = YES;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
 
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

-(void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section{
    view.tintColor = QZHKIT_COLOR_LEADBACK;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = indexPath.row;
    if (row == 1) {
        return QZHScreenWidth *1080/1920.0;
    }
    if (row == 2) {
        return 90 * QZHScaleWidth;
    }
    if (row == 0) {
        if ([self.deviceModel.productId isEqualToString:AC_PRODUCT_ID]) {
            return 0;
        }
    }
    return 70;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0 || indexPath.row == 1|| indexPath.row == 2) {
        return;
    }
    
    if (self.recording) {
        [[QZHHUD HUD] textHUDWithMessage:@"录制中,请先停止录制" afterDelay:1.0];
        return;
    }
    if (self.talking || self.talkBigView.hidden == NO) {
        [[QZHHUD HUD] textHUDWithMessage:@"对话中,请先停止对话" afterDelay:1.0];
        return;
    }
    NSInteger row = indexPath.row;
    if (row == 3) {
        [self disconnectCamera];
        self.connected = NO;
        PhotosVC *vc = [[PhotosVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (row == 4) {
//        if ([[self.dpManager valueForDP:TuyaSmartCameraSDCardStatusDPName] intValue] == 5) {
//            [[QZHHUD HUD] textHUDWithMessage:@"该设备没有存储卡不能回放" afterDelay:1.0];
//
//        }else{

        BackPlayVC *vc = [[BackPlayVC alloc] init];
        vc.deviceModel = self.deviceModel;
        if (self.private) {
            
        }else{
            vc.backCamera = self.camera;
        }
        [self.navigationController pushViewController:vc animated:YES];
//        }
    }
}

- (NSMutableArray *)listArr{
    if (!_listArr){
        _listArr = [NSMutableArray arrayWithArray:@[QZHLoaclString(@"mine_shareDevices"),QZHLoaclString(@"mine_commonQuestions"),QZHLoaclString(@"mine_familyManagement"),QZHLoaclString(@"mine_currentVersion")]];
    }
    return _listArr;
}

-(NSMutableArray *)logoArr{
    if (!_logoArr) {
        _logoArr = [NSMutableArray arrayWithArray:@[@"about",@"lianxi",@"shezhi",@"shezhi"]];
    }
    return _logoArr;
}


#pragma mark -- 摄像机代理camerDelegate

-(void)cameraDidConnected:(id<TuyaSmartCameraType>)camera{
    
    self.connected = YES;
    if ([self.deviceModel.productId isEqualToString:BATTERY_PRODUCT_ID]) {
            self.playView.wifiIMG.hidden = NO;
            self.playView.batteryIMG.hidden = NO;
    }
    [self cameraStartPreview];

}
-(void)cameraDisconnected:(id<TuyaSmartCameraType>)camera{
      // p2p 连接被动断开，一般为网络波动导致
    self.connected = NO;
    self.previewing = NO;
    if ([QZHDeviceStatus deviceIsBattery:self.deviceModel]) {
        if (!self.isAwake) {
            return;
        }
    }

    [self stopPlayGif];
    [self connectCamera];
    
}
-(void)cameraDidStartRecord:(id<TuyaSmartCameraType>)camera{
    [self startRecordTimer];
    self.recording = YES;
    self.playView.voiceBtn.alpha = 0.5;
    self.playView.voiceBtn.userInteractionEnabled = NO;
    self.recordTime = [[NSDate date] timeIntervalSince1970];
}
-(void)cameraDidStopRecord:(id<TuyaSmartCameraType>)camera{
    self.recording = NO;
    self.playView.voiceBtn.alpha = 1.0;
    self.playView.voiceBtn.userInteractionEnabled = YES;
}

-(void)cameraDidBeginPreview:(id<TuyaSmartCameraType>)camera{
    
    self.previewing = YES;
    self.playView.playBtn.hidden = YES;
    if (self.isHor) {
        [_playView addSubview:self.camera.videoView];
        [self.camera.videoView mas_makeConstraints:^(MASConstraintMaker *make) {
           make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0  ));
        }];
        [self.playView sendSubviewToBack:self.camera.videoView];
        
    }else{
        [self.qzTableView reloadData];
    }
    [self.camera enableMute:self.isMuted forPlayMode:TuyaSmartCameraPlayModePreview];
    [self stopPlayGif];

}
-(void)cameraDidStopPreview:(id<TuyaSmartCameraType>)camera{
    self.previewing = NO;
    if (self.talking) {
        [self stopTalk];
    }
    if (self.recording) {
        [self.camera stopRecord];
    }
}
-(void)cameraDidStopPlayback:(id<TuyaSmartCameraType>)camera{
    NSLog(@"onlivecamer -------   stop playback  ");
}
-(void)cameraDidBeginPlayback:(id<TuyaSmartCameraType>)camera{
    NSLog(@"onlivecamer --------------   begain playback  ");
}
- (void)camera:(id<TuyaSmartCameraType>)camera didReceiveTimeSliceQueryData:(NSArray<NSDictionary *> *)timeSlices {
 
}

- (void)camera:(id<TuyaSmartCameraType>)camera ty_didReceiveVideoFrame:(CMSampleBufferRef)sampleBuffer frameInfo:(TuyaSmartVideoFrameInfo)frameInfo {

}
-(void)camera:(id<TuyaSmartCameraType>)camera didOccurredErrorAtStep:(TYCameraErrorCode)errStepCode specificErrorCode:(NSInteger)errorCode{
    [self.talkHud hide:YES];
     if (errStepCode == TY_ERROR_CONNECT_FAILED) {
         [[QZHHUD HUD] textHUDWithMessage:@"连接失败,正在重连" afterDelay:1.0];
          // p2p 连接失败
        self.connected = NO;
         if ([QZHDeviceStatus deviceIsBattery:self.deviceModel]) {
             if (!self.isAwake) {
                 return;
             }
         }
         [self connectCamera];
    }else if (errStepCode == TY_ERROR_START_PREVIEW_FAILED) {
        [[QZHHUD HUD] textHUDWithMessage:@"预览播放失败" afterDelay:1.0];
          // 实时视频播放失败
        self.previewing = NO;
        if ([QZHDeviceStatus deviceIsBattery:self.deviceModel]) {
            if (!self.isAwake) {
                return;
            }
        }
        [self connectCamera];
    }else
    
    if (errStepCode == TY_ERROR_START_TALK_FAILED) {
        [self stopTalkTimer];
        // 开启对讲失败，重新打开声音
//        if (self.isMuted) {
//            [self.camera enableMute:NO forPlayMode:TuyaSmartCameraPlayModePreview];
//        }
    }
    else if (errStepCode == TY_ERROR_ENABLE_MUTE_FAILED) {
                // 设置静音状态失败
//        self.isMuted = NO;
    }else
    
    if (errStepCode == TY_ERROR_ENABLE_HD_FAILED) {
                // 切换视频清晰度失败
    }else if (errorCode == TY_ERROR_RECORD_FAILED){
        self.recording = NO;
        [self stopRecordTimer];
        self.playView.voiceBtn.alpha = 1.0;
        self.playView.voiceBtn.userInteractionEnabled = YES;
    }
}

#pragma mark -- wifi强度
- (void)getWifiSignalStrength {
    [self.device getWifiSignalStrengthWithSuccess:^{

    } failure:^(NSError *error) {
           [[QZHHUD HUD] textHUDWithMessage:error.userInfo[@"NSLocalizedDescription"] afterDelay:0.5];
    }];
}
- (void)getBatteryStrength{
      if ([QZHDeviceStatus deviceIsBattery:self.deviceModel]) {
        int type = [[self.dpManager valueForDP:TuyaSmartCameraWirelessPowerModeDPName] intValue];
        int strength = [[self.dpManager valueForDP:TuyaSmartCameraWirelessElectricityDPName] intValue];
        NSString *imgStr;
        //0 电池  1 电源
        if (type) {
            if (strength < 25) {
                imgStr = @"ic_battery_charging_0_24";
            }else if (strength < 50){
                imgStr = @"ic_battery_charging_25_49";
            }else if (strength < 75){
                imgStr = @"ic_battery_charging_50_74";
            }else{
                imgStr = @"ic_battery_charging_75_100";
            }
            
        }else{
            if (strength < 10) {
                imgStr = @"ic_battery_0_9";
            }else if (strength < 20){
                imgStr = @"ic_battery_10_19";
            }else if (strength < 25){
                imgStr = @"ic_battery_20_24";
            }else if (strength < 50){
                imgStr = @"ic_battery_25_49";
            }else if (strength < 75){
                imgStr = @"ic_battery_50_74";
            }else if (strength < 100){
                imgStr = @"ic_battery_75_99";
            }else{
                imgStr = @"ic_battery_100";
            }
        }
        self.playView.batteryIMG.image = QZHLoadIcon(imgStr);
    }
    
}
#pragma mark - TuyaSmartDeviceDelegate

-(void)device:(TuyaSmartDevice *)device dpsUpdate:(NSDictionary *)dps{
    if ([dps jk_hasKey:@"105"]) {
            if ([dps[@"105"] boolValue]) {
            self.private = YES;
                if (self.isHor) {
                    [self scrollHor:NO];
                }
            [self startPrivateModel];

        }else{
            self.private = NO;
            [self closePrivateModel];
        }
    }
    
    if ([QZHDeviceStatus deviceIsBattery:self.deviceModel]) {
        if ([dps jk_hasKey:@"146"]) {//电池电量
            [self getBatteryStrength];
        }
        if ([dps jk_hasKey:@"149"]) {//设备状态  YES唤醒  NO休眠
            if ([dps[@"149"] boolValue]) {
                self.isAwake = YES;
                
                [[QZHHUD HUD] textHUDWithMessage:@"唤醒成功" afterDelay:1.0];

            }else{
                self.isAwake = NO;
                [[QZHHUD HUD] textHUDWithMessage:@"休眠成功" afterDelay:1.0];

            }
            [self setConfigsWhenIsAwake];
        }
    }
}
- (void)setConfigsWhenIsAwake{
    
    self.playView.wifiIMG.hidden = !self.isAwake;
    self.playView.batteryIMG.hidden = !self.isAwake;
    self.playView.playBtn.hidden = self.isAwake;
    if (!self.playView.wifiIMG.hidden) {
        [self getWifiSignalStrength];
        
    }

}
//WiFi信号状态代理
- (void)device:(TuyaSmartDevice *)device signal:(NSString *)signal {
    NSInteger wifi = [signal integerValue];
    if (wifi < -80) {
        self.playView.wifiIMG.image = QZHLoadIcon(@"wifi_0");
    } else if (wifi < -65) {
        self.playView.wifiIMG.image = QZHLoadIcon(@"wifi_1");
    } else if (wifi < -50) {
        self.playView.wifiIMG.image = QZHLoadIcon(@"wifi_2");
    } else {
        self.playView.wifiIMG.image = QZHLoadIcon(@"wifi_3");
    }
}

#pragma mark -- 视频控制
//直播属性设置
- (void)onLivePlayHandle:(NSInteger )tag isselected:(BOOL)select{

    //sender.tag == 0) {
         //播放
    if (tag == 0) {
        [self startAwakeDevice];
        self.playView.playBtn.hidden = YES;
    }else if(tag == 1){
        //sender.tag == 1){

            //声音
        if (self.talkType && self.talking) {
            [self stopTalk];
        }

        [self.camera enableMute:select forPlayMode:TuyaSmartCameraPlayModePreview];
        
    }else if (tag == 2){
        //sender.tag == 2){
              //清晰度
        [self changeHD];
        
    }else if(tag == 3){
        //sender.tag == 3){
              //横屏
        [self scrollHor:select];
    }
}
//操作视频
- (void)videoHandle:(UIButton *)sender isselected:(BOOL)selected{
    NSInteger tag = sender.tag;

    if (tag == -1 || tag == 101) {
        //录像
        if (!sender.selected) {
            PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
            if (status == PHAuthorizationStatusRestricted || status == PHAuthorizationStatusDenied)
            {
                [self goMicroPhoneSetTitle:@"您还没有允许相册权限"];

            }else if(status == AVAuthorizationStatusNotDetermined){
              [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                  if(status == PHAuthorizationStatusAuthorized) {
  
                  } else {

                  }
              }];
                
            }else{
                sender.selected = !sender.selected;
                [self.camera startRecord];
                self.recording = YES;
            }
        }else{
            sender.selected = !sender.selected;
            [self.camera stopRecord];
            self.recording = NO;
            self.playView.voiceBtn.alpha = 1.0;
            self.playView.voiceBtn.userInteractionEnabled = YES;
            self.recordTime = [[NSDate date] timeIntervalSince1970] - self.recordTime;
             if (self.recordTime < 1) {
                 if (self.isHor) {
                     [self showAlertViewHor:@"录制时间短于1S可能导致存储失败"];
                 }else{
                     [[QZHHUD HUD] textHUDWithMessage:@"录制时间短于1S可能导致存储失败" afterDelay:1.0];
                 }
             }
            [self stopRecordTimer];

        }
    }else if (tag == 0 || tag == 102){
        //通话
        if (!sender.selected) {
            AVAuthorizationStatus microPhoneStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
              switch (microPhoneStatus) {
                  case AVAuthorizationStatusDenied:
                  case AVAuthorizationStatusRestricted:
                  {
                      // 被拒绝
                      [self goMicroPhoneSetTitle:@"您还没有允许麦克风权限"];
                  }
                      break;
                  case AVAuthorizationStatusNotDetermined:
                  {
                      // 没弹窗
                      [self requestMicroPhoneAuth];
                  }
                      break;
                  case AVAuthorizationStatusAuthorized:
                  {
                      sender.selected = !sender.selected;
                      if (self.isHor) {
                          [self startTalk];
                      }else{
                          if (self.talkType) {
                              self.talkBigView.hidden = NO;
                          }else{
                              [self startTalk];
                              
                          }
                      }

                  }
                      break;

                  default:
                      break;
              }
        }else {
            sender.selected = !sender.selected;
            if (self.isHor) {
                [self stopTalk];
            }else{
                if (self.talkType) {
                    self.talkBigView.hidden = YES;
                }else{
                    [self stopTalk];
                }
            }
        }
    }else if(tag == 1 || tag == 103){
         PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
          if (status == PHAuthorizationStatusRestricted || status == PHAuthorizationStatusDenied)
          {
              [self goMicroPhoneSetTitle:@"您还没有允许相册权限"];

          }else if(status == AVAuthorizationStatusNotDetermined){
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                if(status == PHAuthorizationStatusAuthorized) {

                } else {

                }
            }];
              
          }else{
              sender.selected = !sender.selected;
              if (self.previewing) {
                  if ([self.camera snapShoot]) {
                      // 截图已成功保存到手机相册
                      if (self.isHor) {
                          [MBProgressHUD showError:@"截图成功并保存到相册" toView:self.playView];
                      }else{
                          [[QZHHUD HUD] textHUDWithMessage:@"截图成功并保存到相册" afterDelay:0.5];
                      }
                  }
              }
          }

    }
}
//设备
- (void)deviceHandle:(NSInteger)tag{
    if (tag == -1) {
        //唤醒
        [self startAwakeDevice];
    }else{
        //休眠
        [self cameraStopPreview];
    
        NSDictionary  *dps = @{@"231": @(NO)};
        [self.device publishDps:dps success:^{
              NSLog(@"publishDps success");
//            [[QZHHUD HUD] textHUDWithMessage:@"休眠成功" afterDelay:1.0];
              //下发成功，状态上报通过 deviceDpsUpdate方法 回调
//              [self.camera.videoView removeFromSuperview];
            [self.camera pausePlayback];
            self.playView.playBtn.hidden = NO;
            if ([self.deviceModel.productId isEqualToString:BATTERY_PRODUCT_ID]) {
                self.playView.wifiIMG.hidden = YES;
                self.playView.batteryIMG.hidden = YES;
            }
            self.connected = NO;
            self.previewing = NO;
          } failure:^(NSError *error) {
              [[QZHHUD HUD] textHUDWithMessage:error.userInfo[@"NSLocalizedDescription"] afterDelay:0.5];
          }];
    }
}

#pragma mark -- 唤醒设备
// 判断是否是低功耗门铃
- (BOOL)isDoorbell {
    return [self.dpManager isSupportDP:TuyaSmartCameraWirelessAwakeDPName];
}

/// 唤醒设备(电池版)
- (void)startAwakeDevice {
    if ([self isDoorbell]) {
        [self.device awakeDeviceWithSuccess:^{
//            [[QZHHUD HUD] textHUDWithMessage:@"唤醒成功" afterDelay:1.0];
            [self setConfigs];
            
        } failure:^(NSError *error) {
           [[QZHHUD HUD] textHUDWithMessage:error.userInfo[@"NSLocalizedDescription"] afterDelay:0.5];
            
        }];
    }
}

#pragma mark -- 清晰度
- (void)changeHD {
    [self.camera enableHD:!self.HD];
}

// 视频分辨率改变的代理方法，实时视频直播或者录像回放刚开始时也会调用
- (void)camera:(id<TuyaSmartCameraType>)camera resolutionDidChangeWidth:(NSInteger)width height:(NSInteger)height {
        // 获取当前的清晰度
    [self.camera getHD];
}

// 清晰度状态代理方法
- (void)camera:(id<TuyaSmartCameraType>)camera didReceiveDefinitionState:(BOOL)isHd {
    self.HD = isHd;
    if (self.HD) {
        [self.playView.definitionBtn setTitle:@"高清" forState:UIControlStateNormal];
    }else{
        [self.playView.definitionBtn setTitle:@"标清" forState:UIControlStateNormal];

    }
}

#pragma mark -- 声音开关
- (void)camera:(id<TuyaSmartCameraType>)camera didReceiveMuteState:(BOOL)isMute playMode:(TuyaSmartCameraPlayMode)playMode;
{
    self.isMuted = isMute;
    self.playView.voiceBtn.selected = isMute;

}
#pragma mark -- 对讲
- (void)startTalk {
    if (self.isHor) {
        self.talkHud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        self.talkHud.labelText = @"建立通话通道中";
        self.talkHud.transform = CGAffineTransformMakeRotation(90*M_PI/180);

    }else{
        self.talkHud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        self.talkHud.labelText = @"建立通话通道中";
    }

    [self.talkHud show:YES];
    [self.camera startTalk];
}

- (void)stopTalk {
    [self.camera stopTalk];
}

- (void)cameraDidBeginTalk:(id<TuyaSmartCameraType>)camera {
    [self.talkHud hide:YES];

        // 对讲已成功开启
    [self startTalkTimer];
    self.talking = YES;
    if (self.isHor) {
        [self.camera enableMute:NO forPlayMode:TuyaSmartCameraPlayModePreview];

    }else{
        if (self.talkType) {
            
            [self.camera enableMute:YES forPlayMode:TuyaSmartCameraPlayModePreview];
        }else{
            [self.camera enableMute:NO forPlayMode:TuyaSmartCameraPlayModePreview];
        }
    }
}

- (void)cameraDidStopTalk:(id<TuyaSmartCameraType>)camera {
        // 对讲已停止
        // 如果是静音状态，打开声音
    if (self.isMuted) {
        [self.camera enableMute:NO forPlayMode:TuyaSmartCameraPlayModePreview];
    }
    
    [self stopTalkTimer];
    self.talking = NO;
}

#pragma mark -- e横向转屏
- (void)scrollHor:(BOOL) isHor{
    self.statusHiden = isHor;
    
    // 刷新状态栏
    [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    self.isHor = isHor;
    [self.playView removeFromSuperview];

    if (isHor) {
        self.playView.videoRecordBtn.hidden = NO;
        self.playView.videoTalkBtn.hidden = NO;
        self.playView.videoPhotoBtn.hidden = NO;
        [UIView animateWithDuration:0 animations:^{
            self.playView.transform = CGAffineTransformMakeRotation(90*M_PI/180);
            self.playView.frame = CGRectMake(0, 0, QZHScreenWidth, QZHScreenHeight - 1);
            self.camera.videoView.frame = CGRectMake(0, 0, QZHScreenHeight , QZHScreenWidth);
            [self.playView.voiceBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(QZH_VIDEO_LEFTMARGIN + 10);
            }];

        }];
        [self.navigationController.view addSubview:self.playView];

    }else{
        OnLiveCell *cell = [self.qzTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
        self.playView.videoRecordBtn.hidden = YES;
        self.playView.videoTalkBtn.hidden = YES;
        self.playView.videoPhotoBtn.hidden = YES;

        
        [UIView animateWithDuration:0 animations:^{
            self.playView.transform = CGAffineTransformMakeRotation(0*M_PI/90);

            self.playView.frame = CGRectMake(0, 0, QZHScreenWidth, QZHScreenWidth * 1080/1920);
            self.camera.videoView.frame = CGRectMake(0, 0, QZHScreenWidth , QZHScreenWidth *1080/1920);
            [self.playView.voiceBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(10);
            }];

            [cell.contentView addSubview:self.playView];
            [cell.contentView sendSubviewToBack:self.playView];
        }];

    }
}

-(CameraPlayView *)playView{
    if (!_playView) {

QZHWS(weakSelf)
        _playView = [[CameraPlayView alloc] init];
        id traget = self.navigationController.interactivePopGestureRecognizer.delegate;
        UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc]initWithTarget:traget action:nil];
        [_playView addGestureRecognizer:pan];

        _playView.buttonBlock = ^(UIButton *sender, BOOL selected) {
            if (weakSelf.private) {
                [[QZHHUD HUD] textHUDWithMessage:@"隐私模式下不能操作" afterDelay:1.0];
                return;
            }
            if (!weakSelf.previewing && sender.tag !=0 && !(sender.tag == 3 && weakSelf.isHor)) {
                [[QZHHUD HUD] textHUDWithMessage:@"正常播放时才能进行操作" afterDelay:1.0];
                return;
            }
            if (weakSelf.recording && sender.tag ==1) {
                [[QZHHUD HUD] textHUDWithMessage:@"录屏时不能操作" afterDelay:1.0];
                return;
            }
            if ((weakSelf.recording || weakSelf.talking) && sender.tag == 3) {
                if (weakSelf.isHor) {
                    [MBProgressHUD showError:@"请先关闭录制或者通话" toView:weakSelf.playView];
                }else{
                    [[QZHHUD HUD] textHUDWithMessage:@"请先关闭录制或者通话" afterDelay:1.0];
                }
                return;
            }
            if (sender.tag > 100) {
                [weakSelf videoHandle:sender isselected:sender.selected];
            }else{
                sender.selected = !sender.selected;
                [weakSelf onLivePlayHandle:sender.tag isselected:sender.selected];
            }
        };
    }
    return _playView;
}
- (void)startRecordTimer{
    if (self.recordTimer) {
        [self stopRecordTimer];
    }
    self.recordSecond = 0;
    self.playView.recordProgressView.hidden = NO;
    if (self.talking) {
        [self.playView.recordProgressView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(_isHor?-110:-65);
        }];
    }else{
        [self.playView.recordProgressView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(_isHor?-60:-15);
        }];
    }
    self.recordTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(recordTimerAction:) userInfo:nil repeats:YES];
}
- (void)startTalkTimer{
    if (self.talkTimer) {
        [self stopTalkTimer];
    }
    self.talkSecond = 0;
    self.playView.talkProgressView.hidden = NO;
    if (self.recording) {
        [self.playView.talkProgressView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(_isHor?-110:-65);
        }];
    }else{
        [self.playView.talkProgressView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(_isHor?-60:-15);
        }];
    }
    self.talkTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(talkTimerAction:) userInfo:nil repeats:YES];
}
- (void)stopRecordTimer{
    self.playView.recordProgressView.hidden = YES;
    if (self.talking) {
        [self.playView.talkProgressView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(_isHor?-60:-15);
        }];
    }
    [self.recordTimer invalidate];
    self.recordTimer = nil;
    self.playView.recordProgressView.timeLab.text = @"00:00";
}
- (void)stopTalkTimer{
    self.playView.talkProgressView.hidden = YES;
    if (self.recording) {
        [self.playView.recordProgressView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(_isHor?-60:-15);
        }];
    }
    [self.talkTimer invalidate];
    self.talkTimer = nil;
    self.playView.talkProgressView.timeLab.text = @"00:00";
}

- (void)recordTimerAction:(NSTimer *)tiemr{
    self.recordSecond++;
    NSInteger min = self.recordSecond/60;
    NSInteger sec = self.recordSecond%60;
    self.playView.recordProgressView.timeLab.text = [NSString stringWithFormat:@"%02ld:%02ld",(long)min,sec];
}
- (void)talkTimerAction:(NSTimer *)tiemr{
    self.talkSecond++;
    NSInteger min = self.talkSecond/60;
    NSInteger sec = self.talkSecond%60;
    self.playView.talkProgressView.timeLab.text = [NSString stringWithFormat:@"%02ld:%02ld",(long)min,sec];
}
#pragma mark -- lazy
-(UIView *)privateView{
    if (!_privateView) {
        _privateView = [[UIView alloc] init];
        _privateView.backgroundColor = UIColor.blackColor;
        UILabel *lab = [[UILabel alloc] init];
        lab.text = @"隐私模式已开启";
        lab.font = QZHKIT_FONT_LISTCELL_MAIN_TITLE;
        lab.textColor = QZH_KIT_Color_WHITE_70;
        [_privateView addSubview:lab];
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(_privateView);
        }];
    }
    return _privateView;
}

-(UIView *)talkBigView{
    if (!_talkBigView) {
        _talkBigView = [[UIView alloc] init];
        _talkBigView.backgroundColor = UIColor.whiteColor;
        UILabel *lab = [[UILabel alloc] init];
        lab.text = @"按住讲话";
        lab.frame = CGRectMake(0, 15, QZHScreenWidth, 20);
        lab.textAlignment = NSTextAlignmentCenter;
        [_talkBigView addSubview:lab];
    }
    return _talkBigView;
}
- (UIButton *)talkBtn{
    if (!_talkBtn) {
        _talkBtn = [[UIButton alloc] init];
        [_talkBtn setImage:QZHLoadIcon(@"ic_talkback_n") forState:UIControlStateNormal];
        [_talkBtn setImage:QZHLoadIcon(@"ic_talkback_p") forState:UIControlStateSelected];
        UILongPressGestureRecognizer *tap = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(pressGestuerAction:)];
        [_talkBtn addGestureRecognizer:tap];

    }
    return _talkBtn;
}

#pragma mark  -- 系统消息
- (void)applicationWillEnterForeground{
    if (self.connected) {
        [self.camera startPreview];
    }else{
        [self connectCamera];
    }
}
- (void)applicationWillEnterBackground{
    if (self.camera) {
        if (self.recording) {
            CameraThreeBtnCell *cell = (CameraThreeBtnCell *)[self.qzTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
            cell.leftBtn.selected = NO;
            [self videoHandle:cell.leftBtn isselected:cell.leftBtn.selected];
            
        }
        if (self.talking) {
            CameraThreeBtnCell *cell = [self.qzTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
            cell.midBtn.selected = NO;
            [self videoHandle:cell.midBtn isselected:cell.midBtn.selected];
            
        }

        [self cameraStopPreview];
        [self disconnectCamera];
        self.connected = NO;
    }
}
- (void)applicationWillResignActive{
    [self.camera stopPreview];
}
////获取焦点
//- (void)applicationDidBecomeActive{
//    [self connectCamera];
//}

- (void)pressGestuerAction:(UILongPressGestureRecognizer *)longPress{
    if (longPress.state == UIGestureRecognizerStateBegan) {
        [self.camera startTalk];
        self.talkBtn.selected = YES;
    }
    if (longPress.state == UIGestureRecognizerStateEnded) {
        [self.camera stopTalk];
        self.talkBtn.selected = NO;
    }
}
- (BOOL)prefersStatusBarHidden{

    return self.statusHiden;
}

-(void) requestMicroPhoneAuth
{
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {

    }];
}
-(void) goMicroPhoneSetTitle:(NSString *)title
{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:title message:@"去设置一下吧" preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

    }];
    UIAlertAction * setAction = [UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            [UIApplication.sharedApplication openURL:url options:nil completionHandler:^(BOOL success) {

            }];
        });
    }];

    [alert addAction:cancelAction];
    [alert addAction:setAction];

    [self presentViewController:alert animated:YES completion:nil];
}

@end
