//
//  TYModuleRouteRegisterProtocol.h
//  TYModuleManager
//
//  Created by TuyaInc on 2018/8/30.
//

#import <Foundation/Foundation.h>

@protocol TYModuleRouteRegisterProtocol <NSObject>

@optional
// 注册路由
- (NSArray<NSString *> *)registModuleRoutes;

/*
 为路由表注册优先级 优先级越高，会被优先路由
 eg:
 @{
    @"TYPageName":@(10)
 }
 */
- (NSDictionary<NSString *, NSNumber *> *)registPriorityForRoutes;

// 处理路由事件
- (BOOL)handleRouteWithScheme:(NSString *)scheme host:(NSString *)host path:(NSString *)path params:(NSDictionary *)params;

@end
