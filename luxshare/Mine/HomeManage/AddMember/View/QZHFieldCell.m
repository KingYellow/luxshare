//
//  QZHFieldCell.m
//  luxshare
//
//  Created by 黄振 on 2020/6/30.
//  Copyright © 2020 KingYellow. All rights reserved.
//

#import "QZHFieldCell.h"

@implementation QZHFieldCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {

        [self creatSubViews];
    }
    return self;
}

- (void)creatSubViews {
    [self.contentView addSubview:self.nameLab];
    [self.contentView addSubview:self.textfield];
    
     
    [self.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
         make.centerY.mas_equalTo(self.contentView);
        make.left.mas_equalTo(15);
        make.width.mas_equalTo(60);
        
     }];
    [self.textfield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView);
        make.left.mas_equalTo(self.nameLab.mas_right).offset(15);
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


-(UITextField *)textfield{
    if (!_textfield) {
        _textfield = [[UITextField alloc] init];
        _textfield.textColor = QZHKIT_Color_BLACK_87;
        _textfield.font = QZHKIT_FONT_LISTCELL_SUB_TITLE;
    }
    return _textfield;
}
- (void)setFrame:(CGRect)frame {

    frame.size.height -= QZHSIZE_HEIGHT_LISTCELL_SEPARATOR;
    [super setFrame:frame];
}

@end
