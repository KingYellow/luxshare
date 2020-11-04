//
//  TalkTypeCell.m
//  luxshare
//
//  Created by 黄振 on 2020/7/17.
//  Copyright © 2020 KingYellow. All rights reserved.
//

#import "TalkTypeCell.h"

@implementation TalkTypeCell


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
    [self.contentView addSubview:self.tipLab];

     
     [self.selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
         make.right.mas_equalTo(-20);
         make.width.height.mas_equalTo(20);
         make.centerY.mas_equalTo(self.contentView);

     }];
    [self.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView);
        make.left.mas_equalTo(20);
        
     }];
    [self.tipLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).offset(10);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-10);

        make.left.mas_equalTo(self.nameLab.mas_right).offset(5);
        make.right.mas_equalTo(self.selectBtn.mas_left).offset(-15);
     }];
   
    
}
#pragma mark -lazy
- (UILabel *)nameLab{
    if (!_nameLab) {
        _nameLab = [[UILabel alloc] init];
        _nameLab.textAlignment = NSTextAlignmentRight;
        _nameLab.font = QZHKIT_FONT_LISTCELL_BIG_TITLE;
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
- (UILabel *)tipLab{
    if (!_tipLab) {
        _tipLab = [[UILabel alloc] init];
        _tipLab.font = QZHKIT_FONT_LISTCELL_DESCRIBE_TITLE;
        _tipLab.textColor = QZHKIT_Color_BLACK_26;
        _tipLab.numberOfLines = 0;
        _tipLab.textAlignment = NSTextAlignmentRight;

    }
    return  _tipLab;
}
@end
