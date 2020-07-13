//
//  TOTACurrentBackGestureDelegate.m
//  DDSample
//
//  Created by 黄振 on 2020/4/21.
//  Copyright © 2020 KingYellow. All rights reserved.
//

#import "TOTACurrentBackGestureDelegate.h"

#import "TOTANavigationController.h"
#import "UIViewController+TOTANavExp.h"

@implementation TOTACurrentBackGestureDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    
    // 没有开启自动以返回
    UIViewController *topViewController = self.navController.topViewController;
    if (!topViewController.customBackGestureEnabel){
        return NO;
    }
    
    // 正在做过渡动画
    if ([[self.navController valueForKey:@"_isTransitioning"] boolValue]){
        return NO;
    }
    
    // 是否是自定义手势
    if (![gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        return  NO;
    }
    
    UIPanGestureRecognizer *customGesture = (UIPanGestureRecognizer *)gestureRecognizer;
    
    // 手势所在视图的速度
    CGPoint velocity = [customGesture velocityInView:customGesture.view];
    if (velocity.x < 0) {
        return NO;
    }
    
    // 手势所在的起始点
    CGPoint startPoint = [customGesture locationInView:customGesture.view];
    CGFloat allowMax  = topViewController.customBackGestureEdge;
    
    if (topViewController.customBackGestureEdge >= 0 && startPoint.x > allowMax  ) {
        return NO;
    }
    
    // 获取系统手势的操作
    SEL action = NSSelectorFromString(@"handleNavigationTransition:");
    
    // 把系统侧滑的手势操作给自定义的手势
    [gestureRecognizer addTarget:self.systemGestureTarget action:action];
    
    return YES;
}

@end
