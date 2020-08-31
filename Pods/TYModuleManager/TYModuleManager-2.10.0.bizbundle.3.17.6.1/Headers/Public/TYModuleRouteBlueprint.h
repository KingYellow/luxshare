//
//  TYModuleRouteBlueprint.h
//  TYModuleManager
//
//  Created by TuyaInc on 2018/8/21.
//

#import <Foundation/Foundation.h>

#import "TYModuleBaseBlueprint.h"

NS_ASSUME_NONNULL_BEGIN

@class TYModuleRouteInfo;

@protocol TYModuleRouteBlueprint <TYModuleBaseBlueprint>

/**
 scheme、path、query will be ignore
 */
- (void)registRoute:(NSString *)route forModule:(id)module;
- (void)unregistRoute:(NSString *)route;

- (nullable id)moduleOfRoute:(NSString *)route;


- (BOOL)canOpenRoute:(NSString *)route;

/**
 scheme、path、query will passthrough to the handle impl
 */
- (BOOL)openRoute:(NSString *)route withParams:(nullable NSDictionary *)params;

- (void)registerUnhandledRoute:(BOOL(^)(NSString *scheme, NSString *host, NSString *path, NSDictionary *params))callback;

@end

NS_ASSUME_NONNULL_END
