//
//  TYNavigationItemMaker.h
//  TYNavigationController
//
//  Created by TuyaInc on 2019/1/16.
//

#import <Foundation/Foundation.h>

@interface TYNavigationBarItemMaker : NSObject

@property (nonatomic, copy, readonly) TYNavigationBarItemMaker *(^titleFont)(UIFont *font);

@property (nonatomic, copy, readonly) TYNavigationBarItemMaker *(^status)(UIControlState status);

@property (nonatomic, copy, readonly) TYNavigationBarItemMaker * (^normalTitle)(NSString *str);
@property (nonatomic, copy, readonly) TYNavigationBarItemMaker *(^normalTitleAttribute)(NSDictionary<NSAttributedStringKey, id> *dic);
@property (nonatomic, copy, readonly) TYNavigationBarItemMaker * (^selectTitle)(NSString *str);
@property (nonatomic, copy, readonly) TYNavigationBarItemMaker *(^selectTitleAttribute)(NSDictionary<NSAttributedStringKey, id> *dic);
@property (nonatomic, copy, readonly) TYNavigationBarItemMaker * (^disableTitle)(NSString *str);
@property (nonatomic, copy, readonly) TYNavigationBarItemMaker *(^disableTitleAttribute)(NSDictionary<NSAttributedStringKey, id> *dic);

@property (nonatomic, copy, readonly) TYNavigationBarItemMaker *(^normalImage)(UIImage *img);
@property (nonatomic, copy, readonly) TYNavigationBarItemMaker *(^selectImage)(UIImage *img);
@property (nonatomic, copy, readonly) TYNavigationBarItemMaker *(^disableImage)(UIImage *img);
@property (nonatomic, copy, readonly) TYNavigationBarItemMaker *(^renderingMode)(UIImageRenderingMode mode);    /**< Original模式下，normalTintColor仅对文字生效 */

@property (nonatomic, copy, readonly) TYNavigationBarItemMaker *(^normalBackgroundColor)(UIColor *color);
@property (nonatomic, copy, readonly) TYNavigationBarItemMaker *(^selectBackgroundColor)(UIColor *color);
@property (nonatomic, copy, readonly) TYNavigationBarItemMaker *(^disableBackgroundColor)(UIColor *color);
@property (nonatomic, copy, readonly) TYNavigationBarItemMaker *(^normalBackgroundImage)(UIImage *img);
@property (nonatomic, copy, readonly) TYNavigationBarItemMaker *(^selectBackgroundImage)(UIImage *img);
@property (nonatomic, copy, readonly) TYNavigationBarItemMaker *(^disableBackgroundImage)(UIImage *img);

@property (nonatomic, copy, readonly) TYNavigationBarItemMaker *(^normalTintColor)(UIColor *color);
@property (nonatomic, copy, readonly) TYNavigationBarItemMaker *(^selectTintColor)(UIColor *color);
@property (nonatomic, copy, readonly) TYNavigationBarItemMaker *(^disableTintColor)(UIColor *color);

@property (nonatomic, copy, readonly) TYNavigationBarItemMaker *(^alpha)(CGFloat alpha);
@property (nonatomic, copy, readonly) TYNavigationBarItemMaker *(^size)(CGSize size);

/**
 Available After TuyaSmart 3.9.0+
 */
@property (nonatomic, copy, readonly) TYNavigationBarItemMaker *(^labelBreakMode)(NSLineBreakMode mode);
/**
 Available After TuyaSmart 3.9.0+
 */
@property (nonatomic, copy, readonly) TYNavigationBarItemMaker *(^imageContentMode)(UIViewContentMode mode);
/**
 Available After TuyaSmart 3.9.0+
 */
@property (nonatomic, copy, readonly) TYNavigationBarItemMaker *(^clipToBounds)(BOOL clip);

@property (nonatomic, copy, readonly) TYNavigationBarItemMaker *(^titleInsets)(UIEdgeInsets insets);
@property (nonatomic, copy, readonly) TYNavigationBarItemMaker *(^imageInsets)(UIEdgeInsets insets);
@property (nonatomic, copy, readonly) TYNavigationBarItemMaker *(^contentInsets)(UIEdgeInsets insets);

@property (nonatomic, copy, readonly) TYNavigationBarItemMaker *(^leftEdge)(CGFloat edge);
@property (nonatomic, copy, readonly) TYNavigationBarItemMaker *(^rightEdge)(CGFloat edge);
@property (nonatomic, copy, readonly) TYNavigationBarItemMaker *(^offset)(UIOffset offset);

@property (nonatomic, copy, readonly) TYNavigationBarItemMaker *(^userInteractionEnabled)(BOOL userInteractionEnabled);
@property (nonatomic, copy, readonly) TYNavigationBarItemMaker *(^hitExtend)(UIEdgeInsets hitExtend);

@property (nonatomic, copy, readonly) TYNavigationBarItemMaker *(^target)(id target);
@property (nonatomic, copy, readonly) TYNavigationBarItemMaker *(^action)(SEL sel);

@property (nonatomic, copy, readonly) TYNavigationBarItemMaker *(^tag)(NSInteger tag);

@property (nonatomic, copy, readonly) TYNavigationBarItemMaker *(^isAccessibilityElement)(BOOL isAccessibilityElement);
@property (nonatomic, copy, readonly) TYNavigationBarItemMaker *(^accessibilityIdentifier)(NSString *accessibilityIdentifier);
@property (nonatomic, copy, readonly) TYNavigationBarItemMaker *(^accessibilityTraits)(UIAccessibilityTraits traits);
@property (nonatomic, copy, readonly) TYNavigationBarItemMaker *(^accessibilityLabel)(NSString *accessibilityLabel);
@property (nonatomic, copy, readonly) TYNavigationBarItemMaker *(^accessibilityHint)(NSString *accessibilityHint);
@property (nonatomic, copy, readonly) TYNavigationBarItemMaker *(^accessibilityValue)(NSString *accessibilityValue);

@end
