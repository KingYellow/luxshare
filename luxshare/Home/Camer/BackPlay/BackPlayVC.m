//
//  BackPlayVC.m
//  luxshare
//
//  Created by 黄振 on 2020/7/15.
//  Copyright © 2020 KingYellow. All rights reserved.
//
//zyyy_DateListView *dateView = [[zyyy_DateListView alloc]initWithFrame:self.view.bounds];
#define kTuyaSmartIPCConfigAPI @"tuya.m.rtc.session.init"
#define kTuyaSmartIPCConfigAPIVersion @"1.0"


#import "BackPlayVC.h"
#import "zyyy_DateListView.h"
#import "CameraPlayView.h"
#import "ZFTimeLine.h"

@interface BackPlayVC ()<ZFTimeLineDelegate,TuyaSmartCameraDelegate,TuyaSmartCameraDPObserver>
@property (strong, nonatomic)CameraPlayView *playView;
@property (strong, nonatomic)ZFTimeLine *timeLine;
@property (strong, nonatomic)id<TuyaSmartCameraType> camera;
@property (strong, nonatomic)TuyaSmartCameraDPManager *dpManager;
@property (strong, nonatomic)UIView<TuyaSmartVideoViewType> * preview;
@property (assign, nonatomic)BOOL connected;
@property (assign, nonatomic)BOOL previewing;
@property (strong, nonatomic)TuyaSmartDevice *device;
@property (copy, nonatomic)NSArray *timeSlicesInCurrentDay;
@property (assign, nonatomic)NSInteger timeSlicesIndex;
@property (assign, nonatomic)BOOL playbackPaused;
@property (assign, nonatomic)BOOL playbacking;
@property (strong, nonatomic)UIButton *selectDateBtn;
@property (strong, nonatomic)UIButton *recordBtn;
@property (strong, nonatomic)UIButton *shotBtn;

@end

@implementation BackPlayVC
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initConfig];
}
- (void)initConfig{
    self.view.backgroundColor = QZHKIT_COLOR_LEADBACK;
    self.navigationItem.title = QZHLoaclString(@"device_playBack");
    [self exp_navigationBarTextWithColor:QZHKIT_COLOR_NAVIBAR_TITLE font:QZHKIT_FONT_TABBAR_TITLE];
    [self exp_navigationBarColor:QZHKIT_COLOR_NAVIBAR_BACK hiddenShadow:NO];
    [self UIConfig];
    [self startPlayback];

}
- (void)UIConfig{
    self.playView = [[CameraPlayView alloc] init];
    self.playView.horizontalBtn.hidden = YES;
    self.playView.definitionBtn.hidden = YES;
    self.timeLine = [[ZFTimeLine alloc] init];
    [self.view addSubview:self.selectDateBtn];
    [self.view addSubview:self.recordBtn];
    [self.view addSubview:self.shotBtn];
QZHWS(weakSelf)
    self.timeLine.delegate = self;
    self.playView.buttonBlock = ^(NSInteger tag, BOOL selected) {
        [weakSelf onLivePlayHandle:tag isselected:selected];
    };
    [self.view addSubview:self.playView];
    [self.view addSubview:self.timeLine];
    self.playView.frame = CGRectMake(0, 0, QZHScreenWidth, QZHScreenWidth *1080/1920);
    self.timeLine.frame = CGRectMake(0, QZHScreenWidth *1080/1920, QZHScreenWidth, 70);
    [self.selectDateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(self.timeLine.mas_bottom);
        make.width.height.mas_equalTo(QZHScreenWidth/2);
    }];
    [self.recordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(self.timeLine.mas_bottom);
        make.width.height.mas_equalTo(QZHScreenWidth/2);
    }];
    [self.shotBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(self.selectDateBtn.mas_bottom);
        make.width.height.mas_equalTo(QZHScreenWidth/2);
    }];
}

-(void)timeLine:(ZFTimeLine *)timeLine moveToDate:(NSString *)date{
    
}

- (void)startPlayback {
    if (self.connected) {
//        [self.camera queryRecordTimeSliceWithYear:2020 month:7 day:11];
        return;
    }
    id p2pType = [self.deviceModel.skills objectForKey:@"p2pType"];
    [[TuyaSmartRequest new] requestWithApiName:kTuyaSmartIPCConfigAPI postData:@{@"devId": self.deviceModel.devId} version:kTuyaSmartIPCConfigAPIVersion success:^(id result) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            TuyaSmartCameraConfig *config = [TuyaSmartCameraFactory ipcConfigWithUid:[TuyaSmartUser sharedInstance].uid localKey:self.deviceModel.localKey configData:result];
            self.camera = [TuyaSmartCameraFactory cameraWithP2PType:p2pType config:config delegate:self];
            [self.camera connect];

        });
    } failure:^(NSError *error) {
        // 获取配置信息失败
    }];
}

- (void)pausePlayback {
    [self.camera pausePlayback];
}

- (void)resumePlayback {
    [self.camera resumePlayback];
}

- (void)stopPlayback {
    [self.camera stopPlayback];
}

#pragma mark - TuyaSmartCameraDelegate

- (void)cameraDidConnected:(id<TuyaSmartCameraType>)camera {
    self.connected = YES;
      // 需要 p2p 连接成功后查询某天的视频录像片段
//        [camera queryRecordTimeSliceWithYear:2020 month:7 day:11];
}

- (void)cameraDisconnected:(id<TuyaSmartCameraType>)camera {
      // p2p 连接被动断开，一般为网络波动导致
    self.connected = NO;
    self.playbacking = NO;
}

- (void)camera:(id<TuyaSmartCameraType>)camera didReceiveTimeSliceQueryData:(NSArray<NSDictionary *> *)timeSlices {
      // 如果当天没有视频录像，则不播放
        if (timeSlices.count == 0) {
        return;
    }
      // 保存视频录像列表，从第一个开始播放
    self.timeSlicesInCurrentDay = [timeSlices copy];
      self.timeSlicesIndex = 0;
    NSDictionary *timeSlice = timeSlices.firstObject;
    NSInteger startTime = [timeSlice[kTuyaSmartTimeSliceStartTime] integerValue];
    NSInteger stopTime = [timeSlice[kTuyaSmartTimeSliceStopTime] integerValue];
      // 从第一个视频片段的第一秒开始播放
    NSInteger playTime = startTime;
    self.timeLine.dateArr= timeSlices;

    [camera startPlayback:playTime startTime:startTime stopTime:stopTime];
}

- (void)camera:(id<TuyaSmartCameraType>)camera ty_didReceiveVideoFrame:(CMSampleBufferRef)sampleBuffer frameInfo:(TuyaSmartVideoFrameInfo)frameInfo {
    NSInteger index = self.timeSlicesIndex + 1;
      // 如果没有下一个视频录像，则返回
    if (index >= self.timeSlicesInCurrentDay.count) {
        return;
    }
    NSDictionary *currentTimeSlice = [self.timeSlicesInCurrentDay objectAtIndex:self.timeSlicesIndex];
    NSInteger stopTime = [currentTimeSlice[kTuyaSmartTimeSliceStopTime] integerValue];
      // 如果当前视频帧的时间戳大于等于当前视频片段的结束时间，则播放下一个视频片段
    if (frameInfo.nTimeStamp >= stopTime) {
        NSDictionary *nextTimeSlice = [self.timeSlicesInCurrentDay objectAtIndex:index];
        NSInteger startTime = [nextTimeSlice[kTuyaSmartTimeSliceStartTime] integerValue];
            NSInteger stopTime = [nextTimeSlice[kTuyaSmartTimeSliceStopTime] integerValue];
            NSInteger playTime = startTime;
            [camera startPlayback:playTime startTime:startTime stopTime:stopTime];
    }
}

- (void)cameraDidBeginPlayback:(id<TuyaSmartCameraType>)camera {
      // 视频录像开始播放
    self.playbacking = YES;
    self.playbackPaused = NO;
    // 将视频渲染视图添加到屏幕上
        [self.playView addSubview:camera.videoView];
    [self.playView sendSubviewToBack:camera.videoView];
}

- (void)cameraDidPausePlayback:(id<TuyaSmartCameraType>)camera {
      // 视频录像播放已暂停
    self.playbackPaused = YES;
}

- (void)cameraDidResumePlayback:(id<TuyaSmartCameraType>)camera {
       // 视频录像已恢复播放
    self.playbackPaused = NO;
}

- (void)cameraDidStopPlayback:(id<TuyaSmartCameraType>)camera {
      // 视频录像已停止播放
       self.playbacking = NO;
    self.playbackPaused = NO;
}

- (void)cameraPlaybackDidFinished:(id<TuyaSmartCameraType>)camera {
      // 视频录像已结束播放
    self.playbacking = NO;
    self.playbackPaused = NO;
}

// 错误回调
- (void)camera:(id<TuyaSmartCameraType>)camera didOccurredErrorAtStep:(TYCameraErrorCode)errStepCode specificErrorCode:(NSInteger)errorCode {
        if (errStepCode == TY_ERROR_CONNECT_FAILED) {
          // p2p 连接失败
        self.connected = NO;
    }
    else if (errStepCode == TY_ERROR_START_PLAYBACK_FAILED) {
          // 存储卡录像播放失败
        self.playbacking = NO;
            self.playbackPaused = NO;
    }
      else if (errStepCode == TY_ERROR_PAUSE_PLAYBACK_FAILED) {
                // 暂停播放失败
    }
    else if (errStepCode == TY_ERROR_RESUME_PLAYBACK_FAILED) {
                // 恢复播放失败
    }
}

#pragma mark -- lazy
-(UIButton *)selectDateBtn{
    if (!_selectDateBtn) {
        _selectDateBtn = [[UIButton alloc] init];
        [_selectDateBtn setTitle:@"日期" forState:UIControlStateNormal];
        [_selectDateBtn setTitleColor:QZHKIT_Color_BLACK_87 forState:UIControlStateNormal];
        _selectDateBtn.backgroundColor = UIColor.whiteColor;
        [_selectDateBtn addTarget:self action:@selector(selectaction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectDateBtn;
}

-(UIButton *)recordBtn{
    if (!_recordBtn) {
        _recordBtn = [[UIButton alloc] init];
        [_recordBtn setTitle:@"录像" forState:UIControlStateNormal];
        [_recordBtn setTitle:@"停止" forState:UIControlStateSelected];
        _recordBtn.backgroundColor = UIColor.whiteColor;
        [_recordBtn setTitleColor:QZHKIT_Color_BLACK_87 forState:UIControlStateNormal];

        [_recordBtn addTarget:self action:@selector(recordaction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _recordBtn;
}
-(UIButton *)shotBtn{
    if (!_shotBtn) {
        _shotBtn = [[UIButton alloc] init];
        [_shotBtn setTitle:@"截屏" forState:UIControlStateNormal];
        _shotBtn.backgroundColor = UIColor.whiteColor;
        [_shotBtn setTitleColor:QZHKIT_Color_BLACK_87 forState:UIControlStateNormal];

        [_shotBtn addTarget:self action:@selector(shotaction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _shotBtn;
}
- (void)selectaction:(UIButton *)sender{
    QZHWS(weakSelf)
    zyyy_DateListView *v =[[zyyy_DateListView alloc] initWithFrame:self.navigationController.view.bounds];
    v.camera = self.camera;
    v.selectDateBlock = ^(NSDictionary *date) {
        weakSelf.camera.delegate = self;
        [weakSelf.camera queryRecordTimeSliceWithYear:[date[@"year"] integerValue] month:[date[@"month"] integerValue] day:[date[@"day"] integerValue]];

    };
    [v iiiii];

    [self.navigationController.view addSubview:v];
}
- (void)recordaction:(UIButton *)sender{
    sender.selected = !sender.selected;
    if (sender.selected) {
        [self.camera startRecord];
    }else{
        [self.camera stopRecord];
    }

}
- (void)shotaction:(UIButton *)sender{
    if ([self.camera snapShoot]) {
        // 截图已成功保存到手机相册
        [[QZHHUD HUD] textHUDWithMessage:@"截图成功并保存到相册" afterDelay:0.5];
    }
}

//直播属性设置
- (void)onLivePlayHandle:(NSInteger )tag isselected:(BOOL)select{

    //sender.tag == 0) {
         //播放
    if (tag == 0) {
        
    }else if(tag == 1){
        //sender.tag == 1){
            //声音
        [self.camera enableMute:select forPlayMode:TuyaSmartCameraPlayModePreview];
        
    }
}
@end
