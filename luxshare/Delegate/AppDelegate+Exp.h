//
//  AppDelegate+Exp.h
//  DDSample
//
//  Created by 黄振 on 2020/3/30.
//  Copyright © 2020 KingYellow. All rights reserved.
//


#import "AppDelegate.h"


NS_ASSUME_NONNULL_BEGIN

@interface AppDelegate (Exp)<UITabBarControllerDelegate>


///设置根视图
- (void)setVC;
//没有家庭s时显示
- (void)showFamilyVC;

///设置列表模式 根视图
//- (void)rootMListVC;

///- 启动配置
- (BOOL)exp_application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;

///- 程序获取焦点(即应用被显示)
- (void)exp_applicationDidBecomeActive:(UIApplication *)application;

///- 程序进入后台
- (void)exp_applicationDidEnterBackground:(UIApplication *)application;

///- 程序失去焦点
- (void)exp_applicationWillResignActive:(UIApplication *)application;

///- 程序从后台回到前台
- (void)exp_applicationWillEnterForeground:(UIApplication *)application;

///Universal Links唤醒
-(BOOL)exp_application:(UIApplication*)application continueUserActivity:(NSUserActivity*)userActivity restorationHandler:(void(^)(NSArray* _Nullable))restorationHandler;

///- 程序内存警告，可能要终止程序
-(void)exp_applicationDidReceiveMemoryWarning:(UIApplication *)application;

///- 程序即将退出
- (void)exp_applicationWillTerminate:(UIApplication *)application;

///openurl
- (BOOL)exp_application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *, id> *)options;

@end

NS_ASSUME_NONNULL_END
