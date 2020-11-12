//
//  TYModuleHookRegisterProtocol.h
//  TYModuleManager
//
//  Created by TuyaInc on 2019/5/14.
//

#import <Foundation/Foundation.h>

#import "TYModuleHookInfo.h"

NS_ASSUME_NONNULL_BEGIN

@protocol TYModuleHookRegisterProtocol <NSObject>

- (NSArray<TYModuleHookInfo *> *)registModuleHooks;

@end

NS_ASSUME_NONNULL_END
