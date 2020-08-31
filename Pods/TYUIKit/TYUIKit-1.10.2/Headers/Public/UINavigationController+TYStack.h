//
//  UINavigationController+TYStack.h
//  TYUIKit
//
//  Created by TuyaInc on 2019/10/28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UINavigationController (TYStack)

/**
 [^zh]在视图栈中查找指定类的实例，优先匹配isMemberOf，再匹配isKindOf，未找到则返回nil[$zh]
 [^en]Looks for an instance of the vc class in the view controller stack, first matching isMemberOf, then matching isKindOf[$en]
 */
- (__kindof UIViewController * __nullable)ty_viewControllerWithKindOfClass:(Class)vcClass;

/**
 @return [^zh]若视图栈中存在该类型示例，则返回YES[$zh] [^en]return NO if -ty_viewControllerWithKindOfClass return nil[$en]
 */
- (BOOL)ty_canPopToViewControllerWithKindOfClass:(Class)vcClass;

/**
 [^zh]弹出到指定的控制器[$zh]
 [^en]pop to specified kind of view controller[$en]
 @return [^zh]弹出的视图[$zh] [^en]popped view controllers[$en]
 */
- (NSArray<__kindof UIViewController *> * __nullable)ty_popToViewControllerWithKindOfClass:(Class)vcClass animated:(BOOL)animated;


#pragma mark - Deprecated
- (BOOL)ty_canPopToSpecificViewController:(Class)vcClass __deprecated_msg("Use -ty_canPopToViewControllerWithKindOfClass: instead");
- (void)ty_popToSpecificViewController:(Class)vcClass animated:(BOOL)animated __deprecated_msg("Use -ty_popToViewControllerWithKindOfClass:animated: instead");

@end

NS_ASSUME_NONNULL_END
