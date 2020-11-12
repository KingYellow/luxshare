//
//  TYModuleRegisterProtocol.h
//  TYModuleManager
//
//  Created by TuyaInc on 2019/5/11.
//

#import "TYModuleServiceRegisterProtocol.h"
#import "TYModuleRouteRegisterProtocol.h"
#import "TYModuleTabRegisterProtocol.h"
#import "TYModuleNotifyRegisterProtocol.h"
#import "TYModuleLaunchTaskRegisterProtocol.h"
#import "TYModuleHookRegisterProtocol.h"
// Callback
#import "TYModuleLifeCycleCallbackProtocol.h"

@protocol TYModuleRegisterProtocol <TYModuleServiceRegisterProtocol, TYModuleRouteRegisterProtocol, TYModuleTabRegisterProtocol, TYModuleNotifyRegisterProtocol, TYModuleLaunchTaskRegisterProtocol>
@end
