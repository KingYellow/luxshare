//
//  UIButton+TYFactory.h
//  TYUIKit
//
//  Created by TuyaInc on 2019/5/14.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (TYFactory)

+ (instancetype)ty_buttonWithFont:(UIFont * _Nullable)font textColor:(UIColor * _Nullable)textColor;
+ (instancetype)ty_buttonWithFont:(UIFont * _Nullable)font textColor:(UIColor * _Nullable)textColor backgroundColor:(UIColor * _Nullable)backgroundColor;
+ (instancetype)ty_buttonWithFont:(UIFont * _Nullable)font textColor:(UIColor * _Nullable)textColor backgroundColor:(UIColor * _Nullable)backgroundColor frame:(CGRect)frame;

@end

NS_ASSUME_NONNULL_END
