//
//  CameraThreeBtnCell.m
//  luxshare
//
//  Created by 黄振 on 2020/7/7.
//  Copyright © 2020 KingYellow. All rights reserved.
//

#import "CameraThreeBtnCell.h"

@implementation CameraThreeBtnCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {

        [self creatSubViews];
        self.backgroundColor = QZHKIT_COLOR_LEADBACK;
    }
    return self;
}

- (void)creatSubViews {
    [self.contentView addSubview:self.bigView];
    [self.contentView addSubview:self.leftBtn];
    [self.contentView addSubview:self.rightBtn];
    [self.contentView addSubview:self.midBtn];
    
    [self.bigView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(5, 5, 5, 5));
    }];
    
    [self.leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(QZHScreenWidth/3);
        make.height.mas_equalTo(80 * QZHScaleWidth);
        make.left.top.mas_equalTo(0);
    }];
    [self.midBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(QZHScreenWidth/3);
        make.height.mas_equalTo(80 * QZHScaleWidth);
        make.left.mas_equalTo(QZHScreenWidth/3);
        make.top.mas_equalTo(0);
    }];

    [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(QZHScreenWidth/3);
        make.height.mas_equalTo(80 * QZHScaleWidth);
        make.right.top.mas_equalTo(0);

    }];
    
}
#pragma mark -lazy
-(UIView *)bigView{
    if (!_bigView) {
        _bigView = [[UIView alloc] init];
        _bigView.backgroundColor = QZHColorWhite;
        QZHViewRadius(_bigView, 5);
    }
    return _bigView;
}

-(UIButton *)leftBtn{
    if (!_leftBtn) {
        _leftBtn = [[UIButton alloc] init];
        [_leftBtn setTitle:@"录像" forState:UIControlStateNormal];
        [_leftBtn setTitle:@"停止" forState:UIControlStateSelected];

        _leftBtn.titleLabel.font = QZHKIT_FONT_LISTCELL_BIG_TITLE;
        [_leftBtn setTitleColor:QZHKIT_COLOR_SKIN forState:UIControlStateNormal];
        [_leftBtn setImage:QZHLoadIcon(@"") forState:UIControlStateNormal];
        _leftBtn.tag = -1;
        [_leftBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftBtn;
}


-(UIButton *)midBtn{
    if (!_midBtn) {
        _midBtn = [[UIButton alloc] init];
        [_midBtn setTitle:@"通话" forState:UIControlStateNormal];
        [_midBtn setTitle:@"挂断" forState:UIControlStateSelected];

        _midBtn.titleLabel.font = QZHKIT_FONT_LISTCELL_BIG_TITLE;
        [_midBtn setTitleColor:QZHKIT_COLOR_SKIN forState:UIControlStateNormal];
        [_midBtn setImage:QZHLoadIcon(@"") forState:UIControlStateNormal];
        _midBtn.tag = 0;
        [_midBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _midBtn;
}
-(UIButton *)rightBtn{
    if (!_rightBtn) {
        _rightBtn = [[UIButton alloc] init];
        [_rightBtn setTitle:@"截屏" forState:UIControlStateNormal];
        _rightBtn.titleLabel.font = QZHKIT_FONT_LISTCELL_BIG_TITLE;
        [_rightBtn setTitleColor:QZHKIT_COLOR_SKIN forState:UIControlStateNormal];
        [_rightBtn setImage:QZHLoadIcon(@"") forState:UIControlStateNormal];
        _rightBtn.tag = 1;
        [_rightBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];

    }
    return _rightBtn;
}
- (void)btnAction:(UIButton *)sender{
    sender.selected = !sender.selected;
    self.btnBlock(sender.tag, sender.selected);
}

@end
