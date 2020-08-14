//
//  CameraTBtnCell.m
//  luxshare
//
//  Created by 黄振 on 2020/7/7.
//  Copyright © 2020 KingYellow. All rights reserved.
//

#import "CameraTBtnCell.h"

@implementation CameraTBtnCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {

        [self creatSubViews];
        self.backgroundColor = QZHKIT_COLOR_LEADBACK;
    }
    return self;
}

- (void)creatSubViews {
    [self.contentView addSubview:self.leftBtn];
    [self.contentView addSubview:self.rightBtn];
    
    [self.leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(QZHScreenWidth/2);
        make.bottom.mas_equalTo(0);
        make.left.top.mas_equalTo(0);
    }];

    [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(QZHScreenWidth/2);
        make.bottom.mas_equalTo(0);
        make.right.top.mas_equalTo(0);

    }];
    
}
#pragma mark -lazy

-(UIButton *)leftBtn{
    if (!_leftBtn) {
        _leftBtn = [[UIButton alloc] init];
        [_leftBtn setTitle:@"唤醒" forState:UIControlStateNormal];
        _leftBtn.titleLabel.font = QZHKIT_FONT_LISTCELL_BIG_TITLE;
        [_leftBtn setTitleColor:QZHKIT_Color_BLACK_87 forState:UIControlStateNormal];
        [_leftBtn setImage:QZHLoadIcon(@"ic_awake_n") forState:UIControlStateNormal];
        [_leftBtn jk_setImagePosition:LXMImagePositionLeft spacing:15];
        _leftBtn.tag = -1;
        [_leftBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftBtn;
}
-(UIButton *)rightBtn{
    if (!_rightBtn) {
        _rightBtn = [[UIButton alloc] init];
        [_rightBtn setTitle:@"休眠" forState:UIControlStateNormal];
        _rightBtn.titleLabel.font = QZHKIT_FONT_LISTCELL_BIG_TITLE;
        [_rightBtn setTitleColor:QZHKIT_Color_BLACK_87 forState:UIControlStateNormal];
        [_rightBtn setImage:QZHLoadIcon(@"ic_sleep_n") forState:UIControlStateNormal];
        [_rightBtn jk_setImagePosition:LXMImagePositionLeft spacing:15];
        _rightBtn.tag = 1;
        [_rightBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];

    }
    return _rightBtn;
}
- (void)btnAction:(UIButton *)sender{
    self.btnBlock(sender.tag);
}

@end
