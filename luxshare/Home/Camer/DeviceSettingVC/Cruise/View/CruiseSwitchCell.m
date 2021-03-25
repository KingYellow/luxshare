//
//  CruiseSwitchCell.m
//  luxshare
//
//  Created by 黄振 on 2020/12/28.
//  Copyright © 2020 KingYellow. All rights reserved.
//

#import "CruiseSwitchCell.h"
@implementation CruiseSwitchCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {

        [self creatSubViews];
        self.contentView.backgroundColor = QZHColorWhite;
    }
    return self;
}

- (void)creatSubViews {
    [self.contentView addSubview:self.switchBtn];
    [self.contentView addSubview:self.nameLab];

    [self.switchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView);
        make.right.mas_equalTo(-15);
    }];
    
    [self.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(50);
        make.left.mas_equalTo(15);
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

- (UISwitch *)switchBtn{
    if (!_switchBtn) {
        _switchBtn = [[UISwitch alloc] init];
        _switchBtn.selected = NO;
    }
    return _switchBtn;
}


@end
