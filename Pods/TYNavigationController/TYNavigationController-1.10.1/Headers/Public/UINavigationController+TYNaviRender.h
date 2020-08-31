//
//  UINavigationController+TYNaviRender.h
//  TYNavigationController
//
//  Created by TuyaInc on 2019/9/5.
//

#import <UIKit/UIKit.h>

#import "TYNavigationRenderProtocol.h"
#import "TYNavigationBarItem.h"
#import "TYNavigationBarAppearance.h"

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXPORT NSString * const kTYNaviItemKey;
FOUNDATION_EXPORT CGFloat TYNaviItemDefaultEdgeInset(void);

@interface UINavigationController (TYNaviRender) <TYNavigationRenderProtocol>

/**
 default is [TYNavigationBarAppearance shareAppearance]
 if you want to modify anything only for one navigation controller, you have to create one with [TYNavigationBarAppearance new]
 if you want to modify anything for all navigation controller, you need to call like [TYNavigationBarAppearance shareAppearance].xxx = xxx
 */
@property (nonatomic, strong) TYNavigationBarAppearance *ty_naviApperance;

@property (nonatomic, weak, readonly) UIViewController * _Nullable ty_orientationDecisiveVC;

@end

NS_ASSUME_NONNULL_END
