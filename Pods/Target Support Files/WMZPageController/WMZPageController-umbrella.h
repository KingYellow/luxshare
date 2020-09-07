#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "NSObject+SafeKVO.h"
#import "UIView+PageRect.h"
#import "WMZPageConfig.h"
#import "WMZPageController.h"
#import "WMZPageParam.h"
#import "WMZPageProtocol.h"
#import "WMZPageScroller.h"
#import "WMZPageLoopView.h"
#import "WMZPageNaviBtn.h"

FOUNDATION_EXPORT double WMZPageControllerVersionNumber;
FOUNDATION_EXPORT const unsigned char WMZPageControllerVersionString[];

