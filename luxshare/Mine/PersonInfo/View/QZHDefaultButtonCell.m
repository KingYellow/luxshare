//
//  QZHDefaultButtonCell.m
//  luxshare
//
//  Created by 黄振 on 2020/6/24.
//  Copyright © 2020 KingYellow. All rights reserved.
//

#import "QZHDefaultButtonCell.h"

@implementation QZHDefaultButtonCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = QZH_KIT_Color_WHITE_100;
        [self creatSubViews];
    }
    return self;
}

- (void)creatSubViews {
    [self.contentView addSubview:self.nameLab];
     

    [self.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.contentView);
     }];

}
#pragma mark -lazy
-(UILabel *)nameLab{
    if (!_nameLab) {
        _nameLab = [[UILabel alloc] init];
        _nameLab.font = QZHKIT_FONT_LISTCELL_MAIN_TITLE;
        _nameLab.textAlignment = NSTextAlignmentCenter;
        _nameLab.textColor = QZHColorRed;
    }
    return  _nameLab;
}


- (void)setFrame:(CGRect)frame {

    frame.size.height -= QZHSIZE_HEIGHT_LISTCELL_SEPARATOR;
    [super setFrame:frame];
}

@end
