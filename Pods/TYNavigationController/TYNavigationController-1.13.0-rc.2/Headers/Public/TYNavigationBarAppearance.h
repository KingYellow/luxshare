//
//  TYNavigationBarAppearance.h
//  TYNavigationController
//
//  Created by TuyaInc on 2019/1/16.
//

#import <Foundation/Foundation.h>

#import "TYNavigationTypeDefine.h"
#import "TYNavigationBarItem.h"


@interface TYNavigationBarItemAppearance : NSObject

@property (nonatomic, strong) UIFont *titleFont;

@property (nonatomic, strong) NSDictionary<NSAttributedStringKey, id> *normalTitleAttribute;
@property (nonatomic, strong) NSDictionary<NSAttributedStringKey, id> *selectTitleAttribute;
@property (nonatomic, strong) NSDictionary<NSAttributedStringKey, id> *disableTitleAttribute;

@property (nonatomic, strong) UIColor *normalTintColor;
@property (nonatomic, strong) UIColor *selectTintColor;
@property (nonatomic, strong) UIColor *disableTintColor;

@property (nonatomic) CGFloat leftEdge;
@property (nonatomic) CGFloat rightEdge;

@property (nonatomic) UIEdgeInsets hitExtend;   /**< 点击区域扩展 正向外 负向内 */

@end



/**
 对navigationBar进行默认配置
 修改不表示立即生效
 */
@interface TYNavigationBarAppearance : NSObject

+ (instancetype)appearance __deprecated_msg("Use +shareAppearance instead");
+ (instancetype)shareAppearance;

#pragma mark - Items
@property (nonatomic, strong) TYNavigationBarItemAppearance *naviBarBackItem;      /**< back样式 */
@property (nonatomic, strong) TYNavigationBarItemAppearance *naviBarLeftItem;      /**< left样式 */
@property (nonatomic, strong) TYNavigationBarItemAppearance *naviBarCenterItem;    /**< center样式 */
@property (nonatomic, strong) TYNavigationBarItemAppearance *naviBarRightItem;     /**< right样式 */

/**
 left edge to screen for the first left item (left items include back item)
 if value < 0, will use naviBarLeftItem.leftEdge insted
 default value is 16
 if back item exist, this value won't wrok, and naviBarLeftItem.leftEdge will work
 Available After TuyaSmart 3.9.0+
 */
@property (nonatomic) CGFloat leftEdgeForFirstLeftItem;
/**
 right edge to screen for the last right item
 if value < 0, will use naviBarLeftItem.leftEdge insted
 default value is 16
 Available After TuyaSmart 3.9.0+
 */
@property (nonatomic) CGFloat rightEdgeForLastRightItem;

#pragma mark - NaviStyle
@property (nonatomic) BOOL naviBarHidden;                           /**< 隐藏导航栏 */
@property (nonatomic) CGFloat naviBarAlpha;                         /**< 导航栏整体透明度 */
@property (nonatomic) BOOL naviBarUseAlphaInsteadHidden;            /**< 使用alpha=0代替导航栏隐藏 */
@property (nonatomic) CGFloat naviBarBlurAlpha;                     /**< 毛玻璃效果 */
@property (nonatomic) CGFloat naviBarBackgroundAlpha;               /**< 背景透明度 */
@property (nonatomic) CGFloat naviBarSeparatorAlpha;                /**< 分割线透明度 */
@property (nonatomic) CGAffineTransform naviBarTransform;           /**< 导航栏transform */
@property (nonatomic, strong) UIColor *naviBarBackgroundColor;      /**< 背景色 */
@property (nonatomic, strong) UIImage *naviBarBackgroundImage;      /**< 背景图 */
@property (nonatomic, strong) CALayer *naviBarBackgroundLayer;      /**< 背景层 Available After TuyaSmart 3.9.0+ */
@property (nonatomic, strong) UIColor *naviBarSeparatorColor;       /**< 分割线颜色 */

#pragma mark - PopGesture
@property (nonatomic) TYNavigationPopGestureType naviBarPopGestureType;     /**< 返回手势 */
@property (nonatomic) BOOL naviBarHitThrough;                               /**< 点击(背景时)是否可以贯穿navi */

#pragma mark - StatusBar
@property (nonatomic) UIStatusBarStyle statusBarStyle;
@property (nonatomic) BOOL statusBarHidden;
@property (nonatomic) UIStatusBarAnimation statusBarAnimation;

@end
