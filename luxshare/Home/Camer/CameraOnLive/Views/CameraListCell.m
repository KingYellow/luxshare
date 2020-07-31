//
//  CameraListCell.m
//  luxshare
//
//  Created by 黄振 on 2020/7/7.
//  Copyright © 2020 KingYellow. All rights reserved.
//

#import "CameraListCell.h"

@implementation CameraListCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {

        [self creatSubViews];
        self.contentView.backgroundColor = QZHKIT_COLOR_LEADBACK;
    }
    return self;
}

- (void)creatSubViews {
    [self.contentView addSubview:self.bigView];
    [self.contentView addSubview:self.IMGView];
    [self.contentView addSubview:self.nameLab];
    [self.contentView addSubview:self.tagLab];
    [self.contentView addSubview:self.forward];

    
    [self.bigView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(5, 5, 5, 5));
    }];
     [self.IMGView mas_makeConstraints:^(MASConstraintMaker *make) {
         make.left.mas_equalTo(QZHKIT_MARGIN_LEFT_LISTCELL_IMAGE);
         make.centerY.mas_equalTo(self.contentView);
         make.width.mas_equalTo(24);
         make.height.mas_equalTo(24);

     }];
    [self.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
         make.centerY.mas_equalTo(self.contentView);
        make.left.mas_equalTo(self.IMGView.mas_right).offset(QZHKIT_MARGIN_H_LISTCELL_IMAGE_AND_TEXT);
     }];
    [self.tagLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView);
        make.right.mas_equalTo(self.forward.mas_left).offset(-5);
    }];
    [self.forward mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.centerY.mas_equalTo(self.contentView);
        make.width.height.mas_equalTo(20);
    }];
    
}
#pragma mark -lazy
-(UIView *)bigView{
    if (!_bigView) {
        _bigView = [[UIView alloc] init];
        _bigView.backgroundColor = QZHColorWhite;
    }
    return _bigView;
}
-(UILabel *)nameLab{
    if (!_nameLab) {
        _nameLab = [[UILabel alloc] init];
        _nameLab.font = QZHKIT_FONT_LISTCELL_MAIN_TITLE;
        _nameLab.textColor = QZHKIT_Color_BLACK_87;
    }
    return  _nameLab;
}

-(UIImageView *)IMGView{
    if (!_IMGView) {
        _IMGView = [[UIImageView alloc] init];
    }
    return _IMGView;
}
-(UILabel *)tagLab{
    if (!_tagLab) {
        _tagLab = [[UILabel alloc] init];
        _tagLab.font = QZHKIT_FONT_LISTCELL_TIME_TITLE;
        _tagLab.textColor = QZHKIT_Color_BLACK_26;
    }
    return  _tagLab;
}
- (UIImageView *)forward{
    if (!_forward) {
        _forward = [[UIImageView alloc] init];
        _forward.image = [UIImage imageNamed:@"forward_icon"];

    }
    return _forward;
}

- (void)setFrame:(CGRect)frame {

    frame.size.height -= QZHSIZE_HEIGHT_LISTCELL_SEPARATOR;
    [super setFrame:frame];
}



@end
