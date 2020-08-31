//
//  UIViewController+TYSafeInsets.h
//  TYUIKit
//
//  Created by TuyaInc
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (TYSafeInsets)

/**
 [^zh]
 当前页面的顶部安全高度
 FullScreen模式下：有导航栏则返回导航栏底部位置，否则返回状态栏底部位置
 PageSheet模式下：有导航栏则返回导航栏底部位置，否则返回0
 [$zh]
 [^en]
 Safe height at the top of the current page
 FullScreen modal: if there is a navigation bar, return the bottom position of the navigation bar, otherwise return the bottom position of the status bar
 PageSheet modal: if there is a navigation bar, return the bottom position of the navigation bar, otherwise return 0
 [$en]
 */
@property (nonatomic, readonly) CGFloat ty_safeTop;


@end

NS_ASSUME_NONNULL_END
