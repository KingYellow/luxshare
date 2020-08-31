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
#import "UIImageView+Gif.h"

@interface BackPlayVC ()<ZFTimeLineDelegate,TuyaSmartCameraDelegate,TuyaSmartCameraDPObserver>
@property (strong, nonatomic)CameraPlayView *playView;
@property (strong, nonatomic)ZFTimeLine *timeLine;
@property (strong, nonatomic)id<TuyaSmartCameraType> camera;
@property (strong, nonatomic)TuyaSmartCameraDPManager *dpManager;
@property (strong, nonatomic)UIView<TuyaSmartVideoViewType> * preview;
@property (assign, nonatomic)BOOL connected;
@property (strong, nonatomic)TuyaSmartDevice *device;
@property (copy, nonatomic)NSArray *timeSlicesInCurrentDay;
@property (assign, nonatomic)NSInteger timeSlicesIndex;
@property (assign, nonatomic)BOOL playbackPaused;
@property (assign, nonatomic)BOOL playbacking;
@property (strong, nonatomic)UIButton *selectDateBtn;
@property (strong, nonatomic)UIButton *recordBtn;
@property (strong, nonatomic)UIButton *shotBtn;
@property (strong, nonatomic)UILabel *tipLab;
@property (strong, nonatomic)UILabel *tipFinishLab;
@property (strong, nonatomic)NSTimer *timer;
@property (assign, nonatomic)NSInteger second;
@property (assign, nonatomic)BOOL recording;
@property (assign, nonatomic)NSTimeInterval recordTime;
@property (strong, nonatomic)UIImageView *playPreGif;
@property (strong, nonatomic)NSString *nowDate;
@property (assign, nonatomic)BOOL isHor;
@property (assign, nonatomic)BOOL statusHidden;
@property (strong, nonatomic)UIButton *leftBackBtn;

@end

@implementation BackPlayVC
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

}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];

    [[NSNotificationCenter defaultCenter] removeObserver:self];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initConfig];
}
- (void)initConfig{
    self.view.backgroundColor = QZHKIT_COLOR_LEADBACK;
    self.navigationItem.title = QZHLoaclString(@"device_playBack");
    [self exp_navigationBarTextWithColor:QZHKIT_COLOR_NAVIBAR_TITLE font:QZHKIT_FONT_TABBAR_TITLE];
    [self exp_navigationBarColor:QZHKIT_COLOR_NAVIBAR_BACK hiddenShadow:NO];
    [self exp_addLeftItemTitle:@"" itemIcon:QZHICON_BACK_ITEM];
    [self UIConfig];
    [self startPlayback];

}
-(void)exp_leftAction{
    [self.camera stopPreview];
    [self.camera disConnect];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)UIConfig{
    self.playView = [[CameraPlayView alloc] init];

//    self.playView.horizontalBtn.hidden = YES;
    self.playView.definitionBtn.hidden = YES;
    self.timeLine = [[ZFTimeLine alloc] init];
    [self.view addSubview:self.selectDateBtn];
    [self.view addSubview:self.recordBtn];
    [self.view addSubview:self.shotBtn];
QZHWS(weakSelf)
    self.timeLine.delegate = self;
    self.playView.buttonBlock = ^(UIButton *sender, BOOL selected) {
        if (sender.tag == 3) {
            sender.selected = !sender.selected;
            [weakSelf scrollHor:sender.selected];
        }else{
            sender.selected = !sender.selected;
            [weakSelf onLivePlayHandle:sender.tag isselected:sender.selected];
        }

    };
    [self.view addSubview:self.playView];
    [self.view addSubview:self.timeLine];
    [self.playView addSubview:self.leftBackBtn];
    self.leftBackBtn.frame = CGRectMake(10, 30, 30, 30);
    [self.playView bringSubviewToFront:self.leftBackBtn];

    self.playView.frame = CGRectMake(0, 0, QZHScreenWidth, QZHScreenWidth *1080/1920);
    self.timeLine.frame = CGRectMake(0, QZHScreenWidth *1080/1920, QZHScreenWidth, 50);
    [self.playView addSubview:self.tipLab];
    [self.playView addSubview:self.tipFinishLab];

    self.playView.playBtn.hidden = YES;
    [self.tipLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.playView);
    }];
    [self.tipFinishLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.playView);
    }];
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
#pragma mark -- ZFTimeLineDelegate
-(void)timeLine:(ZFTimeLine *)timeLine moveToDate:(NSString *)date{
    NSDictionary *playInfo;
    NSTimeInterval nowT = 0;
    NSTimeInterval nowSpace = 0;
    NSInteger spaceIndex = 0;
    
    for (int i = 0; i < self.timeSlicesInCurrentDay.count; i++) {
        NSDictionary *info = self.timeSlicesInCurrentDay[i];
        NSTimeInterval start = [info[kTuyaSmartTimeSliceStartTime] integerValue];
        NSTimeInterval end = [info[kTuyaSmartTimeSliceStopTime] integerValue];
        NSDate *nowDate = [NSDate jk_dateWithString:date format:@"yyyyMMddHHmmss"];
        NSTimeInterval now = [nowDate timeIntervalSince1970];
        
        if (now > start && now < end) {
            playInfo = info;
            nowT = now;
            self.timeSlicesIndex = i;
        }
        
        if (now < start && now > nowSpace) {
            spaceIndex = i;
        }
        if (i == self.timeSlicesInCurrentDay.count - 1 && now >end){
            spaceIndex = i;
        }
        nowSpace = end;

    }
    if (playInfo) {
        NSInteger startTime = [playInfo[kTuyaSmartTimeSliceStartTime] integerValue];
        NSInteger stopTime = [playInfo[kTuyaSmartTimeSliceStopTime] integerValue];
        NSInteger playTime = (NSInteger)nowT;
        [self.camera startPlayback:playTime startTime:startTime stopTime:stopTime];
    }else{
        if (spaceIndex < self.timeSlicesInCurrentDay.count) {
            NSDictionary *playInfo = self.timeSlicesInCurrentDay[spaceIndex];
            NSInteger startTime = [playInfo[kTuyaSmartTimeSliceStartTime] integerValue];
            NSInteger stopTime = [playInfo[kTuyaSmartTimeSliceStopTime] integerValue];
            NSInteger playTime = startTime;
            [self.camera startPlayback:playTime startTime:startTime stopTime:stopTime];
        }
    }
    
}

- (void)startPlayback {
    if (self.connected) {
        return;
    }
    [self.playView.playPreGif startPlayGifWithImages:@[@"img_loading_anima1",@"img_loading_anima2",@"img_loading_anima3"]];
    self.playView.playPreGif.hidden = NO;
    
    id p2pType = [self.deviceModel.skills objectForKey:@"p2pType"];
    [[TuyaSmartRequest new] requestWithApiName:kTuyaSmartIPCConfigAPI postData:@{@"devId": self.deviceModel.devId} version:kTuyaSmartIPCConfigAPIVersion success:^(id result) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            TuyaSmartCameraConfig *config = [TuyaSmartCameraFactory ipcConfigWithUid:[TuyaSmartUser sharedInstance].uid localKey:self.deviceModel.localKey configData:result];
            self.camera = [TuyaSmartCameraFactory cameraWithP2PType:p2pType config:config delegate:self];
            [self.camera connect];

        });
    } failure:^(NSError *error) {
        // 获取配置信息失败
           [[QZHHUD HUD] textHUDWithMessage:error.userInfo[@"NSLocalizedDescription"] afterDelay:0.5];
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
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    if (self.nowDate) {
        date = [NSDate jk_dateWithString:self.nowDate format:@"yyyyMMddHHmmss"];
    }
     
    [formatter setDateFormat:@"yyyy"];
    NSInteger currentYear=[[formatter stringFromDate:date] integerValue];
    [formatter setDateFormat:@"MM"];
    NSInteger currentMonth=[[formatter stringFromDate:date]integerValue];
    [formatter setDateFormat:@"dd"];
    NSInteger currentDay=[[formatter stringFromDate:date] integerValue];
     
    [self.camera queryRecordTimeSliceWithYear:currentYear  month:currentMonth day:currentDay];
}

- (void)cameraDisconnected:(id<TuyaSmartCameraType>)camera {
      // p2p 连接被动断开，一般为网络波动导致
    self.connected = NO;
    self.playbacking = NO;
}

- (void)camera:(id<TuyaSmartCameraType>)camera didReceiveTimeSliceQueryData:(NSArray<NSDictionary *> *)timeSlices {
      // 如果当天没有视频录像，则不播放
    if (timeSlices.count == 0) {
        self.tipLab.hidden = NO;
        self.playView.playPreGif.hidden = YES;
        return;
    }
    self.tipLab.hidden = YES;

      // 保存视频录像列表，从第一个开始播放
    self.timeSlicesInCurrentDay = [timeSlices copy];
    NSDictionary *timeSlice;
    if (self.nowDate) {
       timeSlice  = timeSlices[self.timeSlicesIndex];
        NSInteger startTime = [timeSlice[kTuyaSmartTimeSliceStartTime] integerValue];
        NSInteger stopTime = [timeSlice[kTuyaSmartTimeSliceStopTime] integerValue];
        NSDateFormatter *formatterProject = [[NSDateFormatter alloc]init];
          [formatterProject setDateFormat:@"yyyyMMddHHmmss"];
        NSDate *date = [formatterProject dateFromString:self.nowDate];
        // 从第一个视频片段的第一秒开始播放
        NSInteger playTime = [date timeIntervalSince1970];
        
        [camera startPlayback:playTime startTime:startTime stopTime:stopTime];
    }else{
        self.timeSlicesIndex = 0;
        timeSlice  = timeSlices.firstObject;
        NSInteger startTime = [timeSlice[kTuyaSmartTimeSliceStartTime] integerValue];
        NSInteger stopTime = [timeSlice[kTuyaSmartTimeSliceStopTime] integerValue];
          // 从第一个视频片段的第一秒开始播放
        NSInteger playTime = startTime;
        self.timeLine.dateArr= timeSlices;
        [camera startPlayback:playTime startTime:startTime stopTime:stopTime];
    }
}

- (void)camera:(id<TuyaSmartCameraType>)camera ty_didReceiveVideoFrame:(CMSampleBufferRef)sampleBuffer frameInfo:(TuyaSmartVideoFrameInfo)frameInfo {
    NSDate *now = [NSDate dateWithTimeIntervalSince1970:frameInfo.nTimeStamp];
    NSString *date = [[NSDateFormatter jk_dateFormatterWithFormat:@"yyyyMMddHHmmss"] stringFromDate:now];
    [self.timeLine moveToDate:date];
    NSInteger index = self.timeSlicesIndex + 1;
      // 如果没有下一个视频录像，则返回
    if (index >= self.timeSlicesInCurrentDay.count) {
        return;
    }
    NSDictionary *currentTimeSlice = [self.timeSlicesInCurrentDay objectAtIndex:self.timeSlicesIndex];
    NSInteger stopTime = [currentTimeSlice[kTuyaSmartTimeSliceStopTime] integerValue];
      // 如果当前视频帧的时间戳大于等于当前视频片段的结束时间，则播放下一个视频片段
    if (frameInfo.nTimeStamp >= stopTime) {
        self.playView.playPreGif.hidden = NO;
        [self.camera.videoView tuya_clear];
        self.timeSlicesIndex++;
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
    self.tipFinishLab.hidden = YES;

    if (self.nowDate) {
        [self.timeLine moveToDate:self.nowDate];
    }
    self.nowDate = nil;
    // 将视频渲染视图添加到屏幕上
    [self.playView addSubview:camera.videoView];
    if (self.isHor) {
        self.camera.videoView.frame = CGRectMake(0, 0, QZHScreenHeight , QZHScreenWidth - 50);
    }
    [self.playView sendSubviewToBack:camera.videoView];
    self.playView.playPreGif.hidden = YES;

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
    self.tipFinishLab.hidden = NO;
}

-(void)cameraDidStartRecord:(id<TuyaSmartCameraType>)camera{
    [self startTimer];
    self.recording = YES;
    self.playView.voiceBtn.alpha = 0.5;
    self.playView.voiceBtn.userInteractionEnabled = NO;
    self.recordTime = [[NSDate date] timeIntervalSince1970];
}
- (void)cameraDidStopRecord:(id<TuyaSmartCameraType>)camera{
    self.recording = NO;
    self.playView.voiceBtn.alpha = 1.0;
    self.playView.voiceBtn.userInteractionEnabled = YES;
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
    }else if (errStepCode == TY_ERROR_RECORD_FAILED) {
        self.recording = NO;
        self.playView.voiceBtn.alpha = 1.0;
        self.playView.voiceBtn.userInteractionEnabled = YES;
    }else if (errStepCode == TY_ERROR_PAUSE_PLAYBACK_FAILED) {
                // 暂停播放失败
    }else if (errStepCode == TY_ERROR_RESUME_PLAYBACK_FAILED) {
                // 恢复播放失败
    }
}

#pragma mark -- lazy
-(UIButton *)leftBackBtn{
    if (!_leftBackBtn) {
        _leftBackBtn = [[UIButton alloc] init];
        [_leftBackBtn setImage:QZHLoadIcon(@"nav_btn_back") forState:UIControlStateNormal];
        [_leftBackBtn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
        _leftBackBtn.tag = -100;
        _leftBackBtn.hidden = YES;
    }
    return _leftBackBtn;
}
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

        [_recordBtn addTarget:self action:@selector(recordAction:) forControlEvents:UIControlEventTouchUpInside];
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
- (UILabel *)tipLab{
    if (!_tipLab) {
        _tipLab = [[UILabel alloc] init];
        _tipLab.text = @"当天没有视频";
        _tipLab.textColor = QZH_KIT_Color_WHITE_70;
        _tipLab.font = QZHKIT_FONT_LISTCELL_MAIN_TITLE;
        _tipLab.textAlignment = NSTextAlignmentCenter;
        _tipLab.hidden = YES;
    }
    return _tipLab;
}
- (UILabel *)tipFinishLab{
    if (!_tipFinishLab) {
        _tipFinishLab = [[UILabel alloc] init];
        _tipFinishLab.text = @"视频播放完成";
        _tipFinishLab.textColor = QZH_KIT_Color_WHITE_70;
        _tipFinishLab.font = QZHKIT_FONT_LISTCELL_MAIN_TITLE;
        _tipFinishLab.textAlignment = NSTextAlignmentCenter;
        _tipFinishLab.hidden = YES;
    }
    return _tipFinishLab;
}
- (void)backAction:(UIButton *)sender{
    [self scrollHor:NO];
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
- (void)recordAction:(UIButton *)sender{

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
               if (self.playbacking) {
                   sender.selected = !sender.selected;
                   [self.camera startRecord];
                   self.recording = YES;
               }else{
                   [[QZHHUD HUD]textHUDWithMessage:@"正常播放时才能录制视频" afterDelay:1.0];
               }

           }

        }else{
            sender.selected = !sender.selected;
           [self.camera stopRecord];
           self.recording = NO;
           self.recordTime = [[NSDate date] timeIntervalSince1970] - self.recordTime;
            if (self.recordTime < 1) {
                [[QZHHUD HUD] textHUDWithMessage:@"录制时间短于1S可能导致存储失败" afterDelay:1.0];
            }
           [self stopTimer];

        }
}
- (void)shotaction:(UIButton *)sender{
    
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
         if (self.playbacking) {
             
             if ([self.camera snapShoot]) {
                 sender.selected = !sender.selected;
                 // 截图已成功保存到手机相册
                 [[QZHHUD HUD] textHUDWithMessage:@"截图成功并保存到相册" afterDelay:0.5];
             }
         }else{
             [[QZHHUD HUD]textHUDWithMessage:@"正常播放时才能录截屏" afterDelay:1.0];
         }
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
        if (self.recording) {
            [[QZHHUD HUD] textHUDWithMessage:@"录屏时不能操作" afterDelay:1.0];
            return;
        }
        [self.camera enableMute:select forPlayMode:TuyaSmartCameraPlayModePreview];
        
    }
}
- (void)startTimer{
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
- (void)applicationWillEnterForeground{
    self.nowDate = [self.timeLine currentTimeStr];
    [self startPlayback];
}
- (void)applicationWillEnterBackground{
    self.connected = NO;
    [self.camera disConnect];
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
#pragma mark -- e横向转屏
- (void)scrollHor:(BOOL) isHor{
    self.statusHidden = isHor;
    // 刷新状态栏
    [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    self.isHor = isHor;
    self.timeLine.isHor = self.isHor;
    self.leftBackBtn.hidden = !isHor;
    self.playView.horizontalBtn.hidden = isHor;

        if (isHor) {
            self.playView.transform = CGAffineTransformMakeRotation(90*M_PI/180);
            self.timeLine.transform = CGAffineTransformMakeRotation(90*M_PI/180);
            CGAffineTransform transform = self.playView.transform;
            CGAffineTransform transformtime = self.timeLine.transform;

            transform = CGAffineTransformScale(transform, 1,1);
            transformtime = CGAffineTransformScale(transformtime, 1,1);

            self.playView.transform = transform;
            self.timeLine.transform = transformtime;
            self.camera.videoView.frame = CGRectMake(0, 0, QZHScreenHeight , QZHScreenWidth - 50);

            self.playView.frame = CGRectMake(50, 0, QZHScreenWidth - 50, QZHScreenHeight);
            self.timeLine.frame = CGRectMake(0, 0, 50, QZHScreenHeight);
            [self.playView.voiceBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(QZH_VIDEO_LEFTMARGIN + 10);
            }];
            self.leftBackBtn.frame = CGRectMake(10 + QZH_VIDEO_LEFTMARGIN, 30, 30, 30);

            [self.navigationController.view addSubview:self.playView];
            [self.navigationController.view addSubview:self.timeLine];

   
        }else{

            self.playView.transform = CGAffineTransformMakeRotation(0*M_PI/90);
            self.timeLine.transform = CGAffineTransformMakeRotation(0*M_PI/90);

            CGAffineTransform transform = self.playView.transform;
            CGAffineTransform transformtime = self.timeLine.transform;

            transform = CGAffineTransformScale(transform, 1,1);
            transformtime = CGAffineTransformScale(transformtime, 1,1);

            self.playView.transform = transform;
            self.timeLine.transform = transformtime;

            self.playView.frame = CGRectMake(0, 0, QZHScreenWidth, QZHScreenWidth *1080/1920);
            self.camera.videoView.frame = CGRectMake(0, 0, QZHScreenWidth , QZHScreenWidth *1080/1920);
            self.timeLine.frame = CGRectMake(0, QZHScreenWidth *1080/1920, QZHScreenWidth, 50);
            [self.selectDateBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.timeLine.mas_bottom);
            }];
            [self.recordBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.timeLine.mas_bottom);
            }];
            [self.playView.voiceBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(10);
            }];
            self.leftBackBtn.frame = CGRectMake(10, 30, 30, 30);

            [self.view addSubview:self.playView];
            [self.view addSubview:self.timeLine];
        }
}
- (BOOL)prefersStatusBarHidden{

    return self.statusHidden;
}
@end
