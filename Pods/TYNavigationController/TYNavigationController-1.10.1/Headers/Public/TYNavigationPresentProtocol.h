//
//  TYNavigationPresentProtocol.h
//  TYNavigationController
//
//  Created by TuyaInc on 2018/12/1.
//

#import <Foundation/Foundation.h>

#import "TYNavigationBarItem.h"
#import "TYNavigationTypeDefine.h"

/**
 method has prefix ty_naviPresent only used to get current status of view controller
 
 NaviPresent Rule:
 - (id)ty_naviPresentxxx {
     if (vc.ty_naviBarxxx) {
        return vc.ty_naviBarxxx
     } else if (navi.topVC == vc && vc.ty_topBarxxx) {
        return vc.ty_topBarxxx
     } else if (vc.idx_in_navi_stack == 0) {
        return defaultValue
     } else {
        last_vc = navi.stack[vc.idx_in_navi_stack - 1]
        return last_vc.ty_naviPresentxxx
     }
 }
 
 */
@protocol TYNavigationPresentProtocol <NSObject>

#pragma mark - NaviItem
@property (nonatomic, readonly) BOOL ty_naviPresentEnableBackItem;
@property (nonatomic, weak, readonly) TYNavigationBarItem *ty_naviPresentBackItem;
/**
 return the first obj in ty_naviPresentLeftItems after TuyaSmart 3.9.0+
 */
@property (nonatomic, weak, readonly) TYNavigationBarItem *ty_naviPresentLeftItem;
/**
 return the first obj in ty_naviPresentRightItems after TuyaSmart 3.9.0+
 */
@property (nonatomic, weak, readonly) TYNavigationBarItem *ty_naviPresentRightItem;

/**
 Available After TuyaSmart 3.9.0+
 */
@property (nonatomic, weak, readonly) NSArray<TYNavigationBarItem *> *ty_naviPresentLeftItems;
/**
 Available After TuyaSmart 3.9.0+
 */
@property (nonatomic, weak, readonly) NSArray<TYNavigationBarItem *> *ty_naviPresentRightItems;

@property (nonatomic, weak, readonly) TYNavigationBarItem *ty_naviPresentCenterItem;

#pragma mark - NaviStyle
@property (nonatomic, readonly) BOOL ty_naviPresentHidden;
@property (nonatomic, readonly) CGFloat ty_naviPresentAlpha;
@property (nonatomic, readonly) BOOL ty_naviPresentUseAlphaInsteadHidden;
@property (nonatomic, readonly) CGFloat ty_naviPresentBlurAlpha;
@property (nonatomic, readonly) CGFloat ty_naviPresentBackgroundAlpha;
@property (nonatomic, readonly) CGFloat ty_naviPresentSeparatorAlpha;
@property (nonatomic, readonly) CGAffineTransform ty_naviPresentTransform;
@property (nonatomic, readonly) UIColor *ty_naviPresentBackgroundColor;
@property (nonatomic, readonly) UIImage *ty_naviPresentBackgroundImage;
@property (nonatomic, readonly) CALayer *ty_naviPresentBackgroundLayer; /**< Available After TuyaSmart 3.9.0+ */
@property (nonatomic, readonly) UIColor *ty_naviPresentSeparatorColor;

#pragma mark - Gesture
@property (nonatomic, readonly) TYNavigationPopGestureType ty_naviPresentPopGestureType;
@property (nonatomic, readonly) BOOL ty_naviPresentHitThrough;

#pragma mark - StatusBar
@property (nonatomic, readonly) UIStatusBarStyle ty_naviPresentStatusBarStyle;
@property (nonatomic, readonly) BOOL ty_naviPresentStatusBarHidden;
@property (nonatomic, readonly) UIStatusBarAnimation ty_naviPresentStatusBarAnimation;

@end



@interface UIViewController ()  <TYNavigationPresentProtocol>
@end
