//
//  TOTANavigationController.h
//  DDSample
//
//  Created by 黄振 on 2020/4/21.
//  Copyright © 2020 KingYellow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TOTACurrentBackGestureDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface TOTANavigationController : UINavigationController<UIGestureRecognizerDelegate>
//自定义侧滑返回
@property (strong, nonatomic)UIPanGestureRecognizer *sideslipBackGesture;
@property (strong, nonatomic)TOTACurrentBackGestureDelegate *customBackGestureDelegate ;//自定义返回的代理

/// 继承系统push跳转控制器
/// @param viewController 要跳转的控制器
- (void)pushViewControllerRetro:(UIViewController *)viewController;
- (void)popViewControllerRetro;
@end

NS_ASSUME_NONNULL_END
