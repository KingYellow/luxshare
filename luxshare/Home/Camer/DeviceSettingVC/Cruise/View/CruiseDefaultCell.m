//
//  CruiseDefaultCell.m
//  luxshare
//
//  Created by 黄振 on 2020/12/28.
//  Copyright © 2020 KingYellow. All rights reserved.
//

#import "CruiseDefaultCell.h"

@implementation CruiseDefaultCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {

        [self creatSubViews];
        self.contentView.backgroundColor = QZHColorWhite;
    }
    return self;
}

- (void)creatSubViews {
    [self.contentView addSubview:self.nameLab];
    [self.contentView addSubview:self.contentLab];
    [self.contentView addSubview:self.selectBtn];

    
    [self.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(15);
     }];
    
    [self.contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.nameLab.mas_bottom).offset(10);
        make.bottom.mas_equalTo(-10);
        make.right.mas_equalTo(self.selectBtn.mas_left).offset(-10);
        make.left.mas_equalTo(15);
    }];
    [self.selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(30);
        make.centerY.mas_equalTo(self.contentView);
        make.right.mas_equalTo(-15);
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
-(UILabel *)contentLab{
    if (!_contentLab) {
        _contentLab = [[UILabel alloc] init];
        _contentLab.font = QZHKIT_FONT_NAVIBAR_ITEM_TITLE;
        _contentLab.textColor = QZHKIT_Color_BLACK_54;
        _contentLab.numberOfLines = 0;
    }
    return _contentLab;;
}
-(UIButton *)selectBtn{
    if (!_selectBtn) {
        _selectBtn = [[UIButton alloc] init];
        [_selectBtn setImage:QZHLoadIcon(@"pay_normal") forState:UIControlStateNormal];
        [_selectBtn setImage:QZHLoadIcon(@"pay_selected") forState:UIControlStateSelected];
    }
    return _selectBtn;
}
@end
