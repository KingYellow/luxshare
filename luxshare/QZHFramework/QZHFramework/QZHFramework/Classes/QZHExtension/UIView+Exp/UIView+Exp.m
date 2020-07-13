//
//  UIView+Exp.m
//  Creditgo
//
//  Created by 米翊米 on 2018/7/17.
//  Copyright © 2018年 米翊米. All rights reserved.
//

#import "UIView+Exp.h"

@implementation UIView (Exp)

///圆角阴影
- (void)exp_shadowColor:(UIColor *)color shadowOffset:(CGSize)offset shadowOpacity:(CGFloat)opacity shadowRadius:(CGFloat)radius cornerRadius:(CGFloat)cornerRadius {
    self.layer.shadowColor = color.CGColor;
    self.layer.shadowOffset = offset;
    self.layer.shadowOpacity = opacity;
    self.layer.shadowRadius = radius;
    if (cornerRadius > 0) {
        self.layer.cornerRadius = cornerRadius;
    }
}

///设置边框线
- (void)exp_boderColor:(UIColor *)color boderWidth:(CGFloat)width {
    self.layer.borderColor = color.CGColor;
    self.layer.borderWidth = width;
}

///设置边框线
- (void)exp_viewRadius:(CGFloat)radius {
    self.layer.cornerRadius = radius;
    self.layer.masksToBounds = YES;
}

@end
