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

#import "WMZPageConfig.h"
#import "WMZPageController.h"
#import "WMZPageDataView.h"
#import "WMZPageScroller.h"
#import "NSObject+SafeKVO.h"
#import "UIView+PageRect.h"
#import "WMZPageLoopView.h"
#import "WMZPageMunuView.h"
#import "WMZPageParam.h"
#import "WMZPageProtocol.h"
#import "WMZPageNaviBtn.h"

FOUNDATION_EXPORT double WMZPageControllerVersionNumber;
FOUNDATION_EXPORT const unsigned char WMZPageControllerVersionString[];

