//
//  UIImage+ScaleExp.m
//  DDSample
//
//  Created by 黄振 on 2020/4/13.
//  Copyright © 2020 KingYellow. All rights reserved.
//

//高均 <= 1280，图片尺寸大小保持不变
//宽或高 > 1280 && 宽高比 <= 2，取较大值等于1280，较小值等比例压缩
//宽或高 > 1280 && 宽高比 > 2, && 宽或高 < 1280，图片尺寸大小保持不变
//宽高均 > 1280 && 宽高比 > 2，取较小值等于800，较大值等比例压缩

//
//注：当宽和高均大于1280，并且宽高比大于2时，微信聊天会话和微信朋友圈的处理不一样。
//朋友圈：取较小值等于1280，较大值等比例压缩
//聊天会话：取较小值等于800，较大值等比例压缩

#import "UIImage+ScaleExp.h"

@implementation UIImage (ScaleExp)

/// 压缩图片  大小和尺寸
/// @param sourceImage image
/// @param maxLength 压缩最大值 (K)  = 0时 默认仿微信压缩系数0.5
+ (UIImage *)exp_imageScaleWithImage:(UIImage *)sourceImage toByte:(NSInteger)maxLength{

    //进行图像尺寸的压缩
    CGSize imageSize = sourceImage.size;//取出要压缩的image尺寸
    CGFloat width = imageSize.width;    //图片宽度
    CGFloat height = imageSize.height;  //图片高度
    NSLog(@"原来图片尺寸大小width=%f height=%f",width,height);
    if (maxLength == -1) {
        width = width*3;
        height = height *3;
        UIGraphicsBeginImageContext(CGSizeMake(width, height));
        [sourceImage drawInRect:CGRectMake(0,0,width,height)];
        UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return newImage;
    }

    if (width <= 1280 && height <= 1280) {
        
    }else if(width > height){
        if (width <= height * 2) {
            //宽或高 > 1280 && 宽高比 <= 2，取较大值等于1280，较小值等比例压缩
            CGFloat scale = height/width;
            width = 1280;
            height = width * scale;
        }else{
            if (height < 1280) {
                //保持不变
            }else{
                //宽高均 > 1280 && 宽高比 > 2，取较小值等于800，较大值等比例压缩
                CGFloat scale = width/height;
                height = 800;
                width = height * scale;
            }
        }
    }else{
        if (height <= width * 2) {
            CGFloat scale = width/height;
            height = 1280;
            width = height * scale;
        }else{
            if (width < 1280) {
                //保持不变
            }else{
                CGFloat scale = height/width;
                width = 800;
                height = width * scale;
            }
        }
    }
    NSLog(@"裁剪压缩后图片尺寸大小width=%f height=%f",width,height);

    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    [sourceImage drawInRect:CGRectMake(0,0,width,height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    //进行图像的画面质量压缩
    return [UIImage compressImageQuality:newImage toByte:maxLength * 1024.0];
}

/// 二分法压缩图片,减少循环次数多，效率高，耗时短
/// @param image image
/// @param maxLength 最大值
+ (UIImage *)compressImageQuality:(UIImage *)image toByte:(NSInteger)maxLength {
    NSData *beforeData = UIImageJPEGRepresentation(image, 1);
    NSLog(@"before质量压缩前大小 %lf",beforeData.length/1024.0);
    if (maxLength == 0) {
        //=0时 默认仿微信压缩系数0.5
        NSData *data = UIImageJPEGRepresentation(image, 0.5);
        NSLog(@"after质量压缩后大小 %lf",data.length/1024.0);
        return [UIImage imageWithData:data];
    }else{
        CGFloat compression = 1;
        NSData *data = UIImageJPEGRepresentation(image, compression);
        if (data.length < maxLength){
            return image;
        }
        CGFloat max = 1;
        CGFloat min = 0;
        for (int i = 0; i < 6; ++i) {
            compression = (max + min) / 2;
            data = UIImageJPEGRepresentation(image, compression);
            if (data.length < maxLength * 0.9) {
                min = compression;
            } else if (data.length > maxLength) {
                max = compression;
            } else {
                break;
            }
        }
        NSLog(@"after质量压缩后大小 %lf",data.length/1024.0);
        UIImage *resultImage = [UIImage imageWithData:data];
        return resultImage;
    }
}

+ (void)exp_saveImageToLocal:(UIImage *)image path:(NSString *)name{
    NSArray *paths =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    
    NSString *filePath = [[paths objectAtIndex:0]stringByAppendingPathComponent:
                          [NSString stringWithFormat:@"%@.png",name]];  // 保存文件的名称
    BOOL result =[UIImagePNGRepresentation(image)writeToFile:filePath   atomically:YES]; // 保存成功会返回YES
    if (result == YES) {
        NSLog(@"保存成功%@",filePath);
    }
}

+ (UIImage *)exp_readImageWithPath:(NSString *)name{
    NSArray *paths =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    
    NSString *filePath = [[paths objectAtIndex:0]stringByAppendingPathComponent:
                          [NSString stringWithFormat:@"%@.png",name]];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    return [UIImage imageWithData:data];
}
@end
