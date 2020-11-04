//
//  QZHSelectCell.m
//  luxshare
//
//  Created by 黄振 on 2020/7/1.
//  Copyright © 2020 KingYellow. All rights reserved.
//

#import "QZHSelectCell.h"

@implementation QZHSelectCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = QZH_KIT_Color_WHITE_100;
        [self creatSubViews];
    }
    return self;
}

- (void)creatSubViews {
    [self.contentView addSubview:self.nameLab];
    [self.contentView addSubview:self.selectBtn];
     
    [self.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView);
        make.left.mas_equalTo(QZHKIT_MARGIN_LEFT_LISTCELL_TEXT);
     }];
    [self.selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20);
        make.centerY.mas_equalTo(self.nameLab);
        make.width.height.mas_equalTo(30);
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
- (UIButton *)selectBtn{
    if (!_selectBtn) {
        _selectBtn = [[UIButton alloc] init];
        [_selectBtn setImage:QZHLoadIcon(@"pay_normal") forState:UIControlStateNormal];
         [_selectBtn setImage:QZHLoadIcon(@"pay_selected") forState:UIControlStateSelected];
    }
    return _selectBtn;
}


@end
