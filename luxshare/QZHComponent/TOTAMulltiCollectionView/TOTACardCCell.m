//
//  TOTACardCCell.m
//  DDSample
//
//  Created by 黄振 on 2020/4/17.
//  Copyright © 2020 KingYellow. All rights reserved.
//

#import "TOTACardCCell.h"

@implementation TOTACardCCell
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = QZH_KIT_Color_WHITE_100;
        [self creatSubviews];
    }
    return self;
}

- (void)creatSubviews{
    [self.contentView addSubview:self.titleLab];
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.contentView);
    }];
}

- (UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.font = QZHKIT_FONT_LISTCELL_MAIN_TITLE;
        _titleLab.textColor = QZHKIT_Color_BLACK_87;
    }
    return _titleLab;
}
@end
