//
//  UIColor+Grade.h
//  fengbird
//
//  Created by 黄振 on 2019/2/27.
//  Copyright © 2019年 KingYellow. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (Grade)
//渐变色
+ (UIColor*)jk_gradientFromColor:(UIColor*)c1 toColor:(UIColor*)c2 withWidth:(int)width;
@end

NS_ASSUME_NONNULL_END
