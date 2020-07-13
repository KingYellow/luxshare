//
//  UIViewController+TOTANavExp.m
//  DDSample
//
//  Created by 黄振 on 2020/4/20.
//  Copyright © 2020 KingYellow. All rights reserved.
//

#import "UIViewController+TOTANavExp.h"
#import <objc/runtime.h>

@implementation UIViewController (TOTANavExp)

- (BOOL)disableSlidingBackGesture
{
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}
- (void)setDisableSlidingBackGesture:(BOOL)disableSlidingBackGesture
{
    objc_setAssociatedObject(self, @selector(disableSlidingBackGesture), @(disableSlidingBackGesture), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [self dealSlidingGestureDelegate];
}

- (BOOL)customBackGestureEnabel
{
    return [objc_getAssociatedObject(self, _cmd) boolValue] ;
}
- (void)setCustomBackGestureEnabel:(BOOL)customBackGestureEnabel
{
    objc_setAssociatedObject(self, @selector(customBackGestureEnabel), @(customBackGestureEnabel), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [self dealSlidingGestureDelegate];

}

- (CGFloat)customBackGestureEdge
{
    return [objc_getAssociatedObject(self, _cmd) floatValue] ;
}
- (void)setCustomBackGestureEdge:(CGFloat)customBackGestureEdge
{
    objc_setAssociatedObject(self, @selector(customBackGestureEdge), @(customBackGestureEdge), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (TOTANavigationController *)currentNavController
{
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setCurrentNavController:(TOTANavigationController *)currentNavController
{
    objc_setAssociatedObject(self, @selector(currentNavController), currentNavController, OBJC_ASSOCIATION_ASSIGN);
}


- (TOTANavigationBar *)currentNavBar
{
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setCurrentNavBar:(TOTANavigationBar *)currentNavBar
{
    objc_setAssociatedObject(self, @selector(currentNavBar), currentNavBar, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIStatusBarStyle)statusBarStyle
{
    return [objc_getAssociatedObject(self, _cmd) integerValue] ;
}
- (void)setStatusBarStyle:(UIStatusBarStyle)statusBarStyle
{
    if (self.statusBarStyle == statusBarStyle) {
        return ;
    }
    
    objc_setAssociatedObject(self, @selector(statusBarStyle), @(statusBarStyle), OBJC_ASSOCIATION_RETAIN_NONATOMIC);

    [self setNeedsStatusBarAppearanceUpdate];
    
}

- (BOOL)statusBarHidden
{
    return [objc_getAssociatedObject(self, _cmd) boolValue] ;
}
- (void)setStatusBarHidden:(BOOL)statusBarHidden
{
    if (self.statusBarHidden == statusBarHidden) {
        return ;
    }
    
    objc_setAssociatedObject(self, @selector(statusBarHidden), @(statusBarHidden), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)dealSlidingGestureDelegate
{
    TOTANavigationController *navController = (TOTANavigationController *)self.navigationController ;
    if (nil != navController) {
        if (self.disableSlidingBackGesture) {
            navController.interactivePopGestureRecognizer.delegate = nil ;
            navController.interactivePopGestureRecognizer.enabled = NO ;
        }
        else{
            
            navController.interactivePopGestureRecognizer.delegate = navController ;
            navController.interactivePopGestureRecognizer.enabled = YES ;
            
            if (self.customBackGestureEnabel) {
                
                [navController.interactivePopGestureRecognizer.view addGestureRecognizer:navController.sideslipBackGesture];
                
                navController.sideslipBackGesture.delegate = navController.customBackGestureDelegate ;
                
                navController.interactivePopGestureRecognizer.delegate = nil;
                navController.interactivePopGestureRecognizer.enabled  = NO;
            }
            
        }
    }
    
}


- (BOOL)prefersStatusBarHidden {

    return self.statusBarHidden;
}
@end
