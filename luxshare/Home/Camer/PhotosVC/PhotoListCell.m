//
//  PhotoListCell.m
//  luxshare
//
//  Created by 黄振 on 2020/7/13.
//  Copyright © 2020 KingYellow. All rights reserved.
//

#import "PhotoListCell.h"

@implementation PhotoListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = QZH_KIT_Color_WHITE_100;
        [self creatSubViews];
    }
    return self;
}

- (void)creatSubViews {
    [self.contentView addSubview:self.IMGView];
    [self.contentView addSubview:self.logoIMG];
    [self.contentView addSubview:self.nameLab];
    [self.contentView addSubview:self.describeLab];
    [self.IMGView addSubview:self.selectBtn];
    [self.IMGView mas_makeConstraints:^(MASConstraintMaker *make) {
     make.left.top.mas_equalTo(10);
     make.width.mas_equalTo(QZHScreenWidth/2-20);
     make.height.mas_equalTo((QZHScreenWidth/2-20 )* 1080/1920);

    }];
    [self.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
         make.centerY.mas_equalTo(self.IMGView);
        make.left.mas_equalTo(self.IMGView.mas_right).offset(20);
     }];
    [self.describeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.IMGView.mas_right).offset(20);
        make.top.mas_equalTo(self.nameLab.mas_bottom).offset(5);
    }];
    [self.logoIMG mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.IMGView.mas_right).offset(20);
        make.bottom.mas_equalTo(self.nameLab.mas_top).offset(-5);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(30);
    }];
    [self.selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(10);
        make.width.height.mas_equalTo(25);
    }];

    
}
#pragma mark -lazy
-(UILabel *)nameLab{
    if (!_nameLab) {
        _nameLab = [[UILabel alloc] init];
        _nameLab.font = QZHKIT_FONT_LISTCELL_MAIN_TITLE;
        _nameLab.textColor = QZHKIT_Color_BLACK_87;
        _nameLab.text = @"--";
    }
    return  _nameLab;
}
-(UILabel *)describeLab{
    if (!_describeLab) {
        _describeLab = [[UILabel alloc] init];
        _describeLab.font = QZHKIT_FONT_LISTCELL_MAIN_TITLE;
        _describeLab.textColor = QZHKIT_Color_BLACK_87;
        _describeLab.text = @"--";
    }
    return  _describeLab;
}

-(UIImageView *)IMGView{
    if (!_IMGView) {
        _IMGView = [[UIImageView alloc] init];
        _IMGView.contentMode = UIViewContentModeScaleToFill;
    }
    return _IMGView;
}
-(UIImageView *)logoIMG{
    if (!_logoIMG) {
        _logoIMG = [[UIImageView alloc] init];
    }
    return _logoIMG;
}
-(UIButton *)selectBtn{
    if (!_selectBtn) {
        _selectBtn = [[UIButton alloc] init];
        [_selectBtn setImage:[UIImage new] forState:UIControlStateNormal];
        [_selectBtn setImage:QZHLoadIcon(@"pay_selected") forState:UIControlStateSelected];
    }
    return _selectBtn;
}
- (void)setFrame:(CGRect)frame {

    frame.size.height -= QZHSIZE_HEIGHT_LISTCELL_SEPARATOR;
    [super setFrame:frame];
    
}

@end
