//
//  UIImage+ScaleExp.h
//  DDSample
//
//  Created by 黄振 on 2020/4/13.
//  Copyright © 2020 KingYellow. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (ScaleExp)
/// 图片压缩
/// @param sourceImage image
/// @param maxLength 压缩最大值 (K)  = 0时 默认仿微信压缩系数0.5
+ (UIImage *)exp_imageScaleWithImage:(UIImage *)sourceImage toByte:(NSInteger)maxLength;


/// 存储图片到本地
/// @param image 要存储的图片
/// @param name 保存路径图片名字
+ (void)exp_saveImageToLocal:(UIImage *)image path:(NSString *)name;


/// 读取本地图片
/// @param name 图片路径名字
+ (UIImage *)exp_readImageWithPath:(NSString *)name;
@end

NS_ASSUME_NONNULL_END
