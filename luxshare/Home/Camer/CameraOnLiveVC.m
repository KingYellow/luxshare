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

@interface CameraOnLiveVC ()<TuyaSmartCameraDelegate,UITableViewDelegate,UITableViewDataSource,TuyaSmartCameraDPObserver>
@property (strong, nonatomic)UITableView *qzTableView;
@property (copy, nonatomic)NSMutableArray *listArr;
@property (copy, nonatomic)NSMutableArray *logoArr;
@property (strong, nonatomic)id<TuyaSmartCameraType> camera;
@property (strong, nonatomic)UIView<TuyaSmartVideoViewType> * preview;
@property (assign, nonatomic)BOOL connected;
@property (assign, nonatomic)BOOL previewing;
@property (strong, nonatomic)ZYGlKImageView *blurView;
@property (strong, nonatomic)TuyaSmartCameraDPManager *dpManager;
@property (strong, nonatomic)TuyaSmartDevice *device;
@property (strong, nonatomic)CameraPlayView *playView;
//高清
@property (assign, nonatomic)BOOL HD;
//静音
@property (assign, nonatomic)BOOL isMuted;
@end

@implementation CameraOnLiveVC
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.qzTableView reloadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = QZHKIT_COLOR_LEADBACK;
    [self UIConfig];
    [self setConfigs];
    
    [self.camera getHD];

    self.dpManager = [[TuyaSmartCameraDPManager alloc] initWithDeviceId:self.deviceModel.devId];
      self.device = [TuyaSmartDevice deviceWithDeviceId:self.deviceModel.devId];
      // 添加 DP 监听
      [self.dpManager addObserver:self];

    [self start];
}

- (void)UIConfig{

 
//    self.blurView = [[ZYGlKImageView alloc] init];
//    [self.view addSubview:self.blurView];
    [self.view addSubview:self.qzTableView];
    [self.qzTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0 ));
    }];
    
    [self exp_addRightItemTitle:@"设置" itemIcon:@""];
}
- (void)exp_rightAction{
    DeviceSettingVC *vc = [[DeviceSettingVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)setConfigs{
    if (self.connected) {
        [self.camera startPreview];
        return;
    }
    // deviceModel 为设备列表中的摄像机设备的数据模型
    id p2pType = [self.deviceModel.skills objectForKey:@"p2pType"];
    [[TuyaSmartRequest new] requestWithApiName:@"tuya.m.rtc.session.init" postData:@{@"devId": self.deviceModel.devId} version:@"1.0" success:^(id result) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            TuyaSmartCameraConfig *config = [TuyaSmartCameraFactory ipcConfigWithUid:[TuyaSmartUser sharedInstance].uid localKey:self.deviceModel.localKey configData:result];
            self.camera = [TuyaSmartCameraFactory cameraWithP2PType:p2pType config:config delegate:self];
            [self.camera connect];
        });

    } failure:^(NSError *error) {

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
        CameraTBtnCell *cell = [tableView dequeueReusableCellWithIdentifier:QZHCELL_REUSE_IMAGE];
        cell.btnBlock = ^(NSInteger tag) {
            [weakSelf deviceHandle:tag];
        };

        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if (row == 1) {
        OnLiveCell *cell = [tableView dequeueReusableCellWithIdentifier:QZHCELL_REUSE_FIELD];
//        cell.buttonBlock = ^(NSInteger tag, BOOL selected) {
//            [weakSelf onLivePlayHandle:tag isselected:selected];
//        };
        
//        [cell.contentView addSubview:self.camera.videoView];
//        [self.camera.videoView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
//        }];
        [cell.contentView addSubview:self.playView];
        self.playView.frame= CGRectMake(0, 0, QZHScreenWidth, 211);
        [_playView addSubview:self.camera.videoView];
        [self.camera.videoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0  ));
        }];
        [self.playView sendSubviewToBack:self.camera.videoView];
        
        return cell;
    }else if (row == 2) {
        CameraThreeBtnCell *cell = [tableView dequeueReusableCellWithIdentifier:QZHCELL_REUSE_TEXT];
        cell.btnBlock = ^(NSInteger tag, BOOL select) {
            
            [weakSelf videoHandle:tag isselected:select];
        };

        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if (row == 3) {
        CameraListCell *cell = [tableView dequeueReusableCellWithIdentifier:QZHCELL_REUSE_DEFAULT];
        cell.nameLab.text = @"    相册管理";
        cell.IMGView.image = QZHLoadIcon(@"shezhi");
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        CameraListCell *cell = [tableView dequeueReusableCellWithIdentifier:QZHCELL_REUSE_DEFAULT];
        cell.nameLab.text = @"    历史回看";
        cell.IMGView.image = QZHLoadIcon(@"shezhi");
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
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
    return 70;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    if (row == 3) {
        PhotosVC *vc = [[PhotosVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }


}

- (NSMutableArray *)listArr{
    if (!_listArr) {
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
    [self.camera connect];
}
-(void)cameraDidStartRecord:(id<TuyaSmartCameraType>)camera{
    
}
-(void)cameraDidStopRecord:(id<TuyaSmartCameraType>)camera{
    
}
-(void)cameraDidBeginPlayback:(id<TuyaSmartCameraType>)camera{
    
}
-(void)cameraDidStopPlayback:(id<TuyaSmartCameraType>)camera{
    
}
-(void)cameraDidBeginPreview:(id<TuyaSmartCameraType>)camera{
    
    self.previewing = YES;

    self.camera.videoView.backgroundColor = QZHColorRed;

    [self.qzTableView reloadData];

}
-(void)cameraDidStopPreview:(id<TuyaSmartCameraType>)camera{
    self.previewing = NO;

}
-(void)camera:(id<TuyaSmartCameraType>)camera didOccurredErrorAtStep:(TYCameraErrorCode)errStepCode specificErrorCode:(NSInteger)errorCode{
     if (errStepCode == TY_ERROR_CONNECT_FAILED) {
          // p2p 连接失败
        self.connected = NO;
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
    }
    
    if (errStepCode == TY_ERROR_ENABLE_HD_FAILED) {
                // 切换视频清晰度失败
    }
}

#pragma mark -- 视频控制
//直播属性设置
- (void)onLivePlayHandle:(NSInteger )tag isselected:(BOOL)select{

    //sender.tag == 0) {
         //播放
    if (tag == 0) {
        
    }else if(tag == 1){
        //sender.tag == 1){
            //声音
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
        }else{
            [self.camera stopRecord];
        }
    }else if (tag == 0){
        //通话

        if (selected) {
            [self.camera startTalk];
        }else{
            [self.camera stopTalk];
        }
    }else{
        if (self.previewing) {
            if ([self.camera snapShoot]) {
                // 截图已成功保存到手机相册
                [[QZHHUD HUD] textHUDWithMessage:@"截图成功并保存到相册" afterDelay:0.5];
            }
        }
//
//        //截图 tag = 2
//     UIImage *image =  [self.camera snapShoot];
//        UIImage *ima1 = [self.camera snapShootSavedAtPath:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"ddd"] thumbnilPath:nil];
//        NSLog(@"11====%@  22===%@",image,ima1);
    }
    
}
//设备
- (void)deviceHandle:(NSInteger)tag{
    if (tag == -1) {
        //唤醒
        [self start];
    }else{
        //休眠
    }
}

#pragma mark -- 唤醒设备
// 判断是否是低功耗门铃
- (BOOL)isDoorbell {
    return [self.dpManager isSupportDP:TuyaSmartCameraWirelessAwakeDPName];
}

- (void)start {
    if ([self isDoorbell]) {
        QZHWS(weakSelf)
        // 获取设备的状态
                BOOL isAwaking = [[self.dpManager valueForDP:TuyaSmartCameraWirelessAwakeDPName] boolValue];
        if (isAwaking) { // 唤醒状态下，直接连接p2p 或者 开始预览
          
        }else { // 休眠状态下，发送唤醒命令
            
            [self.device awakeDeviceWithSuccess:^{
                
                NSLog(@"success");
            } failure:^(NSError *error) {
                NSLog(@"failure");
            }];
        }
    }
}
// TuyaSmartCameraDPObserver 当设备 DP 有更新的时候，会触发这个监听回调
- (void)cameraDPDidUpdate:(TuyaSmartCameraDPManager *)manager dps:(NSDictionary *)dpsData {
    // 如果收到 TuyaSmartCameraWirelessAwakeDPName 的更新，并且值为 YES，表示设备已唤醒
    if ([[dpsData objectForKey:TuyaSmartCameraWirelessAwakeDPName] boolValue]) {
        [self setConfigs];
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

}
#pragma mark -- 对讲
- (void)startTalk {
    [self.camera startTalk];
    // 如果不是静音状态，关闭声音
    if (!self.isMuted) {
        [self.camera enableMute:YES forPlayMode:TuyaSmartCameraPlayModePreview];
    }
}

- (void)stopTalk {
    [self.camera stopTalk];
}

- (void)cameraDidBeginTalk:(id<TuyaSmartCameraType>)camera {
        // 对讲已成功开启
}

- (void)cameraDidStopTalk:(id<TuyaSmartCameraType>)camera {
        // 对讲已停止
        // 如果是静音状态，打开声音
    if (self.isMuted) {
        [self.camera enableMute:NO forPlayMode:TuyaSmartCameraPlayModePreview];
    }
}


#pragma mark -- e横向转屏
- (void)scrollHor:(BOOL) isHor{

       //顺时针 旋转180度
         [UIView beginAnimations:nil context:nil];
         [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
         [UIView setAnimationDuration:0.2]; //动画时长


        if (isHor) {
            QZHWS(weakSelf)
//            OnLiveCell *cell = [self.qzTableView dequeueReusableCellWithIdentifier:QZHCELL_REUSE_FIELD];
            self.playView.transform = CGAffineTransformMakeRotation(90*M_PI/180);

             CGAffineTransform transform = self.playView.transform;
             transform = CGAffineTransformScale(transform, 1,1);
             self.playView.transform = transform;

            self.playView.frame = CGRectMake(0, 0, QZHScreenWidth, QZHScreenHeight);

//            [cell sendSubviewToBack:self.camera.videoView];
            [self.navigationController.view addSubview:self.playView];
   

        }else{

            OnLiveCell *cell = [self.qzTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];

            self.playView.transform = CGAffineTransformMakeRotation(0*M_PI/90);

             CGAffineTransform transform = self.playView.transform;
             transform = CGAffineTransformScale(transform, 1,1);
             self.playView.transform = transform;

            self.playView.frame = CGRectMake(0, 0, QZHScreenWidth, 211);

            [cell.contentView addSubview:self.playView];
            [cell.contentView sendSubviewToBack:self.playView];
        }

}

-(CameraPlayView *)playView{
    if (!_playView) {

QZHWS(weakSelf)
        _playView = [[CameraPlayView alloc] init];

        _playView.buttonBlock = ^(NSInteger tag, BOOL selected) {
            [weakSelf onLivePlayHandle:tag isselected:selected];
        };
    }
    return _playView;
}

@end
