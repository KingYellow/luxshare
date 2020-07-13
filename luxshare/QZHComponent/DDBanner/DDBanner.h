//
//  DDBanner.h
//  DDSample
//
//  Created by 黄振 on 2020/3/25.
//  Copyright © 2020 KingYellow. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

// 定义block用于外部点击回调
typedef void (^TapCarouseViewBlock)(NSInteger pageIndex);

@interface DDBanner : UIView


/// 定时器时间轮播间隔
@property (assign, nonatomic) NSTimeInterval timerSecond;
// 填充分页并设置回调
/// 轮播图
/// @param pageViews 图片路径数组
/// @param block 点击图片回调
- (void)setupSubviewPages:(NSArray *)pageViews withCallbackBlock:(TapCarouseViewBlock)block;
@end

NS_ASSUME_NONNULL_END
