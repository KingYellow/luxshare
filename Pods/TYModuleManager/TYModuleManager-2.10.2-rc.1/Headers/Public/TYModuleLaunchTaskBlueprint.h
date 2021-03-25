//
//  TYModuleLaunchTaskBlueprint.h
//  TYModuleManager
//
//  Created by TuyaInc on 2018/9/18.
//

#import <Foundation/Foundation.h>

#import "TYModuleBaseBlueprint.h"
#import "TYLaunchTaskProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@protocol TYModuleLaunchTaskBlueprint <TYModuleBaseBlueprint>

@property (nonatomic) BOOL enableCircleCheck;   /**< 是否开启依赖的成环检测 默认仅在DEBUG下开启 */

- (void)registLaunchTask:(Class<TYLaunchTaskProtocol>)taskCls;
- (void)registLaunchTaskFromArray:(NSArray<Class<TYLaunchTaskProtocol>> *)taskArr;

/*
 * 优先执行串行任务，然后 并发 asyncOnMain和asyncOnGlobal，同时此方法结束
 */
- (void)executeLaunchTasks;

@end

NS_ASSUME_NONNULL_END
