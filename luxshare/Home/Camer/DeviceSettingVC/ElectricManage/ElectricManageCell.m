//
//  ElectricManageCell.m
//  luxshare
//
//  Created by 黄振 on 2020/7/20.
//  Copyright © 2020 KingYellow. All rights reserved.
//

#import "ElectricManageCell.h"

@implementation ElectricManageCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = QZH_KIT_Color_WHITE_100;
        [self creatSubViews];
    }
    return self;
}

- (void)creatSubViews {
    [self.contentView addSubview:self.nameLab];
    [self.contentView addSubview:self.describeLab];
    [self.contentView addSubview:self.statusLab];

    [self.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15);
        make.left.mas_equalTo(15);
     }];
    [self.statusLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView);
        make.right.mas_equalTo(-15);
     }];
    [self.describeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(self.nameLab.mas_bottom).offset(10);
    }];

    
}
#pragma mark -lazy
- (UILabel *)nameLab{
    if (!_nameLab) {
        _nameLab = [[UILabel alloc] init];
        _nameLab.font = QZHKIT_FONT_LISTCELL_MAIN_TITLE;
        _nameLab.textColor = QZHKIT_Color_BLACK_87;
    }
    return  _nameLab;
}
- (UILabel *)statusLab{
    if (!_statusLab) {
        _statusLab = [[UILabel alloc] init];
        _statusLab.font = QZHKIT_FONT_LISTCELL_SUB_TITLE;
        _statusLab.textColor = QZHKIT_Color_BLACK_54;
    }
    return  _statusLab;
}
- (UILabel *)describeLab{
    if (!_describeLab) {
        _describeLab = [[UILabel alloc] init];
        _describeLab.font = QZHKIT_FONT_LISTCELL_SUB_TITLE;
        _describeLab.textColor = QZHKIT_Color_BLACK_54;
    }
    return  _describeLab;
}

- (void)setFrame:(CGRect)frame {

    frame.size.height -= QZHSIZE_HEIGHT_LISTCELL_SEPARATOR;
    [super setFrame:frame];
}

@end
