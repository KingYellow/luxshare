//
//  TYNavigationBarItem.h
//  TYNavigationController
//
//  Created by TuyaInc on 2018/11/13.
//

#import <Foundation/Foundation.h>

#import "TYNavigationBarItemMaker.h"

@interface TYNavigationBarItem : NSObject <NSCopying, UIAccessibilityIdentification>

/**
 [^zh]
 一旦设置了customView，其它样式、状态属性均不再可用
 [$zh]
 [^en]
 if customView is set, other properties will not work
 [$en]
 */
@property (nonatomic, strong) UIView *customView;

/**
 [^zh]
 只有 Normal、Highlighted、Disabled 可用
 [$zh]
 [^en]
 Only Normal、Highlighted、Selected、Disabled are available
 [$en]
 */
@property (nonatomic) UIControlState status;

/**
 [^zh]
 文本的字体，默认nil
 nil则使用 TYNavigationBarItemAppearance.titleFont
 [$zh]
 [^en]
 title font, default is nil
 if nil, then use TYNavigationBarItemAppearance.titleFont instead
 [$en]
 */
@property (nonatomic, strong) UIFont *titleFont;

@property (nonatomic, copy) NSString *normalTitle;
@property (nonatomic, copy) NSDictionary<NSAttributedStringKey, id> *normalTitleAttribute;
@property (nonatomic, copy) NSString *selectTitle;
@property (nonatomic, copy) NSDictionary<NSAttributedStringKey, id> *selectTitleAttribute;
@property (nonatomic, copy) NSString *disableTitle;
@property (nonatomic, copy) NSDictionary<NSAttributedStringKey, id> *disableTitleAttribute;

@property (nonatomic, strong) UIImage *normalImage;
@property (nonatomic, strong) UIImage *selectImage;
@property (nonatomic, strong) UIImage *disableImage;
@property (nonatomic) UIImageRenderingMode renderingMode;   /**< Original模式下，normalTintColor仅对文字生效 */

@property (nonatomic, strong) UIColor *normalBackgroundColor;
@property (nonatomic, strong) UIColor *selectBackgroundColor;
@property (nonatomic, strong) UIColor *disableBackgroundColor;

@property (nonatomic, strong) UIImage *normalBackgroundImage;
@property (nonatomic, strong) UIImage *selectBackgroundImage;
@property (nonatomic, strong) UIImage *disableBackgroundImage;

@property (nonatomic, strong) UIColor *normalTintColor;
@property (nonatomic, strong) UIColor *selectTintColor; /**< default is normalTintColor with alpha 0.6 */
@property (nonatomic, strong) UIColor *disableTintColor;

@property (nonatomic) CGFloat alpha;
@property (nonatomic) CGSize size;  /**< w or h = 0 or CGFLOAT_MAX means automatic */

@property (nonatomic) NSLineBreakMode titleBreakMode;

@property (nonatomic) UIViewContentMode imageContentMode;
@property (nonatomic) BOOL clipToBounds;

@property (nonatomic) UIEdgeInsets titleInsets;     /**< reference to UIButton.titleEdgeInsets */
@property (nonatomic) UIEdgeInsets imageInsets;     /**< reference to UIButton.imageEdgeInsets */
@property (nonatomic) UIEdgeInsets contentInsets;   /**< reference to UIButton.contentEdgeInsets */

@property (nonatomic) CGFloat leftEdge;         /**< distance to screen or the item on the left  */
@property (nonatomic) CGFloat rightEdge;        /**< distance to screen or the item on the right */
@property (nonatomic) UIOffset offset;

@property (nonatomic) BOOL userInteractionEnabled;      /**< Default: YES */
@property (nonatomic) UIEdgeInsets hitExtend;

/**< tap action target, call back [navi.topVC ty_navixxxItemAction] if target is nil */
@property (nonatomic, weak) id target;
/**< tap action sel, call back [navi.topVC ty_navixxxItemAction] if action is nil */
@property (nonatomic) SEL action;


@property (nonatomic, strong) UIView *decorateView;
/**< center location of decorate view,  x y ∈ [0, 1]  default:(1, 0) */
@property (nonatomic) CGPoint decorateLocation;

@property (nonatomic, readonly) BOOL isEraserItem;

@property (nonatomic) NSInteger tag;


+ (instancetype)itemWithTitle:(NSString *)title;
+ (instancetype)itemWithImage:(UIImage *)image;
+ (instancetype)itemWithCustomView:(UIView *)customView;
+ (instancetype)itemWithUIBarButtonItem:(UIBarButtonItem *)uiBarItem;
+ (instancetype)itemWithMaker:(void(^)(TYNavigationBarItemMaker *maker))block;

/**
 zh*
 空白项，可以用来完全移除navi上已有的item
 zh$
 
 en*
 empty item, use to remove an item on navi completely
 en$
 */
+ (instancetype)eraserItem;

/**
 zh*
 item正在使用的view，刷新后可能变化，不要强引用
 zh$
 
 en*
 the view which show on the navigation bar, Don't retain it
 en$
 */
- (UIView *)currentNaviBarItemView;

@end



@interface TYNavigationBarItem ()

/**
 | -12pt- <
 */
+ (instancetype)backItem;

/**
 | -16pt- Cancel
 */
+ (instancetype)cancelItem;

/**
 navigation title item
 userInteractionEnabled = NO
 */
+ (instancetype)centerItem:(NSString *)title;

@end
