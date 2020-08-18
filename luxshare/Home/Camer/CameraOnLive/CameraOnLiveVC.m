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
@property (strong, nonatomic)NSTimer *timer;
@property (assign, nonatomic)NSInteger second;
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
@end

@implementation CameraOnLiveVC
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    UIApplication *app = [UIApplication sharedApplication];
    [QZHNotification addObserver:self
    selector:@selector(applicationWillEnterForeground)
                                                 name:UIApplicationWillEnterForegroundNotification
    object:app];
    [QZHNotification addObserver:self
    selector:@selector(applicationWillEnterBackground)
                                                 name:UIApplicationWillResignActiveNotification
    object:app];
    self.private =  [[self.dpManager valueForDP:TuyaSmartCameraBasicPrivateDPName] boolValue];
    self.talkType = [[QZHDataHelper readValueForKey:@"talkType"] boolValue];

    self.privateView.hidden = !self.private;
    if (self.private) {
        [[QZHHUD HUD] textHUDWithMessage:@"隐私模式开启" afterDelay:1.0];
    }
    [self setConfigs];

}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.camera stopPreview];
    self.connected = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = QZHKIT_COLOR_LEADBACK;
    [self UIConfig];
    [self.camera getHD];
    self.isMuted = YES;
    self.dpManager = [[TuyaSmartCameraDPManager alloc] initWithDeviceId:self.deviceModel.devId];
    self.device = [TuyaSmartDevice deviceWithDeviceId:self.deviceModel.devId];
      // 添加 DP 监听
    self.device.delegate = self;
    [self.dpManager addObserver:self];
    [self start];
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
    if (self.talking) {
        [[QZHHUD HUD] textHUDWithMessage:@"对话中,请先停止对话" afterDelay:1.0];
        return;
    }
    DeviceSettingVC *vc = [[DeviceSettingVC alloc] init];
    vc.deviceModel = self.deviceModel;
    vc.homeModel = self.homeModel;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)setConfigs{
    if (self.connected) {
        [self.camera startPreview];
        return;
    }
    self.playView.playBtn.hidden = YES;
    [self.playView.playPreGif startPlayGifWithImages:@[@"img_loading_anima1",@"img_loading_anima2",@"img_loading_anima3"]];
    self.playView.playPreGif.hidden = NO;
    // deviceModel 为设备列表中的摄像机设备的数据模型
    id p2pType = [self.deviceModel.skills objectForKey:@"p2pType"];
    [[TuyaSmartRequest new] requestWithApiName:@"tuya.m.rtc.session.init" postData:@{@"devId": self.deviceModel.devId} version:@"1.0" success:^(id result) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            TuyaSmartCameraConfig *config = [TuyaSmartCameraFactory ipcConfigWithUid:[TuyaSmartUser sharedInstance].uid localKey:self.deviceModel.localKey configData:result];
            self.camera = [TuyaSmartCameraFactory cameraWithP2PType:p2pType config:config delegate:self];
            [self.camera connect];

        });

    } failure:^(NSError *error) {
       [[QZHHUD HUD] textHUDWithMessage:error.userInfo[@"NSLocalizedDescription"] afterDelay:0.5];
    }];
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
            if (self.talking && sender.tag == -1) {
                [[QZHHUD HUD] textHUDWithMessage:@"通话中不能录屏" afterDelay:1.0];
                return;
            }
            if (self.recording && sender.tag == 0) {
                [[QZHHUD HUD] textHUDWithMessage:@"录屏中不能通话" afterDelay:1.0];
                return;
            }
            if (weakSelf.previewing) {
                sender.selected = !sender.selected;
                [weakSelf videoHandle:sender.tag isselected:sender.selected];
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
    
    if (self.recording) {
        [[QZHHUD HUD] textHUDWithMessage:@"录制中,请先停止录制" afterDelay:1.0];
        return;
    }
    if (self.talking) {
        [[QZHHUD HUD] textHUDWithMessage:@"对话中,请先停止对话" afterDelay:1.0];
        return;
    }
    NSInteger row = indexPath.row;
    if (row == 3) {
        PhotosVC *vc = [[PhotosVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (row == 4) {
        BackPlayVC *vc = [[BackPlayVC alloc] init];
        vc.deviceModel = self.deviceModel;
        [self.navigationController pushViewController:vc animated:YES];
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


#pragma mark -- camerDelegate

-(void)cameraDidConnected:(id<TuyaSmartCameraType>)camera{
    
    self.connected = YES;
    [self.camera startPreview];

}
-(void)cameraDisconnected:(id<TuyaSmartCameraType>)camera{
      // p2p 连接被动断开，一般为网络波动导致
    self.connected = NO;
    self.previewing = NO;
    [self.playView.playPreGif stopGif];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
       
        [self.camera connect];

    });
    
}
-(void)cameraDidStartRecord:(id<TuyaSmartCameraType>)camera{
    self.playView.recordProgressView.typeLab.text = @"录制中";
    [self startTimer];
    self.recording = YES;
    self.recordTime = [[NSDate date] timeIntervalSince1970];
}
-(void)cameraDidStopRecord:(id<TuyaSmartCameraType>)camera{

    self.recording = NO;
}

-(void)cameraDidBeginPlayback:(id<TuyaSmartCameraType>)camera{
    
}
-(void)cameraDidStopPlayback:(id<TuyaSmartCameraType>)camera{
    
}
-(void)cameraDidBeginPreview:(id<TuyaSmartCameraType>)camera{
    
    self.previewing = YES;
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
    [self.playView.playPreGif stopGif];

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

-(void)camera:(id<TuyaSmartCameraType>)camera didOccurredErrorAtStep:(TYCameraErrorCode)errStepCode specificErrorCode:(NSInteger)errorCode{
     if (errStepCode == TY_ERROR_CONNECT_FAILED) {
          // p2p 连接失败
        self.connected = NO;
         NSLog(@"current thead =%@",[NSThread currentThread]);

    }
    else if (errStepCode == TY_ERROR_START_PREVIEW_FAILED) {
          // 实时视频播放失败
        self.previewing = NO;
    }
    
    if (errStepCode == TY_ERROR_START_TALK_FAILED) {
        // 开启对讲失败，重新打开声音
        if (self.isMuted) {
            [self.camera enableMute:NO forPlayMode:TuyaSmartCameraPlayModePreview];
        }
    }
    else if (errStepCode == TY_ERROR_ENABLE_MUTE_FAILED) {
                // 设置静音状态失败
        self.isMuted = NO;
    }
    
    if (errStepCode == TY_ERROR_ENABLE_HD_FAILED) {
                // 切换视频清晰度失败
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
    if ([self.deviceModel.productId isEqualToString:BATTERY_PRODUCT_ID]) {
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
        [self start];
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
        
    }else{
        //sender.tag == 3){
              //横屏
        [self scrollHor:select];
    }
}
//操作视频
- (void)videoHandle:(NSInteger)tag isselected:(BOOL)selected{
    if (tag == -1) {
        //录像
        if (selected) {
            [self.camera startRecord];
            self.recording = YES;
        }else{
            [self.camera stopRecord];
            self.recording = NO;
            self.recordTime = [[NSDate date] timeIntervalSince1970] - self.recordTime;
             if (self.recordTime < 1) {
                 [[QZHHUD HUD] textHUDWithMessage:@"录制时间短于1S可能导致存储失败" afterDelay:1.0];
             }
            [self stopTimer];

        }
    }else if (tag == 0){
        //通话
        if (selected) {
            if (self.talkType) {
                self.talkBigView.hidden = NO;
            }else{
                [self startTalk];
                
            }
        }else{
            if (self.talkType) {
                self.talkBigView.hidden = YES;
            }else{
                [self stopTalk];
            }
        }
    }else{
        if (self.previewing) {
            if ([self.camera snapShoot]) {
                // 截图已成功保存到手机相册
                [[QZHHUD HUD] textHUDWithMessage:@"截图成功并保存到相册" afterDelay:0.5];
            }
        }
    }
}
//设备
- (void)deviceHandle:(NSInteger)tag{
    if (tag == -1) {
        //唤醒
        [self start];
    }else{
        //休眠
        [self.camera stopPreview];
    
        NSDictionary  *dps = @{@"231": @(NO)};
          [self.device publishDps:dps success:^{
              NSLog(@"publishDps success");
              //下发成功，状态上报通过 deviceDpsUpdate方法 回调
//              [self.camera.videoView removeFromSuperview];
              [self.camera pausePlayback];
              self.playView.playBtn.hidden = NO;
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

- (void)start {
    if ([self isDoorbell]) {
        // 获取设备的状态
            
        [self.device awakeDeviceWithSuccess:^{
            
            [self setConfigs];
            
        } failure:^(NSError *error) {
           [[QZHHUD HUD] textHUDWithMessage:error.userInfo[@"NSLocalizedDescription"] afterDelay:0.5];
            
        }];
    }
}
// TuyaSmartCameraDPObserver 当设备 DP 有更新的时候，会触发这个监听回调
- (void)cameraDPDidUpdate:(TuyaSmartCameraDPManager *)manager dps:(NSDictionary *)dpsData {
    // 如果收到 TuyaSmartCameraWirelessAwakeDPName 的更新，并且值为 YES，表示设备已唤醒
//    if ([[dpsData objectForKey:TuyaSmartCameraWirelessAwakeDPName] boolValue]) {
//        [self setConfigs];
//    }
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
    [self.camera startTalk];
}

- (void)stopTalk {
    [self.camera stopTalk];
}

- (void)cameraDidBeginTalk:(id<TuyaSmartCameraType>)camera {
        // 对讲已成功开启
    self.playView.recordProgressView.typeLab.text = @"通话中";
    [self startTimer];
    self.talking = YES;
    if (self.talkType) {
        
        [self.camera enableMute:YES forPlayMode:TuyaSmartCameraPlayModePreview];
            // 如果不是静音状态，关闭声音
    }else{
        [self.camera enableMute:NO forPlayMode:TuyaSmartCameraPlayModePreview];
    }
}

- (void)cameraDidStopTalk:(id<TuyaSmartCameraType>)camera {
        // 对讲已停止
        // 如果是静音状态，打开声音
    if (self.isMuted) {
        [self.camera enableMute:NO forPlayMode:TuyaSmartCameraPlayModePreview];
    }
    [self stopTimer];
    self.talking = NO;

}

#pragma mark -- e横向转屏
- (void)scrollHor:(BOOL) isHor{
    self.statusHiden = isHor;
    // 刷新状态栏
    [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    self.isHor = isHor;
        if (isHor) {

            self.playView.transform = CGAffineTransformMakeRotation(90*M_PI/180);
            CGAffineTransform transform = self.playView.transform;
             transform = CGAffineTransformScale(transform, 1,1);
            self.playView.transform = transform;
            self.playView.frame = CGRectMake(0, 0, QZHScreenWidth, QZHScreenHeight);
            [[UIApplication sharedApplication].keyWindow addSubview:self.playView];
   
        }else{
            OnLiveCell *cell = [self.qzTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
            self.playView.transform = CGAffineTransformMakeRotation(0*M_PI/90);
            CGAffineTransform transform = self.playView.transform;
             transform = CGAffineTransformScale(transform, 1,1);
            self.playView.transform = transform;
            self.playView.frame = CGRectMake(0, 0, QZHScreenWidth, QZHScreenWidth * 1080/1920);
            [cell.contentView addSubview:self.playView];
            [cell.contentView sendSubviewToBack:self.playView];
        }
}

-(CameraPlayView *)playView{
    if (!_playView) {

QZHWS(weakSelf)
        _playView = [[CameraPlayView alloc] init];
        _playView.buttonBlock = ^(UIButton *sender, BOOL selected) {
            if (weakSelf.private) {
                [[QZHHUD HUD] textHUDWithMessage:@"隐私模式下不能操作" afterDelay:1.0];
                return;
            }

            if (!weakSelf.previewing && sender.tag !=0) {
                [[QZHHUD HUD] textHUDWithMessage:@"正常播放时才能进行操作" afterDelay:1.0];
                return;
            }
            sender.selected = !sender.selected;
            [weakSelf onLivePlayHandle:sender.tag isselected:sender.selected];
        };
    }
    return _playView;
}
- (void)startTimer{
    if (self.timer) {
        [self stopTimer];
    }
    self.second = 0;
    self.playView.recordProgressView.hidden = NO;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
}
- (void)stopTimer{
    self.playView.recordProgressView.hidden = YES;
    [self.timer invalidate];
    self.timer = nil;
    self.playView.recordProgressView.timeLab.text = @"00:00";
}

- (void)timerAction:(NSTimer *)tiemr{
    self.second++;
    NSInteger min = self.second/60;
    NSInteger sec = self.second%60;
    self.playView.recordProgressView.timeLab.text = [NSString stringWithFormat:@"%02ld:%02ld",min,sec];
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
- (void)applicationWillEnterForeground{
    [self setConfigs];
}
- (void)applicationWillEnterBackground{
    if (self.recording) {
        CameraThreeBtnCell *cell = (CameraThreeBtnCell *)[self.qzTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
        cell.leftBtn.selected = NO;
        [self videoHandle:-1 isselected:NO];
        
    }
    if (self.talking) {
        CameraThreeBtnCell *cell = [self.qzTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
        cell.midBtn.selected = NO;
        [self videoHandle:0 isselected:NO];
        
    }
    [self.camera stopPreview];
    self.connected = NO;
}

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
@end
