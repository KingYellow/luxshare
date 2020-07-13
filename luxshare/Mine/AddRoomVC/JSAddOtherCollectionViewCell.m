//
//  JSAddOtherCollectionViewCell.m
//  MelonBaseProject
//
//  Created by 氧车乐 on 2020/4/7.
//  Copyright © 2020 Melon. All rights reserved.
//

#import "JSAddOtherCollectionViewCell.h"
#import "Masonry.h"
@implementation JSAddOtherCollectionViewCell


- (instancetype)init{
    abort();
}
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self) {
 
        [self setup];
    }
    
    return self;
}

- (void)setup{
    
    _setView = [UIView new];
    _setView.backgroundColor = QZHKIT_COLOR_LEADBACK;
    [self.contentView addSubview:_setView];
    
    _titleLabel = [UILabel new];
    _titleLabel.font = [UIFont boldSystemFontOfSize:18];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.textColor = QZHKIT_Color_BLACK_87;
    _titleLabel.backgroundColor = QZH_KIT_Color_WHITE_70;
    QZHViewRadius(_titleLabel, 22.5);
    _titleLabel.layer.borderWidth = 1.0;
    _titleLabel.layer.borderColor = QZHKIT_Color_BLACK_87.CGColor;
    [_setView addSubview:_titleLabel];
    
}


#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wimplicit-retain-self"
- (void)updateConstraints{
    
    [_setView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.contentView);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.centerY.equalTo(_setView);
        make.right.mas_equalTo(0);
        make.height.mas_offset(45);
    }];
    
    [super updateConstraints];
}
#pragma clang diagnostic pop

- (void)didMoveToSuperview{
    [self setNeedsUpdateConstraints];
}
@end

