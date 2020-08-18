//
//  MineHeaderCell.m
//  DDSample
//
//  Created by 黄振 on 2020/4/2.
//  Copyright © 2020 KingYellow. All rights reserved.
//

#import "MineHeaderCell.h"

@implementation MineHeaderCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = QZH_KIT_Color_WHITE_100;

        [self creatSubViews];
    }
    return self;
}

- (void)creatSubViews {
    [self.contentView addSubview:self.IMGView];
    [self.contentView addSubview:self.nameLab];
    [self.contentView addSubview:self.describeLab];
    [self.contentView addSubview:self.tagLab];
     
     [self.IMGView mas_makeConstraints:^(MASConstraintMaker *make) {
         make.left.top.mas_equalTo(QZHKIT_MARGIN_LEFT_LISTCELL_IMAGE);
         make.width.height.mas_equalTo(QZHSIZE_HEIGHT_LISTCELL_IMAGE);
         make.bottom.mas_equalTo(-QZHKIT_MARGIN_BOTTOM_LISTCELL_IMAGE);

     }];
    [self.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
         make.top.mas_equalTo(QZHKIT_MARGIN_TOP_LISTCELL_TEXT);
        make.left.mas_equalTo(self.IMGView.mas_right).offset(QZHKIT_MARGIN_H_LISTCELL_IMAGE_AND_TEXT);
     }];
    [self.describeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.IMGView.mas_right).offset(QZHKIT_MARGIN_H_LISTCELL_IMAGE_AND_TEXT);
        make.top.mas_equalTo(self.nameLab.mas_bottom).offset(QZHKIT_MARGIN_TOP_LISTCELL_TEXT);
    }];
    [self.tagLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-QZHKIT_MARGIN_RIGHT_LISTCELL_TEXT);
        make.centerY.mas_equalTo(self.contentView);
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
        _describeLab.font = QZHKIT_FONT_LISTCELL_SUB_TITLE;
        _describeLab.textColor = QZHKIT_Color_BLACK_54;
        _describeLab.text = @"--";
    }
    return  _describeLab;
}
-(UILabel *)tagLab{
    if (!_tagLab) {
        _tagLab = [[UILabel alloc] init];
        _tagLab.font = QZHKIT_FONT_LISTCELL_TIME_TITLE;
        _tagLab.textColor = QZHKIT_Color_BLACK_26;
        
    }
    return  _tagLab;
}
-(UIImageView *)IMGView{
    if (!_IMGView) {
        _IMGView = [[UIImageView alloc] init];
        _IMGView.contentMode = UIViewContentModeScaleToFill;
        QZHViewRadius(_IMGView, QZHSIZE_HEIGHT_LISTCELL_IMAGE/2);
    }
    return _IMGView;
}

- (void)setFrame:(CGRect)frame {

    frame.size.height -= QZHSIZE_HEIGHT_LISTCELL_SEPARATOR;
    [super setFrame:frame];
}

@end
