//
//  TYTabBarControllerDelegate.h
//  TYModuleTabbar
//
//  Created by TuyaInc on 2018/8/23.
//

#import <Foundation/Foundation.h>

@protocol TYTabBarControllerDelegate <NSObject>

@optional

- (NSUInteger)ty_defaultTabIndex;

/**
 设置tabItem上title的样式
 */
- (NSDictionary<NSAttributedStringKey,id> *)ty_tabItemTitleTextAttributesForState:(UIControlState)state;

/**
 将要添加到tabbar
 */
- (void)ty_tabBar:(UITabBarController<TYTabBarControllerProtocol> *)tabController willAdd:(UIViewController *)childController withItemAttribute:(TYTabItemAttribute *)attr;

/**
 item是否允许被选中
 该方法仅在defaultSelect无效时回调
 如果实现此方法
 请 不要 在此回调中处理业务逻辑
 请 务必仅返回 YES/NO
 默认根据TYTabItemAttribute.viewController判断
 */
- (BOOL)ty_tabBar:(UITabBarController<TYTabBarControllerProtocol> *)tabController childControllerCanBeSelected:(__kindof UIViewController *)childController withItemAttribute:(TYTabItemAttribute *)attr;

/**
 用户点击tab后，是否允许展示对应vc
 */
- (BOOL)ty_tabBar:(UITabBarController<TYTabBarControllerProtocol> *)controller shouldShow:(UIViewController *)childController withItemAttribute:(TYTabItemAttribute *)attr;

/**
 选中
 */
- (void)ty_tabBar:(UITabBarController<TYTabBarControllerProtocol> *)tabController didSelect:(UIViewController *)childController withItemAttribute:(TYTabItemAttribute *)attr;
/**
 取消选中
 */
- (void)ty_tabBar:(UITabBarController<TYTabBarControllerProtocol> *)tabController didUnselect:(UIViewController *)childController withItemAttribute:(TYTabItemAttribute *)attr;

/**
 设置badge
 */
- (BOOL)ty_tabBar:(UITabBarController<TYTabBarControllerProtocol> *)tabController shouldSetBadge:(NSString *)value withViewController:(UIViewController *)childController itemAttribute:(TYTabItemAttribute *)attr;


@end
