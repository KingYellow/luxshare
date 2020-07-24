//
//  SelectRoomCell.m
//  luxshare
//
//  Created by 黄振 on 2020/7/15.
//  Copyright © 2020 KingYellow. All rights reserved.
//

#import "SelectRoomCell.h"

@implementation SelectRoomCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = QZH_KIT_Color_WHITE_70;
        [self creatSubViews];
    }
    return self;
}

- (void)creatSubViews {
    [self addSubview:self.selectBtn];
    [self.contentView addSubview:self.nameLab];

     
     [self.selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
         make.right.mas_equalTo(-20);
         make.width.height.mas_equalTo(20);
         make.centerY.mas_equalTo(self.contentView);

     }];
    [self.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView);
        make.left.mas_equalTo(20);
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

- (UIButton *)selectBtn{
    if (!_selectBtn) {
        _selectBtn = [[UIButton alloc] init];
        [_selectBtn setImage:QZHLoadIcon(@"pay_normal") forState:UIControlStateNormal];
        [_selectBtn setImage:QZHLoadIcon(@"pay_selected") forState:UIControlStateSelected];

    }
    return _selectBtn;
}

@end
