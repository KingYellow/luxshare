//
//  TYModuleTabBarStyleProtocol.h
//  TYModuleManager
//
//  Created by TuyaInc on 2018/9/4.
//

#import <Foundation/Foundation.h>

@class TYTabItemAttribute;

@protocol TYModuleTabBarStyleProtocol <NSObject>

@optional
- (void)tabBarDidLoad;

- (Class)tabBarModuleForDefaultSelected;

- (NSDictionary<NSAttributedStringKey, id> *)tabBarItemTitleAttributesForState:(UIControlState)state withNativeResult:(NSDictionary<NSAttributedStringKey, id> *)nativeResult;

- (void)tabBarWillLoadModule:(Class)moduleCls withAttributes:(NSMutableArray<TYTabItemAttribute *> *)attrArr;

/**
 @return 事件是否继续向原生代码实现传递
 */
- (BOOL)tabBarWillAdd:(nullable UIViewController *)controller withItemAttribute:(nonnull TYTabItemAttribute *)attribute;

/**
 item是否允许被选中
 该方法仅在defaultSelect无效时回调
 如果实现此方法
 请 不要 在此回调中处理业务逻辑
 请 务必仅返回 YES/NO
 style中此方法优先级高于native
 */
- (BOOL)tabBarCanSelect:(nullable UIViewController *)controller withItemAttribute:(TYTabItemAttribute *)attribute nativeResult:(BOOL)nativeResult;

/**
 用户点击tab后，是否允许展示对应vc
 */
- (BOOL)tabBarShouldShow:(nullable UIViewController *)controller withItemAttribute:(TYTabItemAttribute *)attribute nativeResult:(BOOL)nativeResult;

/**
 @return 事件是否继续向原生代码实现传递
 */
- (BOOL)tabBarDidSelect:(nullable UIViewController *)controller withItemAttribute:(TYTabItemAttribute *)attribute;

/**
 @return 事件是否继续向原生代码实现传递
 */
- (BOOL)tabBarDidUnselect:(nullable UIViewController *)controller withItemAttribute:(TYTabItemAttribute *)attribute;

/**
 是否允许设置badge
 */
- (BOOL)tabBarShouldSetBadge:(nullable NSString *)badge withItemAttribute:(TYTabItemAttribute *)attribute nativeResult:(BOOL)nativeResult;

@end
