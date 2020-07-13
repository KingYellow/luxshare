//
//  UIView+Exp.h
//  Creditgo
//
//  Created by 米翊米 on 2018/7/17.
//  Copyright © 2018年 米翊米. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Exp)

///圆角阴影
- (void)exp_shadowColor:(UIColor *)color shadowOffset:(CGSize)offset shadowOpacity:(CGFloat)opacity shadowRadius:(CGFloat)radius cornerRadius:(CGFloat)cornerRadius;

///设置边框线
- (void)exp_boderColor:(UIColor *)color boderWidth:(CGFloat)width;

///设置边框线
- (void)exp_viewRadius:(CGFloat)radius;

@end
