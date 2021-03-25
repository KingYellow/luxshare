//
//  TYLaunchTaskProtocol.h
//  TYModuleManager
//
//  Created by TuyaInc on 2018/10/23.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    TYLaunchTaskRunMode_AsyncOnGlobal   = 0,      /**< 异步到全局队列执行 */
    TYLaunchTaskRunMode_AsyncOnMain     = 1,      /**< 异步到主队列执行 */
    // 在主线程串行由于对启动时间影响较大，为内部保留类型，有需要请打call
} TYLaunchTaskRunMode;

typedef enum : NSUInteger {
    TYLaunchTaskPriority_Low = 250,
    TYLaunchTaskPriority_Default = 750,
    TYLaunchTaskPriority_Hight = 1000,
} TYLaunchTaskPriority;


@protocol TYLaunchTaskProtocol <NSObject>

@required
/*
 开始执行, 请把需要执行的任务写在此回调下
 */
- (void)start;

@optional
/*
 执行方式  [Default: TYLaunchTaskRunMode_AsyncOnGlobal]
 */
+ (TYLaunchTaskRunMode)runMode;

/**
 优先级，默认为 TYLaunchTaskPriority_Default
 */
+ (TYLaunchTaskPriority)priority;

@end
