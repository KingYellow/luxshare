//
//  RecordProgressView.m
//  luxshare
//
//  Created by 黄振 on 2020/7/31.
//  Copyright © 2020 KingYellow. All rights reserved.
//

#import "RecordProgressView.h"

@implementation RecordProgressView

- (instancetype)init{
    if (self = [super init]) {
        self.backgroundColor = QZH_KIT_Color_WHITE_100;
        [self creatSubViews];
    }
    return self;
}
- (void)creatSubViews{
    [self addSubview:self.tipIMG];
    [self addSubview:self.timeLab];
    [self addSubview:self.typeLab];
    [self.tipIMG mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.height.width.mas_equalTo(15);
        make.centerY.mas_equalTo(self);
    }];
    [self.typeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.tipIMG.mas_right).offset(0);
        make.height.mas_equalTo(20);
        make.centerY.mas_equalTo(self);
    }];
    [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.typeLab.mas_right).offset(5);
        make.height.mas_equalTo(20);
        make.centerY.mas_equalTo(self);
    }];
    
}
- (UIImageView *)tipIMG{
    if (!_tipIMG) {
        _tipIMG = [[UIImageView alloc] init];
        _tipIMG.image = QZHLoadIcon(@"ic_all_record_ing");
    }
    return _tipIMG;
}
- (UILabel *)typeLab{
    if (!_typeLab) {
        _typeLab = [[UILabel alloc] init];
        _typeLab.textColor = QZH_KIT_Color_WHITE_70;
        _typeLab.font = QZHKIT_FONT_LISTCELL_SUB_TITLE;
        _typeLab.text = @"录制中";
    }
    return _typeLab;
}
- (UILabel *)timeLab{
    if (!_timeLab) {
        _timeLab = [[UILabel alloc] init];
        _timeLab.textColor = QZH_KIT_Color_WHITE_70;
        _timeLab.font = QZHKIT_FONT_LISTCELL_SUB_TITLE;
        _timeLab.text = @"00:00";
    }
    return _timeLab;
}
@end
