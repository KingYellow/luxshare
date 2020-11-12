//
//  TYModuleServiceRegisterProtocol.h
//  TYModuleManager
//
//  Created by TuyaInc on 2018/8/30.
//

#import <Foundation/Foundation.h>

#import "TYModuleServiceInfo.h"

@protocol TYModuleServiceRegisterProtocol <NSObject>

@optional
- (NSArray<TYModuleServiceInfo *> *)registModuleServices;

@end
