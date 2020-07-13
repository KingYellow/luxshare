//
//  NSObject+Exp.m
//  MYM
//
//  Created by 米翊米 on 2018/6/8.
//  Copyright © 2018年 米翊米. All rights reserved.
//

#import "NSObject+Exp.h"
#import "NSString+Exp.h"

@implementation NSObject (Exp)

/// 获取当前vc
- (UIViewController *)exp_getCurrentVC {
    UIViewController *vc = [[UIApplication sharedApplication] delegate].window.rootViewController;
    
    UIViewController *parent = vc;
    
    while ((parent = vc.presentedViewController) != nil ) {
        vc = parent;
    }
    
    while ([vc isKindOfClass:[UINavigationController class]]) {
        vc = [(UINavigationController *)vc topViewController];
    }
    
    if ([vc isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tab = (UITabBarController *)vc;
        if ([tab.selectedViewController isKindOfClass:[UINavigationController class]]) {
            UINavigationController *nav = (UINavigationController *)tab.selectedViewController;
            return [nav.viewControllers lastObject];
        } else {
            return tab.selectedViewController;
        }
    } else if ([vc isKindOfClass:[UINavigationController class]]) {
        UINavigationController *nav = (UINavigationController *)vc;
        return [nav.viewControllers lastObject];
    } else {
        return vc;
    }
}

///时间戳转时间字符串
- (NSString *)exp_timeCoverString:(id)time formart:(NSString *)formart replace:(NSString *)string {
    if (time) {
        NSString *timeStr = [NSString stringWithFormat:@"%@", time];
        if (timeStr.length > 10) {
            timeStr = [timeStr substringToIndex:10];
            return [timeStr exp_dateFormart:formart];
        } else {
            return [timeStr exp_dateFormart:formart];
        }
    } else {
        return string;
    }
}

///获取指定位置VC
- (UIViewController *)exp_viewControllerCount:(NSInteger)count end:(BOOL)end {
    NSInteger all = [self exp_getCurrentVC].navigationController.childViewControllers.count;
    if (count < all && (count -1) >= 0) {
        if (end) {
            return [self exp_getCurrentVC].navigationController.childViewControllers[all-count-1];
        }
        return [self exp_getCurrentVC].navigationController.childViewControllers[count-1];
    } else {
        return nil;
    }
}

@end
