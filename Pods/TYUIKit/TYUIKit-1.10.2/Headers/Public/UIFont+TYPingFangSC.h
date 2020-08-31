//
//  UIFont+TYPingFangSC.h
//  TYUIKit
//
//  Created by TuyaInc on 2019/1/16.
//
//  [DOC_IGNORE_FILE]

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIFont (TYPingFangSC)

+ (UIFont *)ty_pingFangSCRegular:(CGFloat)size __deprecated_msg("Use SystemFont instead");
+ (UIFont *)ty_pingFangSCSemibold:(CGFloat)size __deprecated_msg("Use SystemFont instead");
+ (UIFont *)ty_pingFangSCThin:(CGFloat)size __deprecated_msg("Use SystemFont instead");
+ (UIFont *)ty_pingFangSCLight:(CGFloat)size __deprecated_msg("Use SystemFont instead");
+ (UIFont *)ty_pingFangSCMedium:(CGFloat)size __deprecated_msg("Use SystemFont instead");
+ (UIFont *)ty_pingFangSCUltralight:(CGFloat)size __deprecated_msg("Use SystemFont instead");

@end

NS_ASSUME_NONNULL_END
