//
//  UIImage+Exp.h
//  Creditgo
//
//  Created by 米翊米 on 2018/9/6.
//  Copyright © 2018年 米翊米. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Exp)

///相机拍摄旋转90°c问题
- (UIImage *)fixOrientation;

///剪裁圆形图片
- (UIImage *)exp_ovalClip;

///限制图片大小
- (UIImage *)exp_compressImageSizeToByte:(NSUInteger)maxLength;

///指定图片尺寸
- (UIImage *)exp_scaleToSize:(CGSize)size;

@end
