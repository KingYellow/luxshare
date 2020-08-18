//
//  AlarmTimeListCell.m
//  luxshare
//
//  Created by 黄振 on 2020/8/6.
//  Copyright © 2020 KingYellow. All rights reserved.
//

#import "AlarmTimeListCell.h"

@implementation AlarmTimeListCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = QZH_KIT_Color_WHITE_100;
        [self creatSubViews];
    }
    return self;
}
- (void)creatSubViews{
    [self.contentView addSubview:self.timeLab];
    [self.contentView addSubview:self.weekLab];
    [self.contentView addSubview:self.itemLab];
    [self.contentView addSubview:self.statusSwitch];

    [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(self.contentView.mas_top).offset(15);

    }];
    [self.weekLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(self.timeLab.mas_bottom).offset(10);

    }];
    [self.itemLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(self.weekLab.mas_bottom).offset(5);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-15);
    }];
    [self.statusSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.centerY.mas_equalTo(self.contentView);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(50);
    }];
}

-(UILabel *)timeLab{
    if (!_timeLab) {
        _timeLab = [[UILabel alloc] init];
        _timeLab.textColor = QZHKIT_Color_BLACK_87;
        _timeLab.font = QZHKIT_FONT_LISTCELL_MAIN_TITLE;
        
    }
    return _timeLab;
}

-(UILabel *)weekLab{
    if (!_weekLab) {
        _weekLab = [[UILabel alloc] init];
        _weekLab.textColor = QZHKIT_Color_BLACK_54;
        _weekLab.font = QZHKIT_FONT_LISTCELL_SUB_TITLE;
        
    }
    return _weekLab;
}
-(UILabel *)itemLab{
    if (!_itemLab) {
        _itemLab = [[UILabel alloc] init];
        _itemLab.textColor = QZHKIT_Color_BLACK_54;
        _itemLab.font = QZHKIT_FONT_LISTCELL_SUB_TITLE;
        
    }
    return _itemLab;
}
-(UISwitch *)statusSwitch{
    if (!_statusSwitch) {
        _statusSwitch = [[UISwitch alloc] init];
    }
    return _statusSwitch;
}
@end
