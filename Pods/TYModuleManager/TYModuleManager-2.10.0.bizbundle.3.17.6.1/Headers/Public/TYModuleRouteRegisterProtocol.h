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
// 处理路由事件
- (BOOL)handleRouteWithScheme:(NSString *)scheme host:(NSString *)host path:(NSString *)path params:(NSDictionary *)params;

@end
