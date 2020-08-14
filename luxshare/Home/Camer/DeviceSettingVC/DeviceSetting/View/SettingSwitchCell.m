//
//  SettingSwitchCell.m
//  luxshare
//
//  Created by 黄振 on 2020/7/10.
//  Copyright © 2020 KingYellow. All rights reserved.
//

#import "SettingSwitchCell.h"

@implementation SettingSwitchCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {

        [self creatSubViews];
        self.contentView.backgroundColor = QZHKIT_COLOR_LEADBACK;
    }
    return self;
}

- (void)creatSubViews {
    [self.contentView addSubview:self.bigView];
    [self.contentView addSubview:self.switchBtn];
    [self.contentView addSubview:self.nameLab];
    [self.bigView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 10, 0, 10));
    }];
     
     [self.switchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
         make.centerY.mas_equalTo(self.contentView);
         make.right.mas_equalTo(-30);

     }];
    [self.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
         make.centerY.mas_equalTo(self.contentView);
        make.left.mas_equalTo(30);
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

-(UISwitch *)switchBtn{
    if (!_switchBtn) {
        _switchBtn = [[UISwitch alloc] init];
        _switchBtn.selected = NO;
    }
    return _switchBtn;
}

-(UIView *)bigView{
    if (!_bigView) {
        _bigView = [[UIView alloc] init];
        _bigView.backgroundColor = QZH_KIT_Color_WHITE_100;
    }
    return _bigView;
}
-(void)setRadioPosition:(NSInteger)radioPosition{
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
