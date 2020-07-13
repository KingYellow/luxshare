//
//  HomeSelectCell.m
//  luxshare
//
//  Created by 黄振 on 2020/7/3.
//  Copyright © 2020 KingYellow. All rights reserved.
//

#import "HomeSelectCell.h"

@implementation HomeSelectCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {

        [self creatSubViews];
    }
    return self;
}

- (void)creatSubViews {
    [self.contentView addSubview:self.selectBtn];
    [self.contentView addSubview:self.nameLab];
    [self.contentView addSubview:self.describeLab];
    [self.contentView addSubview:self.statusLab];
    
    [self.selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(30);
        make.centerY.mas_equalTo(self.contentView);
        make.left.mas_equalTo(15);
    }];

    [self.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView);
        make.left.mas_equalTo(self.selectBtn.mas_right).offset(10);
     }];
    [self.statusLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView);
        make.left.mas_equalTo(self.nameLab.mas_right).offset(10);
     }];
    [self.describeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-QZHKIT_MARGIN_RIGHT_LISTCELL_TEXT);
        make.centerY.mas_equalTo(self.nameLab);
    }];

    
}
#pragma mark -lazy
-(UILabel *)nameLab{
    if (!_nameLab) {
        _nameLab = [[UILabel alloc] init];
        _nameLab.font = QZHKIT_FONT_LISTCELL_MAIN_TITLE;
        _nameLab.textColor = QZHKIT_Color_BLACK_87;
    }
    return  _nameLab;
}
-(UILabel *)statusLab{
    if (!_statusLab) {
        _statusLab = [[UILabel alloc] init];
        _statusLab.font = QZHKIT_FONT_LISTCELL_MAIN_TITLE;
        _statusLab.textColor = QZHColorRed;
    }
    return  _statusLab;
}
-(UILabel *)describeLab{
    if (!_describeLab) {
        _describeLab = [[UILabel alloc] init];
        _describeLab.font = QZHKIT_FONT_LISTCELL_SUB_TITLE;
        _describeLab.textColor = QZHKIT_Color_BLACK_54;
    }
    return  _describeLab;
}
-(UIButton *)selectBtn{
    if (!_selectBtn) {
        _selectBtn = [[UIButton alloc] init];
        _selectBtn.userInteractionEnabled = NO;
        [_selectBtn setImage:QZHLoadIcon(@"pay_normal") forState:UIControlStateNormal];
        [_selectBtn setImage:QZHLoadIcon(@"pay_selected") forState:UIControlStateSelected];
    }
    return _selectBtn;
}

@end
