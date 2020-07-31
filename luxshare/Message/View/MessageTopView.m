//
//  MessageTopView.m
//  luxshare
//
//  Created by 黄振 on 2020/6/30.
//  Copyright © 2020 KingYellow. All rights reserved.
//

#import "MessageTopView.h"

@implementation MessageTopView
-(instancetype)init{
    if (self == [super init]) {
        [self creatViews];
    }
    return self;
}
+ (MessageTopView *)initmessagetopViewName:(NSString *)name{
    MessageTopView *view = [[self alloc] init];
    view.nameLab.text = name;
    return view;
}
- (void)creatViews{
    [self addSubview:self.nameLab];
    [self addSubview:self.normalBtn];
    [self addSubview:self.selectBtn];
    [self.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(15);
    }];
    [self.normalBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.right.mas_equalTo(-15);
        make.width.height.mas_equalTo(30);
    }];
    [self.selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(80);
    }];
}
-(UILabel *)nameLab{
    if (!_nameLab) {
        _nameLab = [[UILabel alloc] init];
        _nameLab.textColor = QZHKIT_Color_BLACK_87;
        _nameLab.font = QZHTEXT_FONTBold(18);
    }
    return _nameLab;
}
-(UIButton *)normalBtn{
    if (!_normalBtn) {
        _normalBtn = [[UIButton alloc] init];
        [_normalBtn setImage:QZHLoadIcon(@"ic_select") forState:UIControlStateNormal];
    }
    return _normalBtn;
}
-(UIButton *)selectBtn{
    if (!_selectBtn) {
        _selectBtn = [[UIButton alloc] init];
        _selectBtn.hidden = YES;
        [_selectBtn setTitle:QZHLoaclString(@"message_all") forState:UIControlStateNormal];
        [_selectBtn setTitleColor:QZHKIT_Color_BLACK_54 forState:UIControlStateNormal];
        _selectBtn.titleLabel.font = QZHKIT_FONT_LISTCELL_DESCRIBE_TITLE;
        [_selectBtn setImage:QZHLoadIcon(@"pay_normal") forState:UIControlStateNormal];
        [_selectBtn setImage:QZHLoadIcon(@"pay_selected") forState:UIControlStateSelected];
        [_selectBtn jk_setImagePosition:LXMImagePositionRight spacing:2];
    }
    return _selectBtn;
}
@end
