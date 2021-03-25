//
//  TuyaSmartBizCore.h
//  TuyaSmartBizCore
//
//  Created by huangjj on 2020/3/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TuyaSmartBizCore : NSObject

+ (_Nonnull instancetype)sharedInstance;

/**
 * Get the instance which implement the special service protocol
 * eg:
 *  id<TYMallProtocol> impl = [[TuyaSmartBizCore sharedInstance] serviceOfProtocol:@protocol(TYMallProtocol)];
 *  [impl xxx]; // your staff...
 *
 * @param serviceProtocol service protocol
 * @return instance
 */
- (id)serviceOfProtocol:(Protocol *)service;

/**
 * Register a instance for service which can not be served by BizBundle itself
 * Each service can only register one instance or class at a time, whichever is the last
 *
 * @param service   service protocol
 * @param instance  instance which conform to the service protocol, strong reference
 *                  unregister if nil
 */
- (void)registerService:(Protocol *)service withInstance:(id)instance;

/**
 * Register a class for service which can not be served by BizBundle itself
 * Each service can only register one instance or class at a time, whichever is the last
 *
 *
 * @param service   service protocol
 * @param cls       class which conform to the service protocol, [cls new] to get instance
 *                  unregister if nil
 */
- (void)registerService:(Protocol *)service withClass:(Class)cls;

/**
 * Register route handler for route which can not be handled by BizBundle itself
 * @param handler   block to handle route
 *                  @param url  the route url
 *                  @param raw  the route raw data
 *                  @return true if route can be handled, otherwise return false
 */
- (void)registerRouteWithHandler:(BOOL(^)(NSString *url, NSDictionary *raw))handler;

/**
* Update config of biz resource
*
*/
- (void)updateConfig;

@end

NS_ASSUME_NONNULL_END
