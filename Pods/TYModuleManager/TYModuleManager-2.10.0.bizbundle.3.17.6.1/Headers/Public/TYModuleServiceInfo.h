//
//  TYModuleServiceInfo.h
//  TYModuleManager
//
//  Created by TuyaInc on 2018/8/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class TYModuleServiceInfo;

FOUNDATION_EXTERN TYModuleServiceInfo * TYModuleServiceInfoMake(Protocol *protocol, Class implCls);

@interface TYModuleServiceInfo : NSObject <NSCopying>

@property (nonatomic, strong) Protocol *protocol; /**< 服务的协议 */
@property (nonatomic, strong) Class implClass;   /**< 提供服务的类 */

@property (nonatomic, getter=isSingleton, readonly) BOOL singleton;   /**< 是否是单例，如果是，则会在moduleManager内部对实例进行保留 [default:YES] */

+ (TYModuleServiceInfo *)serviceInfoWith:(Protocol *)protocol implClass:(Class)implCls;

@end

NS_ASSUME_NONNULL_END
