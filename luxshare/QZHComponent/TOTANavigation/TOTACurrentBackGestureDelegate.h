//
//  TOTACurrentBackGestureDelegate.h
//  DDSample
//
//  Created by 黄振 on 2020/4/21.
//  Copyright © 2020 KingYellow. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class TOTANavigationController;
@interface TOTACurrentBackGestureDelegate : NSObject<UIGestureRecognizerDelegate>

/// 当前当行控制器
@property (nonatomic,weak)TOTANavigationController *navController ;

/// 用来替换的系统手势事件
@property (nonatomic,weak)id systemGestureTarget ;

@end

NS_ASSUME_NONNULL_END
