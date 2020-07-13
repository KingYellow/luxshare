//
//  QZHMessageCell.m
//  luxshare
//
//  Created by 黄振 on 2020/6/30.
//  Copyright © 2020 KingYellow. All rights reserved.
//

#import "QZHMessageCell.h"

@implementation QZHMessageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = QZHKIT_COLOR_LEADBACK;
        [self creatSubViews];
    }
    return self;
}

- (void)creatSubViews {
    [self.contentView addSubview:self.bigView];
    [self addSubview:self.selectBtn];
    [self.contentView addSubview:self.nameLab];
    [self.contentView addSubview:self.tagLab];
    [self.contentView addSubview:self.contentLab];
     
     [self.selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
         make.right.mas_equalTo(-15);
         make.width.height.mas_equalTo(20);
         make.centerY.mas_equalTo(self.contentView);

     }];
    [self.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).offset(20);
        make.left.mas_equalTo(25);
     }];
    [self.contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.nameLab.mas_bottom).offset(10);
        make.left.mas_equalTo(25);
        make.bottom.mas_equalTo(self.contentView).offset(-25);
        make.right.mas_equalTo(-20);
    }];
    [self.tagLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nameLab.mas_right);
        make.top.mas_equalTo(self.contentView.mas_top).offset(20);
        make.right.mas_equalTo(self.selectBtn.mas_left).offset(-5);

    }];
    [self.bigView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(10, 10, 10, 10));
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
-(UILabel *)tagLab{
    if (!_tagLab) {
        _tagLab = [[UILabel alloc] init];
        _tagLab.font = QZHKIT_FONT_LISTCELL_TIME_TITLE;
        _tagLab.textColor = QZHKIT_Color_BLACK_26;
        _tagLab.textAlignment = NSTextAlignmentRight;
    }
    return  _tagLab;
}
-(UILabel *)contentLab{
    if (!_contentLab) {
        _contentLab = [[UILabel alloc] init];
        _contentLab.font = QZHKIT_FONT_LISTCELL_DESCRIBE_TITLE;
        _contentLab.textColor = QZHKIT_Color_BLACK_54;
        _contentLab.numberOfLines = 0;
    }
    return  _contentLab;
}
-(UIView *)bigView{
    if (!_bigView) {
        _bigView = [[UIView alloc] init];
        _bigView.backgroundColor = QZHColorWhite;
        QZHViewRadius(_bigView, 8);
    }
    return _bigView;
}


@end
