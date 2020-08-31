//
//  TYModuleLifeCycleCallbackProtocol.h
//  TYModuleManager
//
//  Created by TuyaInc on 2019/3/7.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 if you need any callback in this protocol
 use - (NSArray<NSString *> *)registRespondsNotifies or [TYModule notifyService] to regist
 */
@protocol TYModuleLifeCycleCallbackProtocol <NSObject>

- (void)applicationModulesDidFinishLoadingNotify;

@end

NS_ASSUME_NONNULL_END
