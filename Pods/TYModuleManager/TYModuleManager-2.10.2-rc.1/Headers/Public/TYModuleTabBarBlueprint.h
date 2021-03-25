//
//  TYModuleTabBarBlueprint.h
//  TYModuleManager
//
//  Created by TuyaInc on 2018/9/3.
//

#import <Foundation/Foundation.h>

@class TYTabItemAttribute;

NS_ASSUME_NONNULL_BEGIN

@protocol TYModuleTabBarBlueprint <NSObject>

@property (nonatomic, strong, nullable) NSArray<TYTabItemAttribute *> *tabItemAttributes;
@property (nonatomic, strong) Class defaultSelectModule;

@property (nonatomic, strong, nullable) UIColor *titleColorForNormal;
@property (nonatomic, strong, nullable) UIColor *titleColorForSelect;

- (__kindof UITabBarController *)tabBarController;
- (__kindof UITabBar *)tabBar;

- (NSUInteger)indexOfModule:(Class)moduleCls tag:(nullable NSString *)tag;
- (UIViewController *)viewControllerOfModule:(Class)moduleCls;

- (void)clearTabs;
- (void)reloadTabItemAttributesIfNil;

- (void)reloadTabs;
- (void)reloadTabsWithSelectIndex:(NSUInteger)index;
- (void)reloadTabsWithSelectModule:(nullable Class)moduleCls;
- (void)reloadTabsWithSelectModule:(nullable Class)moduleCls tag:(nullable NSString *)tag;

- (void)showTabWithIndex:(NSUInteger)index;
- (void)showTabWithModule:(Class)moduleCls;
- (void)showTabWithModule:(Class)moduleCls tag:(nullable NSString *)tag;

- (void)setBadgeForIndex:(NSUInteger)index badge:(nullable NSString *)badge;
- (void)setBadgeForModule:(Class)moduleCls badge:(nullable NSString *)badge;
- (void)setBadgeForModule:(Class)moduleCls tag:(nullable NSString *)tag badge:(nullable NSString *)badge;
- (void)cleanAllBadge;

// 设置tab的分割线，nil则使用系统默认，[UIImage new]则去除分割线
- (void)setTabSeparatorImage:(UIImage *)image;

// 设置tab的背景
- (void)setTabBackgroundColor:(UIColor *)color;
- (void)setTabBackgroundImage:(UIImage *)image;

// 获取系统的TabBarButton
- (__kindof UIControl *)systemTabButtonForIndex:(NSUInteger)idx;
- (__kindof UIControl *)systemTabButtonForModule:(Class)moduleCls;
- (__kindof UIControl *)systemTabButtonForModule:(Class)moduleCls tag:(nullable NSString *)tag;

// 获取自定义的TabBarButton
- (__kindof UIControl *)customTabButtonForIndex:(NSUInteger)idx;
- (__kindof UIControl *)customTabButtonForModule:(Class)moduleCls;
- (__kindof UIControl *)customTabButtonForModule:(Class)moduleCls tag:(nullable NSString *)tag;

@end

NS_ASSUME_NONNULL_END
