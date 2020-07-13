//
//  UIButton+Image.h
//  MobileCustomerService
//
//  Created by 米翊米 on 2017/8/29.
//  Copyright © 2017年 🐨🐨🐨. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 按钮是否可操作
 
 - QZHButtonStateEnable: 可操作
 - QZHButtonStateDisEnable: 不可操作
 */
typedef NS_ENUM(NSInteger, QZHButtonState) {
    QZHButtonStateEnable,
    QZHButtonStateDisEnable,
};

@interface UIButton (Image)

///加载本地图片
- (void)exp_loadImage:(NSString *)defaultString;

///加载网络图片
- (void)exp_loadImageUrlString:(NSString *)urlString placeholder:(NSString *)placeholder;

///加载网络图片剪裁大小
- (void)exp_loadImageUrlString:(NSString *)urlString placeholder:(NSString *)placeholder size:(CGSize)size;

///加载网络背景图片
- (void)exp_loadBackImageUrlString:(NSString *)urlString placeholder:(NSString *)placeholder;

/// 按钮状态变更
- (void)exp_buttonState:(QZHButtonState)state;

@end
