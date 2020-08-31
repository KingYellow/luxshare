//
//  TYUIKit.h
//  TYUIKit
//
//  Created by TuyaInc on 2018/12/20.
//
//  [DOC_IGNORE_FILE]

#ifdef __OBJC__
    #import <UIKit/UIKit.h>
#else
    #ifndef FOUNDATION_EXTERN
        #if defined(__cplusplus)
            #define FOUNDATION_EXTERN extern "C"
        #else
            #define FOUNDATION_EXTERN extern
        #endif
    #endif

    #ifndef UIKIT_EXTERN
        #ifdef __cplusplus
            #define UIKIT_EXTERN        extern "C" __attribute__((visibility ("default")))
        #else
            #define UIKIT_EXTERN            extern __attribute__((visibility ("default")))
        #endif
    #endif
#endif

#ifndef TYUIKit_h
#define TYUIKit_h

#import "TYUIKitMacro.h"

#import "UINavigationController+TYCategory.h"
#import "UIViewController+TYCategory.h"

#import "UIDevice+TYCategory.h"
#import "UIButton+TYCategory.h"
#import "UIScreen+TYCategory.h"
#import "UIColor+TYCategory.h"
#import "UIImage+TYCategory.h"
#import "UILabel+TYCategory.h"
#import "UIView+TYCategory.h"
#import "UIFont+TYCategory.h"

#import "TYMenuListViewController.h"
#import "TYSearchController.h"
#import "TYSegmentedControl.h"
#import "TYHierarchyManager.h"
#import "TYImpactEngine.h"
#import "TYRippleView.h"
#import "TYEmptyView.h"
#import "TYTextView.h"
#import "TYButton.h"
#import "TYLabel.h"

#if __has_include(<TYNavigationController/UIViewController+TYNavigation.h>)
#import <TYNavigationController/UIViewController+TYNavigation.h>
#import <TYNavigationController/TYNavigationController.h>
#elif __has_include("UIViewController+TYNavigation.h")
#import "UIViewController+TYNavigation.h"
#import "TYNavigationController.h"
#endif

#if __has_include(<TYAnimationKit/UIView+TYAnimation.h>)
#import <TYAnimationKit/UIView+TYAnimation.h>
#elif __has_include("UIView+TYAnimation.h")
#import "UIView+TYAnimation.h"
#endif

#endif /* TYUIKit_h */
