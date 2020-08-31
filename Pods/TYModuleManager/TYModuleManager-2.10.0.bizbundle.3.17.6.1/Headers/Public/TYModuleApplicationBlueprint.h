//
//  TYModuleApplicationProtocol.h
//  TYModuleManager
//
//  Created by TuyaInc on 2018/8/21.
//

#import <Foundation/Foundation.h>

#import "TYModuleBaseBlueprint.h"

@protocol TYModuleConfigBlueprint;

NS_ASSUME_NONNULL_BEGIN

@protocol TYModuleApplicationBlueprint <TYModuleBaseBlueprint, UIApplicationDelegate>

@required
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(nullable NSDictionary *)launchOptions;

/**
 reload the root view controller of key window
 */
- (void)reloadRootViewController;

/**
 reset the root view controller of key window to a specified view controller
 */
- (void)resetRootViewController:(__kindof UIViewController *)rootVC;

/**
 the root view controller of key window
 */
- (__kindof UIViewController *)currentRootViewController;

@optional
/**
 you need to create a window and set to [UIApplication sharedApplication].delegate.window
 when [UIApplication sharedApplication].delegate.window == nil
 */
- (UIWindow *)window;

/**
 allow TYModuleManager to open route
 */
- (BOOL)shouldOpenRouteWithScheme:(NSString *)scheme host:(NSString *)host path:(NSString *)path params:(NSDictionary *)params;

@end

NS_ASSUME_NONNULL_END
