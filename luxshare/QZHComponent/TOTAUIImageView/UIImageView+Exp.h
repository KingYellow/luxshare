//
//  UIImageView+Exp.h
//  DDSample
//
//  Created by 黄振 on 2020/4/15.
//  Copyright © 2020 KingYellow. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImageView (Exp)

/// 加载图片
/// @param urlString 图片地址链接
/// @param placeholder 站位图片
- (void)exp_loadImageUrlString:(NSString *)urlString placeholder:(NSString *)placeholder;

@end

NS_ASSUME_NONNULL_END
