//
//  TYModuleLaunchTaskRegisterProtocol.h
//  TYModuleManager
//
//  Created by TuyaInc on 2018/9/18.
//

#import <Foundation/Foundation.h>

#import "TYLaunchTaskProtocol.h"

@protocol TYModuleLaunchTaskRegisterProtocol <NSObject>

@optional
- (NSArray<Class<TYLaunchTaskProtocol>> *)registLaunchTasks;

@end
