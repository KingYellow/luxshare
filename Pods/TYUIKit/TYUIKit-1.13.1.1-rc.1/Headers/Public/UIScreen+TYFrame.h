//
//  UIScreen+TYFrame.h
//  TYUIKit
//
//  Created by TuyaInc on 2018/12/20.
//

#import <UIKit/UIKit.h>

#pragma mark - NotchScreen
/**
 @return iPhone with Notch Screen ? Like iPhoneX
 */
UIKIT_EXTERN BOOL TY_IsNotchScreen(void);

#pragma mark - ScreenSize
/**
 @return [UIScreen mainScreen].bounds
 */
UIKIT_EXTERN CGRect TY_ScreenBounds(void);
/**
 @return [UIScreen mainScreen].bounds.size.width
 */
UIKIT_EXTERN CGFloat TY_ScreenWidth(void);
/**
 @return [UIScreen mainScreen].bounds.size.height
 */
UIKIT_EXTERN CGFloat TY_ScreenHeight(void);

#pragma mark - SareArea
/**
 @return [UIApplication sharedApplication].keyWindow.safeAreaInsets
 */
UIKIT_EXTERN UIEdgeInsets TY_ScreenSafeInsets(void);
/**
 @return [UIApplication sharedApplication].keyWindow.safeAreaInsets.top
 */
UIKIT_EXTERN CGFloat TY_ScreenSafeTop(void);
/**
 @return [UIApplication sharedApplication].keyWindow.safeAreaInsets.bottom
 */
UIKIT_EXTERN CGFloat TY_ScreenSafeBottom(void);

#pragma mark - NaviBarHeight / StatusBarHeight / TabBarHeight

/**
 [^zh]
 如果需要获取控制器顶部的安全高度，建议使用 vc.ty_safeTop 实时获取
 [$zh]
 [^en]
 if you want to get the top of the view controller safe area insets, vc.ty_safeTop will be better
 [$en]
 @return [^zh]固定返回 屏幕顶部安全高度+44[^zh] [^en]top of window safe area insets plus 44[$en]
 */
UIKIT_EXTERN CGFloat TY_NaviBarHeight(void);
UIKIT_EXTERN CGFloat TY_StatusBarHeight(void);
UIKIT_EXTERN CGFloat TY_TabBarHeight(void);

#pragma mark - ScreenAdaption

/// [^zh]适配屏幕，标准375.0[$zh] [^en]adaption to screen, standard is 375.0[$en]
UIKIT_EXTERN CGFloat TY_ScreenAdaptionLength(CGFloat length);
/// [^zh]适配屏幕，标准375.0[$zh] [^en]adaption to screen, standard is 375.0[$en]
UIKIT_EXTERN CGPoint TY_ScreenAdaptionPoint(CGPoint point);
/// [^zh]适配屏幕，标准375.0[$zh] [^en]adaption to screen, standard is 375.0[$en]
UIKIT_EXTERN CGSize TY_ScreenAdaptionSize(CGSize size);
/// [^zh]适配屏幕，标准375.0[$zh] [^en]adaption to screen, standard is 375.0[$en]
UIKIT_EXTERN CGRect TY_ScreenAdaptionRect(CGRect rect);
