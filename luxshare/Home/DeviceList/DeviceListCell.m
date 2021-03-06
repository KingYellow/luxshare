//
//  DeviceListCell.m
//  luxshare
//
//  Created by 黄振 on 2020/7/7.
//  Copyright © 2020 KingYellow. All rights reserved.
//

#import "DeviceListCell.h"

@implementation DeviceListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = QZH_KIT_Color_WHITE_100;
        [self creatSubViews];
    }
    return self;
}

- (void)creatSubViews {
    [self.contentView addSubview:self.selectBtn];
    [self.contentView addSubview:self.nameLab];
    [self.contentView addSubview:self.poloIMG];
    
    [self.selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(20);
        make.centerY.mas_equalTo(self.contentView);
        make.left.mas_equalTo(15);
    }];

    [self.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView);
        make.left.mas_equalTo(self.poloIMG.mas_right).offset(10);
     }];

    [self.poloIMG mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.selectBtn.mas_right).offset(5);
        make.centerY.mas_equalTo(self.nameLab);
        make.width.mas_equalTo(70);
        make.height.mas_equalTo(70);
    }];

    
}
#pragma mark -lazy
- (UILabel *)nameLab{
    if (!_nameLab) {
        _nameLab = [[UILabel alloc] init];
        _nameLab.font = QZHKIT_FONT_LISTCELL_SUB_TITLE;
        _nameLab.textColor = QZHKIT_Color_BLACK_87;
    }
    return  _nameLab;
}
- (UIImageView *)poloIMG{
    if (!_poloIMG) {
        _poloIMG = [[UIImageView alloc] init];
    }
    return _poloIMG;
}
- (UIButton *)selectBtn{
    if (!_selectBtn) {
        _selectBtn = [[UIButton alloc] init];
        [_selectBtn setImage:QZHLoadIcon(@"ty_devicelist_dot_green") forState:UIControlStateNormal];
        [_selectBtn setImage:QZHLoadIcon(@"ty_devicelist_dot_gray") forState:UIControlStateSelected];
    }
    return _selectBtn;
}

@end
