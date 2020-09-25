//
//  VideoPlayVC.m
//  luxshare
//
//  Created by 黄振 on 2020/7/14.
//  Copyright © 2020 KingYellow. All rights reserved.
//

#import "VideoPlayVC.h"

@interface VideoPlayVC ()<WMPlayerDelegate>
@property (strong, nonatomic)WMPlayer *player;
@property (assign, nonatomic)WMPlayerState state;
@property (assign, nonatomic)BOOL isHor;
@property (strong, nonatomic)UIButton *playBtn;
@end

@implementation VideoPlayVC

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.player pause];
}
- (void)viewDidLoad {
    [super viewDidLoad];
   [self initConfig];
    [self videoplay];
     
}
- (void)initConfig{
    self.view.backgroundColor = QZHKIT_COLOR_LEADBACK;
    self.navigationItem.title = @"录像视频";
    [self exp_navigationBarTextWithColor:QZHKIT_COLOR_NAVIBAR_TITLE font:QZHKIT_FONT_TABBAR_TITLE];
    [self exp_navigationBarColor:QZHKIT_COLOR_NAVIBAR_BACK hiddenShadow:NO];

}
- (void)videoplay{
    WMPlayerModel *model = [[WMPlayerModel alloc] init];
    model.playerItem = self.playiItem;
//    model.title = @"录像视频";
    model.presentationSize = CGSizeMake(QZHScreenWidth, QZHScreenWidth *1080/1920);
    model.verticalVideo = YES;
    self.player = [WMPlayer playerWithModel:model];
    self.player.backBtnStyle = BackBtnStyleNone;
    self.player.loopPlay = YES;
    self.player.delegate = self;
    [self.view addSubview:self.player];
    self.player.frame = CGRectMake(0, 0, QZHScreenWidth, QZHScreenHeight-QZHHeightTop - QZHHeightBottom);
    [self.player addSubview:self.playBtn];
    [self.playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.player);
    }];
    [self.player play];
}

-(void)wmplayerFinishedPlay:(WMPlayer *)wmplayer;{
//    self.state = WMPlayerStateFinished;
    [self.player pause];
    self.playBtn.hidden = NO;
    
}
-(void)wmplayerReadyToPlay:(WMPlayer *)wmplayer WMPlayerStatus:(WMPlayerState)state{
    self.state = state;
    self.playBtn.hidden = YES;
}

-(void)wmplayer:(WMPlayer *)wmplayer clickedPlayOrPauseButton:(UIButton *)playOrPauseBtn{
//    [self.player play];
    if (self.state == WMPlayerStateFinished) {
        [self.player play];
        self.state = WMPlayerStatePlaying;
        
    }else{

        if (!playOrPauseBtn.selected) {
            self.playBtn.hidden  = YES;
            [self.player play];
        }else{
            self.playBtn.hidden  = NO;
            [self.player pause];
        }
    }

}
//点击关闭按钮代理方法
-(void)wmplayer:(WMPlayer *)wmplayer clickedCloseButton:(UIButton *)backBtn;{
    [self.player removeFromSuperview];

    [self.navigationController popViewControllerAnimated:YES];
}
//点击全屏按钮代理方法
-(void)wmplayer:(WMPlayer *)wmplayer clickedFullScreenButton:(UIButton *)fullScreenBtn;{

    
   //顺时针 旋转180度(有BUG)
//     [UIView beginAnimations:nil context:nil];
//     [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
//     [UIView setAnimationDuration:0.2]; //动画时长

    self.isHor = !self.isHor;
    if (self.isHor) {
        [self.player removeFromSuperview];
        self.player.transform = CGAffineTransformMakeRotation(90*M_PI/180);
         CGAffineTransform transform = self.player.transform;
         transform = CGAffineTransformScale(transform, 1,1);
         self.player.transform = transform;
        [self.navigationController.view addSubview:self.player];
        self.player.frame = CGRectMake(0, 0, QZHScreenWidth, QZHScreenHeight);

    }else{
        [self.player removeFromSuperview];
        self.player.transform = CGAffineTransformMakeRotation(0*M_PI/90);
         CGAffineTransform transform = self.player.transform;
         transform = CGAffineTransformScale(transform, 1,1);
         self.player.transform = transform;
        [self.player removeFromSuperview];
        [self.view addSubview:self.player];
        self.player.frame = CGRectMake(0, 0, QZHScreenWidth, QZHScreenHeight - QZHHeightTop);
    }
}
#pragma mark -- lazy
-(UIButton *)playBtn{
    if (!_playBtn) {
        _playBtn = [[UIButton alloc] init];
        [_playBtn setImage:QZHLoadIcon(@"btn_doc_video_play_video") forState:UIControlStateNormal];
        _playBtn.hidden = YES;
        [_playBtn addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playBtn;
}
- (void)buttonAction{
    self.playBtn.hidden = YES;
    [self.player play];
}
@end
