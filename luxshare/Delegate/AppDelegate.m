//
//  AppDelegate.m
//  luxshare
//
//  Created by 黄振 on 2020/6/22.
//  Copyright © 2020 KingYellow. All rights reserved.
//

#import "AppDelegate.h"
#import "AppDelegate+Exp.h"
@interface AppDelegate ()
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self exp_application:application didFinishLaunchingWithOptions:launchOptions];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    
    [self exp_applicationWillResignActive:application];

}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    [self exp_applicationDidEnterBackground:application];
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    [self exp_applicationWillEnterForeground:application];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [self exp_applicationDidBecomeActive:application];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [self exp_applicationWillTerminate:application];
}

#pragma mark -- 推送
//注册 PushId
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [TuyaSmartSDK sharedInstance].deviceToken = deviceToken;
}

//接收到远程通知
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void(^)(UIBackgroundFetchResult))completionHandler {

}
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
    
}

-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler{
    
    self.tabVC.selectedIndex = 1;

}
@end
