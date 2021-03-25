//
//  PTZDirectionCell.m
//  luxshare
//
//  Created by 黄振 on 2020/12/22.
//  Copyright © 2020 KingYellow. All rights reserved.
//

#import "PTZDirectionCell.h"

@implementation PTZDirectionCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {

        [self creatSubViews];
    }
    return self;
}
- (void)creatSubViews{
//    [self.contentView addSubview:self.leftTopBtn];
    [self.contentView addSubview:self.topBtn];
//    [self.contentView addSubview:self.rightTopBtn];
    [self.contentView addSubview:self.rightBtn];
//    [self.contentView addSubview:self.rightBottomBtn];
    [self.contentView addSubview:self.bottomBtn];
//    [self.contentView addSubview:self.leftBottomBtn];
    [self.contentView addSubview:self.leftBtn];
    [self.contentView addSubview:self.centerBtn];
    NSInteger wh = 60 * QZHScaleWidth;
    [self.centerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.contentView);
        make.width.height.mas_equalTo(wh);
    }];
//    [self.leftTopBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.mas_equalTo(self.centerBtn.mas_top);
//        make.right.mas_equalTo(self.centerBtn.mas_left);
//        make.width.height.mas_equalTo(wh);
//    }];
    [self.topBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.centerBtn.mas_top);
        make.centerX.mas_equalTo(self.centerBtn.mas_centerX);
        make.width.height.mas_equalTo(wh);
    }];
//    [self.rightTopBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.mas_equalTo(self.centerBtn.mas_top);
//        make.left.mas_equalTo(self.centerBtn.mas_right);
//        make.width.height.mas_equalTo(wh);
//    }];
    [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.centerBtn.mas_centerY);
        make.left.mas_equalTo(self.centerBtn.mas_right);
        make.width.height.mas_equalTo(wh);
    }];
//    [self.rightBottomBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.centerBtn.mas_bottom);
//        make.left.mas_equalTo(self.centerBtn.mas_right);
//        make.width.height.mas_equalTo(wh);
//    }];
    [self.bottomBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.centerBtn.mas_bottom);
        make.centerX.mas_equalTo(self.centerBtn.mas_centerX);
        make.width.height.mas_equalTo(wh);
    }];
//    [self.leftBottomBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.centerBtn.mas_bottom);
//        make.right.mas_equalTo(self.centerBtn.mas_left);
//        make.width.height.mas_equalTo(wh);
//    }];
    [self.leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.centerBtn.mas_centerY);
        make.right.mas_equalTo(self.centerBtn.mas_left);
        make.width.height.mas_equalTo(wh);
    }];
}

-(UIButton *)topBtn{
    if (!_topBtn) {
        UIButton *btn = [[UIButton alloc] init];
        [btn setImage:QZHLoadIcon(@"ic_ptz_up") forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(directionBtnAction:forEvent:) forControlEvents:UIControlEventAllTouchEvents];

        _topBtn = btn;
        _topBtn.tag = 0;
    }
    return _topBtn;
}
-(UIButton *)rightTopBtn{
    if (!_rightTopBtn) {
        UIButton *btn = [[UIButton alloc] init];
        [btn setImage:QZHLoadIcon(@"ic_ptz_up_right") forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(directionBtnAction:forEvent:) forControlEvents:UIControlEventAllTouchEvents];
        _rightTopBtn = btn;
        _rightTopBtn.tag = 1;
    }
    return _rightTopBtn;
}

-(UIButton *)rightBtn{
    if (!_rightBtn) {
        UIButton *btn = [[UIButton alloc] init];
        [btn setImage:QZHLoadIcon(@"ic_ptz_right") forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(directionBtnAction:forEvent:) forControlEvents:UIControlEventAllTouchEvents];
//        [btn addTarget:self action:@selector(directionBtnAction:) forControlEvents:UIControlEventTouchDown];
//        [btn addTarget:self action:@selector(stopAction) forControlEvents:UIControlEventTouchUpOutside];
        _rightBtn = btn;
        _rightBtn.tag = 2;
    }
    return _rightBtn;
}
-(UIButton *)rightBottomBtn{
    if (!_rightBottomBtn) {
        UIButton *btn = [[UIButton alloc] init];
        [btn setImage:QZHLoadIcon(@"ic_ptz_down_right") forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(directionBtnAction:forEvent:) forControlEvents:UIControlEventAllTouchEvents];

        _rightBottomBtn = btn;
        _rightBottomBtn.tag = 3;
    }
    return _rightBottomBtn;
}
-(UIButton *)bottomBtn{
    if (!_bottomBtn) {
        UIButton *btn = [[UIButton alloc] init];
        [btn setImage:QZHLoadIcon(@"ic_ptz_down") forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(directionBtnAction:forEvent:) forControlEvents:UIControlEventAllTouchEvents];
        _bottomBtn = btn;
        _bottomBtn.tag = 4;
    }
    return _bottomBtn;
}
-(UIButton *)leftBottomBtn{
    if (!_leftBottomBtn) {
        UIButton *btn = [[UIButton alloc] init];
        [btn setImage:QZHLoadIcon(@"ic_ptz_down_left") forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(directionBtnAction:forEvent:) forControlEvents:UIControlEventAllTouchEvents];
        _leftBottomBtn = btn;
        _leftBottomBtn.tag = 5;
    }
    return _leftBottomBtn;
}
-(UIButton *)leftBtn{
    if (!_leftBtn) {
        UIButton *btn = [[UIButton alloc] init];
        [btn setImage:QZHLoadIcon(@"ic_ptz_left") forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(directionBtnAction:forEvent:) forControlEvents:UIControlEventAllTouchEvents];
        _leftBtn = btn;
        _leftBtn.tag = 6;
    }
    return _leftBtn;
}
-(UIButton *)leftTopBtn{
    if (!_leftTopBtn) {
        UIButton *btn = [[UIButton alloc] init];
        [btn setImage:QZHLoadIcon(@"ic_ptz_up_left") forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(directionBtnAction:forEvent:) forControlEvents:UIControlEventAllTouchEvents];
        _leftTopBtn = btn;
        _leftTopBtn.tag = 7;
    }
    return _leftTopBtn;
}
-(UIButton *)centerBtn{
    if (!_centerBtn) {
        UIButton *btn = [[UIButton alloc] init];
        [btn setImage:QZHLoadIcon(@"ic_ptz_ok") forState:UIControlStateNormal];
//        [btn addTarget:self action:@selector( :forEvent:) forControlEvents:UIControlEventAllTouchEvents];
        btn.alpha = 0;
        _centerBtn = btn;
        _centerBtn.tag = 8;
    }
    return _centerBtn;
}
#pragma mark -- action
- (void)directionBtnAction:(UIButton *)sender forEvent:(UIEvent *)event{
    UITouchPhase phase = event.allTouches.anyObject.phase;
    if (phase == UITouchPhaseBegan) {
        self.direblock(sender.tag);

    }else if(phase == UITouchPhaseEnded){

        self.direblock(40000);

    }
}


@end
