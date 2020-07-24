//
//  CameraPlayView.m
//  luxshare
//
//  Created by 黄振 on 2020/7/11.
//  Copyright © 2020 KingYellow. All rights reserved.
//

#import "CameraPlayView.h"

@implementation CameraPlayView

-(instancetype)init{
    if (self == [super init]) {
        [self creatSubViews];
        self.backgroundColor = QZHColorBlack;
    }
    return self;
}
- (void)creatSubViews {
//    [self.contentView addSubview:self.preView];
    [self addSubview:self.playBtn];
    [self addSubview:self.voiceBtn];
    [self addSubview:self.definitionBtn];
    [self addSubview:self.horizontalBtn];

//    [self.preView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
//    }];
    
    [self.playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(40);
        make.center.mas_equalTo(self);
    }];

    [self.voiceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(20);
        make.height.mas_equalTo(20);
        make.left.mas_equalTo(20);
        make.bottom.mas_equalTo(-30);

    }];
    [self.definitionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(25);
        make.left.mas_equalTo(self.voiceBtn.mas_right).offset(50);
        make.bottom.mas_equalTo(-30);

    }];
    [self.horizontalBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(30);
        make.right.mas_equalTo(-30);
        make.bottom.mas_equalTo(-30);

    }];
    
}
#pragma mark -lazy

-(UIButton *)playBtn{
    if (!_playBtn) {
        _playBtn = [[UIButton alloc] init];
        [_playBtn setImage:QZHLoadIcon(@"pay_normal") forState:UIControlStateNormal];
        [_playBtn setImage:QZHLoadIcon(@"pay_selected") forState:UIControlStateSelected];
        _playBtn.tag = 0;
        [_playBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playBtn;
}
-(UIButton *)voiceBtn{
    if (!_voiceBtn) {
        _voiceBtn = [[UIButton alloc] init];
        [_voiceBtn setImage:QZHLoadIcon(@"pay_normal") forState:UIControlStateNormal];
        [_voiceBtn setImage:QZHLoadIcon(@"pay_selected") forState:UIControlStateSelected];
        _voiceBtn.tag = 1;
        _voiceBtn.selected = YES;
        [_voiceBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _voiceBtn;
}
-(UIButton *)definitionBtn{
    if (!_definitionBtn) {
        _definitionBtn = [[UIButton alloc] init];
        [_definitionBtn setTitle:@"HD" forState:UIControlStateNormal];
        [_definitionBtn setTitleColor:QZH_KIT_Color_WHITE_70 forState:UIControlStateNormal];
        _definitionBtn.titleLabel.font = QZHKIT_FONT_LISTCELL_SUB_TITLE;
        _definitionBtn.tag = 2;
        [_definitionBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _definitionBtn;
}
-(UIButton *)horizontalBtn{
    if (!_horizontalBtn) {
        _horizontalBtn = [[UIButton alloc] init];
        [_horizontalBtn setImage:QZHLoadIcon(@"pay_normal") forState:UIControlStateNormal];
        [_horizontalBtn setImage:QZHLoadIcon(@"pay_selected") forState:UIControlStateSelected];
        _horizontalBtn.tag = 3;
        [_horizontalBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _horizontalBtn;
}
//-(UIView<TuyaSmartVideoViewType> *)videoView{
//    if (!_videoView) {
//        _videoView = [[UIView<TuyaSmartVideoViewType> alloc] init];
//        _videoView.backgroundColor = UIColor.greenColor;
//        [self sendSubviewToBack:self.videoView];
//
//    }
//    return _videoView;
//}
- (void)buttonAction:(UIButton *)sender{
    sender.selected = !sender.selected;
    //sender.tag == 0) {
        //播放
    //sender.tag == 1){
        //声音
    //ender.tag == 2){
        //清晰度
    //sender.tag == 3){
        //横屏
    
    self.buttonBlock(sender.tag,sender.selected);
}

@end
