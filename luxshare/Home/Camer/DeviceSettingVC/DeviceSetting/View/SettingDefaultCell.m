//
//  SettingDefaultCell.m
//  luxshare
//
//  Created by 黄振 on 2020/7/10.
//  Copyright © 2020 KingYellow. All rights reserved.
//

#import "SettingDefaultCell.h"

@implementation SettingDefaultCell

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
    [self.bigView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 10, 0, 10));
    }];
     
     [self.IMGView mas_makeConstraints:^(MASConstraintMaker *make) {
         make.top.mas_equalTo(15);
         make.width.mas_equalTo(20);
         make.right.mas_equalTo(-30);
         make.bottom.mas_equalTo(-15);

     }];
    [self.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30);
        make.bottom.mas_equalTo(0);
        make.top.mas_equalTo(0);
     }];
    [self.tagLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(self.nameLab.mas_right).offset(10);
        make.right.mas_equalTo(self.IMGView.mas_left).offset(-10);
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

- (UIImageView *)IMGView{
    if (!_IMGView) {
        _IMGView = [[UIImageView alloc] init];
        _IMGView.contentMode = UIViewContentModeScaleToFill;
        _IMGView.image = [UIImage imageNamed:@"forward_icon"];
    }
    return _IMGView;
}
- (UILabel *)tagLab{
    if (!_tagLab) {
        _tagLab = [[UILabel alloc] init];
        _tagLab.font = QZHKIT_FONT_LISTCELL_TIME_TITLE;
        _tagLab.textColor = QZHKIT_Color_BLACK_26;
        _tagLab.textAlignment = NSTextAlignmentRight;
    }
    return  _tagLab;
}
- (UIView *)bigView{
    if (!_bigView) {
        _bigView = [[UIView alloc] init];
        _bigView.backgroundColor = QZH_KIT_Color_WHITE_100;
    }
    return _bigView;
}
- (void)setRadioPosition:(NSInteger)radioPosition{
    if (radioPosition == -1) {
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, QZHScreenWidth - 20, 50)
         byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(10, 10)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = CGRectMake(0, 0, QZHScreenWidth - 20, 50);
        maskLayer.path = maskPath.CGPath;
        [self.bigView.layer.mask removeFromSuperlayer];
        self.bigView.layer.mask = maskLayer;
        
    }else if(radioPosition == 1){
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, QZHScreenWidth - 20, 50)
         byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(10, 10)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = CGRectMake(0, 0, QZHScreenWidth - 20, 50);
        maskLayer.path = maskPath.CGPath;
        [self.bigView.layer.mask removeFromSuperlayer];
        self.bigView.layer.mask = maskLayer;
    }else if(radioPosition == 2){
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, QZHScreenWidth - 20, 50)
           byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(10, 10)];
      CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
      maskLayer.frame = CGRectMake(0, 0, QZHScreenWidth - 20, 50);
      maskLayer.path = maskPath.CGPath;
        [self.bigView.layer.mask removeFromSuperlayer];
      self.bigView.layer.mask = maskLayer;
    }else{
        [self.bigView.layer.mask removeFromSuperlayer];
    }
}
@end
