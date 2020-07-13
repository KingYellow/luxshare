//
//  UIViewController+TOTANavExp.h
//  DDSample
//
//  Created by 黄振 on 2020/4/20.
//  Copyright © 2020 KingYellow. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TOTANavigationBar.h"
#import "TOTANavigationController.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (TOTANavExp)


/// 当前的导航控制器
@property (copy, nonatomic)TOTANavigationController *currentNavController;

/// 当前的导航条
@property (strong, nonatomic)TOTANavigationBar *currentNavBar;

/// 当前控制器 是否 禁止侧滑返回
@property (nonatomic,assign)BOOL disableSlidingBackGesture ;


///是否开始 手势侧滑返回
@property (nonatomic,assign)BOOL customBackGestureEnabel ;

/// 如果开启了手势侧滑，那么侧滑距离左边最大的距离
@property (nonatomic,assign)CGFloat customBackGestureEdge ;

/// 当为scrollview的时候是否开启侧滑返回

//@property (nonatomic,assign)BOOL scrollViewBackEnable ;


/// 当前控制器状态栏类型

@property (nonatomic,assign)UIStatusBarStyle statusBarStyle;


/// 当前控制器的状态栏是否隐藏

@property (nonatomic,assign)BOOL statusBarHidden ;


///处理侧滑返回手势

- (void)dealSlidingGestureDelegate ;
@end

NS_ASSUME_NONNULL_END
