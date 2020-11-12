//
//  TYViewControllerNaviBarProtocol.h
//  TYNavigationController
//
//  Created by TuyaInc on 2018/11/21.
//

#import <Foundation/Foundation.h>

#import "TYNavigationBarItem.h"
#import "TYNavigationTypeDefine.h"

/**
 zh^
 所有以 ty_naviBar 开头的属性 均表示 在多层级页面中持续生效，对后续push出来的页面的navi 有影响
 get方法只返回设置值，如果没有设置过，则没有返回值
 如果需要获取默认值等其它途径的值，使用<TYNavigationPresentProtocol>中的ty_naviPresentxxx代替
 !!! 请不要重写属性的Accessor方法，否则将导致数据不准确
 zh$
 
 en^
 ty_naviBarxxx means this method/property will effect on current view controller and the view controller that pushed by current view controller
 getter only return the value that you set, it will be nil if you didn't set
 if you want to get something such as default value, use ty_naviPresentxxx in <TYNavigationPresentProtocol> insted
 !!! Don't override any accessor method
 en$
 */
@protocol TYNavigationNaviBarProtocol <NSObject>

#pragma mark - NaviItem
@property (nonatomic) BOOL ty_naviBarEnableBackItem;     /**< 是否使用back/cancel按钮  影响：当前页面&push页面 */
@property (nonatomic, strong) TYNavigationBarItem *ty_naviBarBackItem;      /**< back/cancel按钮样式  影响：当前页面&push页面 */
@property (nonatomic, strong) TYNavigationBarItem *ty_naviBarLeftItem;      /**< left样式  影响：当前页面&push页面 */
@property (nonatomic, strong) TYNavigationBarItem *ty_naviBarCenterItem;    /**< center样式  影响：当前页面&push页面 */
@property (nonatomic, strong) TYNavigationBarItem *ty_naviBarRightItem;     /**< right样式  影响：当前页面&push页面 */

/**
 layout from left to right
 Available After TuyaSmart 3.9.0+
 */
@property (nonatomic, strong) NSArray<TYNavigationBarItem *> *ty_naviBarLeftItems;

/**
 layout from left to right
 Available After TuyaSmart 3.9.0+
 */
@property (nonatomic, strong) NSArray<TYNavigationBarItem *> *ty_naviBarRightItems;

@property (nonatomic, strong) UIColor *ty_naviBarItemsNormalTintColor;
@property (nonatomic, strong) UIColor *ty_naviBarItemsSelectTintColor;
@property (nonatomic, strong) UIColor *ty_naviBarItemsDisableTintColor;

#pragma mark - NaviStyle
@property (nonatomic) BOOL ty_naviBarHidden;             /**< 隐藏导航栏  影响: 当前页面&push页面 */
@property (nonatomic) CGFloat ty_naviBarAlpha;           /**< 导航栏整体透明度  影响：当前页面&push页面 */
@property (nonatomic) BOOL ty_naviBarUseAlphaInsteadHidden;   /**< 设置导航栏整体隐藏时，使用alpha=0代替 [default: yes]  影响：当前页面&push页面 */

@property (nonatomic) CGFloat ty_naviBarBlurAlpha;      /**< 毛玻璃效果 Default:0  影响：当前页面&push页面 */
@property (nonatomic) CGFloat ty_naviBarBackgroundAlpha;            /**< 背景透明度  影响：当前页面&push页面 */
@property (nonatomic) CGFloat ty_naviBarSeparatorAlpha;             /**< 分割线透明度  影响：当前页面&push页面 */
@property (nonatomic) CGAffineTransform ty_naviBarTransform;        /**< 导航栏transform  影响: 当前页面&push页面 */
@property (nonatomic, strong) UIColor *ty_naviBarBackgroundColor;   /**< 背景色  影响：当前页面&push页面 */
@property (nonatomic, strong) UIImage *ty_naviBarBackgroundImage;   /**< 背景图  影响：当前页面&push页面 */
@property (nonatomic, strong) CALayer *ty_naviBarBackgroundLayer;    /**< 背景层  影响：当前页面&push页面 Available After TuyaSmart 3.9.0+ */
@property (nonatomic, strong) UIColor *ty_naviBarSeparatorColor;    /**< 分割线颜色  影响：当前页面&push页面 */

#pragma mark - PopGesture
@property (nonatomic) TYNavigationPopGestureType ty_naviBarPopGestureType;   /**< 返回手势 影响: 当前页面&push页面 */
@property (nonatomic) BOOL ty_naviBarHitThrough; /**< 点击(背景时)是否可以贯穿navi  影响：当前页面&push页面 */

#pragma mark - StatusBar
// ty_naviBarStatusBarxxx Available After TuyaSmart 3.9.0+
@property (nonatomic) UIStatusBarStyle ty_naviBarStatusBarStyle;     /**< 状态栏样式 影响: 当前页面&push页面 */
@property (nonatomic) BOOL ty_naviBarStatusBarHidden;   /**< 隐藏状态栏 default:NO 影响：当前页面&push页面 */
@property (nonatomic) UIStatusBarAnimation ty_naviBarStatusBarAnimation;

@end



@interface UIViewController () <TYNavigationNaviBarProtocol>
@end

