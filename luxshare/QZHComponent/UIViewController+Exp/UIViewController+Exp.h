//
//  UIViewController+Exp.h
//  DDSample
//
//  Created by 黄振 on 2020/3/30.
//  Copyright © 2020 KingYellow. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface UIViewController (Exp) <UINavigationControllerDelegate, UIGestureRecognizerDelegate>

/**
 设置透明导航栏
 */
- (void)exp_navigationBarTrans;

/**
 设置导航栏颜色
 
 @param color 颜色
 @param show 是否隐藏阴影
 */
- (void)exp_navigationBarColor:(UIColor *)color hiddenShadow:(BOOL)show;

/**
 设置导航栏文字颜色、字体大小
 
 @param color 颜色
 @param font 字体大小
 */
- (void)exp_navigationBarTextWithColor:(UIColor *)color font:(UIFont *)font;

/**
 隐藏导航
 */
- (void)exp_navigationBarShadowHidden:(BOOL)hidden;

/**
 添加导航栏
 
 @return UINavigationController
 */
- (UIViewController *)exp_addNavigation;

/**
 隐藏底部栏
 
 @return vc
 */
- (UIViewController *)exp_hiddenTabBar;

/**
 添加左边item

 @return 左边按钮
 */

- (UIButton *)exp_addLeftItemTitle:(NSString *)title itemIcon:(NSString *)icon;

/**
 添加右边按钮

 @return 右边按钮
 */
- (UIButton *)exp_addRightItemTitle:(NSString *)title itemIcon:(NSString *)icon ;

/**
 左边触发事件
 */
- (void)exp_leftAction;

/**
 右边触发事件
 */
- (void)exp_rightAction;

///状态栏颜色
- (void)exp_statusBarStyle:(UIBarStyle)barStyle;

/// 下拉刷新
- (void)refreshHandler;

/// 上拉加载
- (void)loadMoreHandler;

@end

NS_ASSUME_NONNULL_END
