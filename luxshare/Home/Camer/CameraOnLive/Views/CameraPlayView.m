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
        self.backgroundColor = UIColor.blackColor;
    }
    return self;
}
- (void)creatSubViews {
//    [self.contentView addSubview:self.preView];
    [self addSubview:self.playBtn];
    [self addSubview:self.voiceBtn];
    [self addSubview:self.definitionBtn];
    [self addSubview:self.horizontalBtn];
    [self addSubview:self.playPreGif];
    [self addSubview:self.wifiIMG];
    [self addSubview:self.batteryIMG];
    [self addSubview:self.recordProgressView];
    [self addSubview:self.talkProgressView];

    QZHViewRadius(self.recordProgressView, 20);
    QZHViewRadius(self.talkProgressView, 20);
    QZHViewRadius(self.definitionBtn, 15);
    QZHViewRadius(self.horizontalBtn, 15);
    [self.playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
          make.width.mas_equalTo(60);
          make.height.mas_equalTo(40);
          make.center.mas_equalTo(self);
      }];
      [self.playPreGif mas_makeConstraints:^(MASConstraintMaker *make) {
          make.width.mas_equalTo(88);
          make.height.mas_equalTo(88);
          make.center.mas_equalTo(self);
      }];

      [self.voiceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
          make.width.mas_equalTo(30);
          make.height.mas_equalTo(30);
          make.left.mas_equalTo(10);
          make.bottom.mas_equalTo(-15);

      }];
      
      [self.definitionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
          make.width.mas_equalTo(50);
          make.height.mas_equalTo(30);
          make.left.mas_equalTo(self.voiceBtn.mas_right).offset(10);
          make.bottom.mas_equalTo(-15);

      }];
      
      [self.horizontalBtn mas_makeConstraints:^(MASConstraintMaker *make) {
          make.width.mas_equalTo(30);
          make.height.mas_equalTo(30);
          make.right.mas_equalTo(-20);
          make.bottom.mas_equalTo(-15);

      }];
      [self.wifiIMG mas_makeConstraints:^(MASConstraintMaker *make) {
          make.width.mas_equalTo(20);
          make.height.mas_equalTo(20);
          make.right.mas_equalTo(-15);
          make.top.mas_equalTo(20);

      }];
      [self.batteryIMG mas_makeConstraints:^(MASConstraintMaker *make) {
          make.width.mas_equalTo(20);
          make.height.mas_equalTo(20);
          make.right.mas_equalTo(self.wifiIMG.mas_left).offset(-5);
          make.top.mas_equalTo(20);

      }];
      [self.recordProgressView mas_makeConstraints:^(MASConstraintMaker *make) {
          make.width.mas_equalTo(150);
          make.height.mas_equalTo(40);
          make.centerX.mas_equalTo(self);
          make.bottom.mas_equalTo(-20);

      }];
      [self.talkProgressView mas_makeConstraints:^(MASConstraintMaker *make) {
          make.width.mas_equalTo(150);
          make.height.mas_equalTo(40);
          make.centerX.mas_equalTo(self);
          make.bottom.mas_equalTo(-20);

      }];
  
}
#pragma mark -lazy

-(UIButton *)playBtn{
    if (!_playBtn) {
        _playBtn = [[UIButton alloc] init];
        [_playBtn setImage:QZHLoadIcon(@"btn_doc_video_play_video") forState:UIControlStateNormal];
        _playBtn.tag = 0;
        [_playBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playBtn;
}
-(UIButton *)voiceBtn{
    if (!_voiceBtn) {
        _voiceBtn = [[UIButton alloc] init];
        [_voiceBtn setImage:QZHLoadIcon(@"camera_preview_sound_btn_on") forState:UIControlStateNormal];
        [_voiceBtn setImage:QZHLoadIcon(@"camera_preview_sound_btn_off") forState:UIControlStateSelected];
        _voiceBtn.tag = 1;
        _voiceBtn.selected = YES;
        [_voiceBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _voiceBtn;
}
-(UIButton *)definitionBtn{
    if (!_definitionBtn) {
        _definitionBtn = [[UIButton alloc] init];
        [_definitionBtn setTitle:@"高清" forState:UIControlStateNormal];
        [_definitionBtn setTitleColor:QZH_KIT_Color_WHITE_70 forState:UIControlStateNormal];
        _definitionBtn.titleLabel.font = QZHKIT_FONT_LISTCELL_SUB_TITLE;
        _definitionBtn.tag = 2;
        [_definitionBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        _definitionBtn.backgroundColor = QZHKIT_Color_BLACK_70;
    }
    return _definitionBtn;
}
-(UIButton *)horizontalBtn{
    if (!_horizontalBtn) {
        _horizontalBtn = [[UIButton alloc] init];
        [_horizontalBtn setImage:QZHLoadIcon(@"ic_full_screen") forState:UIControlStateNormal];
        [_horizontalBtn setImage:QZHLoadIcon(@"ic_part_screen") forState:UIControlStateSelected];
        _horizontalBtn.tag = 3;
        [_horizontalBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        _horizontalBtn.contentMode = UIViewContentModeScaleToFill;
        _horizontalBtn.backgroundColor = QZHKIT_Color_BLACK_70;
    }
    return _horizontalBtn;
}

- (UIImageView *)playPreGif{
    if (!_playPreGif) {
        _playPreGif = [[UIImageView alloc] init];
    }
    return _playPreGif;
}
- (UIImageView *)wifiIMG{
    if (!_wifiIMG) {
        _wifiIMG = [[UIImageView alloc] init];
    }
    return _wifiIMG;
}
- (UIImageView *)batteryIMG{
    if (!_batteryIMG) {
        _batteryIMG = [[UIImageView alloc] init];
    }
    return _batteryIMG;
}
-(RecordProgressView *)recordProgressView{
    if (!_recordProgressView) {
        _recordProgressView = [[RecordProgressView alloc] init];
        _recordProgressView.typeLab.text = @"录制中";
        _recordProgressView.tipIMG.image = QZHLoadIcon(@"ic_all_record_ing");
        _recordProgressView.backgroundColor = QZHKIT_COLOR_SKIN_AlPHA;
        _recordProgressView.hidden = YES;
    }
    return _recordProgressView;
}
-(RecordProgressView *)talkProgressView{
    if (!_talkProgressView) {
        _talkProgressView = [[RecordProgressView alloc] init];
        _talkProgressView.typeLab.text = @"通话中";
        _talkProgressView.tipIMG.image = QZHLoadIcon(@"ic_calling");
        _talkProgressView.backgroundColor = QZHKIT_COLOR_SKIN_AlPHA;
        _talkProgressView.hidden = YES;
    }
    return _talkProgressView;
}

- (void)buttonAction:(UIButton *)sender{
    //sender.tag == 0) {
        //播放
    //sender.tag == 1){
        //声音
    //ender.tag == 2){
        //清晰度
    //sender.tag == 3){
        //横屏
    
    self.buttonBlock(sender,sender.selected);
}


@end
