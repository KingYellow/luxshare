//
//  TYViewControllerTopBarProtocol.h
//  TYNavigationController
//
//  Created by TuyaInc on 2018/11/21.
//

#import <Foundation/Foundation.h>

#import "TYNavigationBarItem.h"
#import "TYNavigationTypeDefine.h"

/**
 zh^
 所有以 ty_topBar 开头的属性 均表示 仅对当前页面产生影响，对后续push出来的页面的navi 无影响
 get方法只返回设置值，如果没有设置过，则没有返回值
 如果需要获取默认值等其它途径的值，使用<TYNavigationPresentProtocol>中的ty_naviPresentxxx代替
 !!! 请不要重写属性的Accessor方法，否则将导致数据不准确
 zh$
 
 en^
 ty_topBar means this method/property only effect on current view controller
 getter only return the value that you set, it will be nil if you didn't set
 if you want to get something such as default value, use ty_naviPresentxxx in <TYNavigationPresentProtocol> insted
 !!! Don't override any accessor method
 en$
 */
@protocol TYNavigationTopBarProtocol <NSObject>

#pragma mark - NaviItem
@property (nonatomic) BOOL ty_topBarEnableBackItem;     /**< 是否使用back/cancel按钮  影响：当前页面 */
@property (nonatomic, strong) TYNavigationBarItem *ty_topBarBackItem;   /**< back/cancel按钮样式  影响：当前页面 */
@property (nonatomic, strong) TYNavigationBarItem *ty_topBarLeftItem;   /**< left样式  影响：当前页面 */
@property (nonatomic, strong) TYNavigationBarItem *ty_topBarCenterItem; /**< center样式  影响：当前页面 */
@property (nonatomic, strong) TYNavigationBarItem *ty_topBarRightItem;  /**< right样式  影响：当前页面 */

/**
 layout from left to right
 Available After TuyaSmart 3.9.0+
 */
@property (nonatomic, strong) NSArray<TYNavigationBarItem *> *ty_topBarLeftItems;

/**
 layout from left to right
 Available After TuyaSmart 3.9.0+
 */
@property (nonatomic, strong) NSArray<TYNavigationBarItem *> *ty_topBarRightItems;

#pragma mark - NaviStyle
@property (nonatomic) BOOL ty_topBarHidden;             /**< 隐藏导航栏  影响: 当前页面 */
@property (nonatomic) CGFloat ty_topBarAlpha;           /**< 导航栏整体透明度  影响：当前页面 */
@property (nonatomic) BOOL ty_topBarUseAlphaInsteadHidden;  /**< 设置导航栏整体隐藏时，使用alpha=0代替 [default: yes]  影响：当前页面 */

@property (nonatomic) CGFloat ty_topBarBlurAlpha;       /**< 毛玻璃效果, Default:0  影响：当前页面 */
@property (nonatomic) CGFloat ty_topBarBackgroundAlpha;             /**< 背景透明度  影响：当前页面 */
@property (nonatomic) CGFloat ty_topBarSeparatorAlpha;              /**< 分割线透明度  影响：当前页面 */
@property (nonatomic) CGAffineTransform ty_topBarTransform;         /**< 导航栏transform  影响: 当前页面 */
@property (nonatomic, strong) UIColor *ty_topBarBackgroundColor;    /**< 背景色  影响：当前页面 */
@property (nonatomic, strong) UIImage *ty_topBarBackgroundImage;    /**< 背景图  影响：当前页面 */
@property (nonatomic, strong) CALayer *ty_topBarBackgroundLayer;    /**< 背景层  影响：当前页面 Available After TuyaSmart 3.9.0+ */
@property (nonatomic, strong) UIColor *ty_topBarSeparatorColor;     /**< 分割线颜色  影响：当前页面 */

#pragma mark - PopGesture
@property (nonatomic) TYNavigationPopGestureType ty_topBarPopGestureType;   /**< 返回手势 影响: 当前页面 */
@property (nonatomic) BOOL ty_topBarHitThrough; /**< 点击(背景时)是否可以贯穿navi [default: NO]  影响：当前页面 */


#pragma mark - StatusBar
// ty_topBarStatusBarxxx Available After TuyaSmart 3.9.0+
@property (nonatomic) UIStatusBarStyle ty_topBarStatusBarStyle;     /**< 状态栏样式 影响: 当前页面 */
@property (nonatomic) BOOL ty_topBarStatusBarHidden;   /**< 隐藏状态栏 default:NO 影响: 当前页面 */
@property (nonatomic) UIStatusBarAnimation ty_topBarStatusBarAnimation;



#pragma mark - Deprecated
@property (nonatomic) CGFloat ty_topBarSeperatorAlpha __deprecated_msg("Use ty_topBarSeparatorAlpha instead");

@end



@interface UIViewController ()  <TYNavigationTopBarProtocol>
@end
