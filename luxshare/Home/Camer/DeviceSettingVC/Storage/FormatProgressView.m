//
//  FormatProgressView.m
//  luxshare
//
//  Created by 黄振 on 2020/7/17.
//  Copyright © 2020 KingYellow. All rights reserved.
//

#import "FormatProgressView.h"

@implementation FormatProgressView

- (instancetype)init{
    if (self = [super init]) {
        [self creatViews];

    }
    return self;
}
- (void)creatViews{
    [self addSubview:self.bigView];
    [self.bigView addSubview:self.nameLab];
    [self.bigView addSubview:self.numberLab];
    
    [self.bigView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
        make.width.mas_equalTo(150);
        make.height.mas_equalTo(80);
    }];
    [self.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.centerX.mas_equalTo(self.bigView);
    }];
    [self.numberLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.nameLab.mas_bottom).offset(10);
        make.centerX.mas_equalTo(self.bigView);
    }];
    QZHViewRadius(self.bigView, 5.0);
}
- (UIView *)bigView{
    if (!_bigView) {
        _bigView = [[UIView alloc] init];
        _bigView.backgroundColor = QZH_KIT_Color_WHITE_100;
    }
    return _bigView;
}
- (UILabel *)nameLab{
    if (!_nameLab) {
        _nameLab = [[UILabel alloc] init];
        _nameLab.font = QZHKIT_FONT_LISTCELL_MAIN_TITLE;
        _nameLab.text = QZHLoaclString(@"formating");
        _nameLab.textColor = QZHKIT_Color_BLACK_87;
    }
    return _nameLab;
}
- (UILabel *)numberLab{
    if (!_numberLab) {
        _numberLab = [[UILabel alloc] init];
        _numberLab.font = QZHKIT_FONT_LISTCELL_MAIN_TITLE;
        _numberLab.text = @"0%";
        _numberLab.textColor = QZHKIT_Color_BLACK_54;
    }
    return _numberLab;
}


@end
