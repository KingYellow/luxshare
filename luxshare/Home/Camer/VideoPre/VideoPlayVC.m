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
@end

@implementation VideoPlayVC

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
    self.player.delegate = self;
    [self.view addSubview:self.player];
    self.player.frame = CGRectMake(0, 0, QZHScreenWidth, QZHScreenHeight-QZHHeightTop);
    [self.player play];
}

-(void)wmplayerFinishedPlay:(WMPlayer *)wmplayer;{
    self.state = WMPlayerStateFinished;
    
}
-(void)wmplayerReadyToPlay:(WMPlayer *)wmplayer WMPlayerStatus:(WMPlayerState)state{
    self.state = state;
    
}

-(void)wmplayer:(WMPlayer *)wmplayer clickedPlayOrPauseButton:(UIButton *)playOrPauseBtn{
//    [self.player play];
    if (self.state == WMPlayerStateFinished) {
        [self.player play];
        self.state = WMPlayerStatePlaying;
        
    }else{

        if (!playOrPauseBtn.selected) {
            [self.player play];
        }else{
            [self.player pause];
        }
    }

}
//点击关闭按钮代理方法
-(void)wmplayer:(WMPlayer *)wmplayer clickedCloseButton:(UIButton *)backBtn;{
    [self.navigationController popViewControllerAnimated:YES];
    [self.player removeFromSuperview];
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

@end
