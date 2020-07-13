//
//  NewFeatureCell.m
//  DDSample
//
//  Created by 黄振 on 2020/4/3.
//  Copyright © 2020 KingYellow. All rights reserved.
//

#import "NewFeatureCell.h"

@implementation NewFeatureCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self)
    {
        [self creatSubviews];
    }
    return self;
}
- (void)creatSubviews{
    [self.contentView addSubview:self.IMGView];
    [self.contentView addSubview:self.enterBtn];
    
    [self.IMGView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    [self.enterBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView);
        make.bottom.mas_equalTo(-QZHHeightTabbar - 100);
        make.height.mas_equalTo(44);
        make.width.mas_equalTo(200);
    }];
  
}

- (UIImageView *)IMGView{
    if (!_IMGView) {
        _IMGView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _IMGView;
}
-(UIButton *)enterBtn{
    if (!_enterBtn) {
        _enterBtn = [[UIButton alloc] init];
        [_enterBtn setTitle:@"开启" forState:UIControlStateNormal];
        [_enterBtn setTitleColor:QZHColorWhite forState:(UIControlStateNormal)];
        _enterBtn .backgroundColor = QZHKIT_COLOR_SKIN;
        QZHViewRadius(_enterBtn, 4);
    }
    return _enterBtn;
}
@end
