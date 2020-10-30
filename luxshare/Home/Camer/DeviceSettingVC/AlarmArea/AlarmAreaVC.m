//
//  AlarmAreaVC.m
//  luxshare
//
//  Created by 黄振 on 2020/8/10.
//  Copyright © 2020 KingYellow. All rights reserved.
//

#import "AlarmAreaVC.h"
#import "CameraPlayView.h"
#import "UIImageView+Gif.h"
#import "MaskView.h"
#import "MBProgressHUD+NJ.h"

@interface AlarmAreaVC ()<TuyaSmartCameraDelegate,TuyaSmartCameraDPObserver,TuyaSmartDeviceDelegate>

@property (strong, nonatomic)id<TuyaSmartCameraType> camera;
@property (strong, nonatomic)UIView<TuyaSmartVideoViewType> * preview;
@property (assign, nonatomic)BOOL connected;
@property (assign, nonatomic)BOOL previewing;
@property (strong, nonatomic)TuyaSmartCameraDPManager *dpManager;
@property (strong, nonatomic)TuyaSmartDevice *device;
@property (strong, nonatomic)CameraPlayView *playView;
@property (strong, nonatomic)UIImageView *playPreGif;
@property (strong, nonatomic)UIButton *submitBtn;
@property (assign, nonatomic)CGRect selectRect;
@property (strong, nonatomic)MaskView *maskView;
@property(nonatomic,assign) BOOL statusHiden;

@end

@implementation AlarmAreaVC
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
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
    if (self.connected) {
        [self.camera startPreview];
    }
    self.statusHiden = YES;
    [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
    [self.playView removeFromSuperview];

}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];

    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if (_camera) {
        [self.camera stopPreview];
    }
}
-(void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = QZHKIT_COLOR_LEADBACK;
    [self setUIConfigs];
    [self setConfigs];
    self.dpManager = [[TuyaSmartCameraDPManager alloc] initWithDeviceId:self.deviceModel.devId];
      self.device = [TuyaSmartDevice deviceWithDeviceId:self.deviceModel.devId];
      // 添加 DP 监听
    self.device.delegate = self;
    [self.dpManager addObserver:self];
    [self startAwakeDevice];
}
- (void)setUIConfigs{
    self.playView.transform = CGAffineTransformMakeRotation(90*M_PI/180);

    self.playView.frame = CGRectMake(0, 0, QZHScreenWidth, QZHScreenHeight);
    [self.navigationController.view addSubview:self.playView];
    [self.playView addSubview:self.maskView];
    [self.maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0 ));
    }];
    
    if (self.deviceModel.dps[@"169"]) {
        NSData *jsonData = [self.deviceModel.dps[@"169"] dataUsingEncoding:NSUTF8StringEncoding];
        if (!jsonData) {
            return;
        }
        NSError *err;
        NSDictionary *dicjson = [NSJSONSerialization JSONObjectWithData:jsonData
                                                            options:NSJSONReadingMutableContainers
                                                              error:&err];
        NSDictionary *dic = dicjson[@"region0"];

        if (([dic[@"xlen"] intValue] - [dic[@"x"] intValue])/100.0*(QZH_VIDEO_RIGHTMARGIN - QZH_VIDEO_LEFTMARGIN) < (QZHSIZE_WIDTH_ALARMAREA - 5)  || ([dic[@"ylen"] intValue] - [dic[@"y"] intValue])/100.0*QZHScreenWidth < (QZHSIZE_WIDTH_ALARMAREA - 5)) {
            return;
        }
        self.maskView.centerRect = CGRectMake([dic[@"x"] intValue]/100.0*(QZH_VIDEO_RIGHTMARGIN - QZH_VIDEO_LEFTMARGIN) + QZH_VIDEO_LEFTMARGIN, [dic[@"y"] intValue]/100.0*QZHScreenWidth, ([dic[@"xlen"] intValue] - [dic[@"x"] intValue])/100.0*(QZH_VIDEO_RIGHTMARGIN - QZH_VIDEO_LEFTMARGIN), ([dic[@"ylen"] intValue] - [dic[@"y"] intValue])/100.0*QZHScreenWidth);
        self.selectRect = CGRectMake([dic[@"x"] intValue]/100.0*(QZH_VIDEO_RIGHTMARGIN - QZH_VIDEO_LEFTMARGIN) + QZH_VIDEO_LEFTMARGIN, [dic[@"y"] intValue]/100.0*QZHScreenWidth, ([dic[@"xlen"] intValue] - [dic[@"x"] intValue])/100.0*(QZH_VIDEO_RIGHTMARGIN - QZH_VIDEO_LEFTMARGIN), ([dic[@"ylen"] intValue] - [dic[@"y"] intValue])/100.0*QZHScreenWidth);
    }
}
- (void)setConfigs{
    if (self.connected) {
        [self.camera startPreview];
        return;
    }
    self.playView.playBtn.hidden = YES;
    [self.playView.playPreGif startPlayGifWithImages:@[@"img_loading_anima1",@"img_loading_anima2",@"img_loading_anima3"]];
    self.playView.playPreGif.hidden = NO;
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

#pragma mark -- camerDelegate

-(void)cameraDidConnected:(id<TuyaSmartCameraType>)camera{
    [self scrollHor];
    self.connected = YES;
    [self.camera startPreview];

}
-(void)cameraDisconnected:(id<TuyaSmartCameraType>)camera{
      // p2p 连接被动断开，一般为网络波动导致
    self.connected = NO;
    self.previewing = NO;
    [self.camera connect];
    [self.playView.playPreGif stopGif];
}

-(void)cameraDidBeginPreview:(id<TuyaSmartCameraType>)camera{
    
    self.previewing = YES;
    [self.playView.playPreGif stopGif];

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
}
#pragma mark -- 唤醒设备
// 判断是否是低功耗门铃
- (BOOL)isDoorbell {

    return [self.dpManager isSupportDP:TuyaSmartCameraWirelessAwakeDPName];
}

- (void)startAwakeDevice {
    if ([self isDoorbell]) {
        // 获取设备的状态
            
        [self.device awakeDeviceWithSuccess:^{
            
            [self setConfigs];
        } failure:^(NSError *error) {
           [[QZHHUD HUD] textHUDWithMessage:error.userInfo[@"NSLocalizedDescription"] afterDelay:0.5];
            
        }];
    }
}

#pragma mark -- e横向转屏
- (void)scrollHor{
    [self.playView addSubview:self.camera.videoView];
    [self.camera.videoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0 ));
    }];
    [self.playView sendSubviewToBack:self.camera.videoView];
    [self.playView addSubview:self.submitBtn];
    [self.playView bringSubviewToFront:self.submitBtn];
    [self.maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0 ));
    }];
    QZHViewRadius(self.submitBtn, 25);
    [self.submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.playView);
        make.bottom.mas_equalTo(-20);
        make.width.mas_equalTo(180);
        make.height.mas_equalTo(50);
        
    }];
}

-(CameraPlayView *)playView{
    if (!_playView) {
        _playView = [[CameraPlayView alloc] init];
        _playView.voiceBtn.hidden = YES;
        _playView.definitionBtn.hidden = YES;
        _playView.horizontalBtn.hidden = YES;
        _playView.buttonBlock = ^(UIButton *sender, BOOL selected) {

        };
    }
    return _playView;
}
-(UIButton *)submitBtn{
    if (!_submitBtn) {
        _submitBtn = [[UIButton alloc] init];
        [_submitBtn setTitle:QZHLoaclString(@"setAlarmArea") forState:UIControlStateNormal];
        [_submitBtn setTitleColor:QZH_KIT_Color_WHITE_70 forState:UIControlStateNormal];
        _submitBtn.titleLabel.font = QZHKIT_FONT_LISTCELL_MAIN_TITLE;
        [_submitBtn exp_buttonState:QZHButtonStateEnable];
        [_submitBtn addTarget:self action:@selector(submitAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _submitBtn;
}

-(MaskView *)maskView{
    if (!_maskView) {
        QZHWS(weakSelf)
        _maskView = [[MaskView alloc] initWithFrame:self.navigationController.view.bounds];
        _maskView.popVCBlock = ^{
            // 刷新状态栏
        weakSelf.statusHiden = NO;
        // 刷新状态栏
        [weakSelf performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf.navigationController popViewControllerAnimated:YES];

            });
        };
        _maskView.gestureBolok = ^(CGRect rect, BOOL begain) {
            weakSelf.submitBtn.hidden = begain;
            weakSelf.selectRect = rect;
        };
    }
    return _maskView;
}
- (void)applicationWillEnterForeground{
    if (!self.connected) {
        [self.camera connect];
    }
    if (!self.previewing) {
        [self.camera startPreview];
    }
}
- (void)applicationWillEnterBackground{
    [self.camera stopPreview];
}
- (void)applicationWillResignActive{

    [self.camera stopPreview];
}
- (void)submitAction{
    
    NSDictionary *dic = @{@"num":@(1),@"region0":@{@"x":@((int)((self.selectRect.origin.x - QZH_VIDEO_LEFTMARGIN) * 100/(QZH_VIDEO_RIGHTMARGIN - QZH_VIDEO_LEFTMARGIN))),@"xlen":@((int)((self.selectRect.origin.x + self.selectRect.size.width - QZH_VIDEO_LEFTMARGIN) *100/(QZH_VIDEO_RIGHTMARGIN - QZH_VIDEO_LEFTMARGIN))),@"y":@((int)(self.selectRect.origin.y * 100/QZHScreenWidth)),@"ylen":@((int)((self.selectRect.origin.y + self.selectRect.size.height) * 100/QZHScreenWidth))}};
    
     NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *area = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
   NSString *areaClear = [area stringByReplacingOccurrencesOfString:@"\n" withString:@""];

    NSDictionary  *dps = @{@"169": areaClear};

    [self.device publishDps:dps success:^{
        
    [MBProgressHUD showError:QZHLoaclString(@"setSuccess") toView:self.playView];
    self.statusHiden = NO;
        
        // 刷新状态栏
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

            [self.navigationController popViewControllerAnimated:YES];
        });


    } failure:^(NSError *error) {
        [[QZHHUD HUD] textHUDWithMessage:error.userInfo[@"NSLocalizedDescription"] afterDelay:0.5];
    }];
}

- (BOOL)prefersStatusBarHidden{

    return self.statusHiden;
}

@end
