//
//  QZHHUD.h
//  MobileCustomerService
//
//  Created by 黄振 on 2017/9/5.
//  Copyright © 2017年 🐨🐨🐨. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^HudFinished)(void);

@interface QZHHUD : NSObject

/**
 提示语完成回调
 */
@property (nonatomic, strong)HudFinished QZHHUDFinish;

/**
 单例
 
 @return QZHHUD实例
 */
+ (QZHHUD *)HUD;

@property (nonatomic, assign) CGPoint offset;

@property (nonatomic, strong) UIColor *textColor;

#pragma makr - 加载提示HUD

/**
 加载中HUD，使用系统activity
 */
- (void)loadingHUD;

/**
 加载中HUD
 
 @param imageNamed 自定义加载中图片
 */
//- (void)loadingHUDWithImage:(NSString *)imageNamed;

/**
 加载中HUD
 
 @param message 使用系统activity并显示的文字
 */
- (void)loadingHUDWithMessage:(NSString *)message;

/**
 加载中HUD
 
 @param imageNamed 自定义图片
 @param message 同时显示的文字
 */
//- (void)loadingHUDWithImage:(NSString *)imageNamed message:(NSString *)message;

#pragma mark - 文字提示信息HUD

/**
 纯文字提示HUD
 
 @param message 自定义文字提示
 */
- (QZHHUD *)textHUDWithMessage:(NSString *)message afterDelay:(NSTimeInterval)delay;

/**
 activity与文字提示HUD
 
 @param message 自定义文字提示
 
 @param delay 显示时间

 */
- (QZHHUD *)textActivityWithMessage:(NSString *)message afterDelay:(NSTimeInterval)delay;

/**
 文字图片提示HUD
 
 @param imageNamed 自定义图片
 @param message 提示文字
 */
- (QZHHUD *)textHUDWithImage:(NSString *)imageNamed message:(NSString *)message afterDelay:(NSTimeInterval)delay;

/**
 隐藏hud
 */
- (void)hiddenHUD;

/**
 隐藏hud
 */
- (void)forceHiddenHUD;

@end
