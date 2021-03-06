//
//  AppDelegate+Exp.m
//  DDSample
//
//  Created by 黄振 on 2020/3/30.
//  Copyright © 2020 KingYellow. All rights reserved.
//

#import "AppDelegate+Exp.h"
#import "QZHFramework.h"
#import "IQKeyboardManager.h"
#import <Bugly/Bugly.h>
#import "DoorbellVC.h"

#define APP_TUYA_KEY @"etfsf3cknjdufuxj5ed3"
#define APP_TUYA_SECRET_KEY @"qqupn84qgsawka95tnhgrhkcvndnfkua"
#define APP_BUGLY_ID @"ef3aec3356"
#define APP_BUGLY_KEY @"618cd2a8-e7d6-4316-bbb3-3aea50d4472d"
#define QZHAcAppStoreID @""

#define kTuyaDoorbellNotification @"kNotificationMQTTMessageNotification"

@implementation AppDelegate (Exp)
//- 启动配置
- (BOOL)exp_application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [Bugly startWithAppId:APP_BUGLY_ID];

    [[TuyaSmartSDK sharedInstance] startWithAppKey:APP_TUYA_KEY secretKey:APP_TUYA_SECRET_KEY];
//#ifdef DEBUG
//    [[TuyaSmartSDK sharedInstance] setDebugMode:YES];
//#else
//#endif
    
    [application registerForRemoteNotifications];
    [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];

    if (@available(iOS 10.0, *)) {
        //iOS10需要加下面这段代码。
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];

        center.delegate = self;
        UNAuthorizationOptions types10 = UNAuthorizationOptionBadge|UNAuthorizationOptionAlert|UNAuthorizationOptionSound;
        [center requestAuthorizationWithOptions:types10 completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (granted) {
                //点击允许
            } else {
                //点击不允许
            }
        }];
    }
//    [TYCameraCloudServicePanelSDK setupWithAppScheme:@"your_scheme"];

    [self loadNotification];
    [self observeDoorbellCall:^(NSString *devId, NSString *type) {
            
    }];
    
    if (@available(iOS 11.0, *)) {
        [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIApplicationBackgroundFetchIntervalNever];
        [[UITableView appearance] setEstimatedRowHeight:0.f];
        [[UITableView appearance] setEstimatedSectionHeaderHeight:0.f];
        [[UITableView appearance] setEstimatedSectionFooterHeight:0.f];
    }
    IQKeyboardManager.sharedManager.enable = YES;

    //设置根视图
    [self setVC];

    //更新版本检测
      [QZHAppCheck updateCheckAppID:QZHAcAppStoreID];
    
    //配置UI全局
    [QZHKitHelper.kitHelper configKit];
    
    //添加数据存储白名单
    [QZHDataHelper addWhiteList:QZHKEY_PUSHOPEN];
    [QZHDataHelper addWhiteList:QZHKEY_DEVICE_TOKEN];
    
    ///监控网络状态
    [QZHReachability reachability:^(QZHNetworkStatus status, NSString *describe) {
        if (status == QZHNetworkStatusNotReachable) {
            //TODO: 无网络
            
        } else if (status == QZHNetworkStatusReachableViaWiFi || status == QZHNetworkStatusReachableViaWWAN) {
            //TODO: 有网络
               
        }
    }];

    [self.window makeKeyAndVisible];
    return YES;
}

//- 程序获取焦点(即应用被显示)
- (void)exp_applicationDidBecomeActive:(UIApplication *)application {
    if ([[UIApplication sharedApplication] currentUserNotificationSettings].types != UIUserNotificationTypeNone) {
        [QZHDataHelper saveValue:@YES forKey:QZHKEY_PUSHOPEN];
    } else {
        [QZHDataHelper removeForKey:QZHKEY_PUSHOPEN];
    }
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

//- 程序进入后台
- (void)exp_applicationDidEnterBackground:(UIApplication *)application {
    
}

//- 程序失去焦点
- (void)exp_applicationWillResignActive:(UIApplication *)application {
    ///保存用户书数据
    [QZHDataHelper saveValue:QZHUserModel.User forKey:QZHKEY_USER];
}

//- 程序从后台回到前台
- (void)exp_applicationWillEnterForeground:(UIApplication *)application {
    
}

//- 程序内存警告，可能要终止程序
- (void)exp_applicationDidReceiveMemoryWarning:(UIApplication *)application {
    ///保存用户书数据
    [QZHDataHelper saveValue:QZHUserModel.User forKey:QZHKEY_USER];
}

//- 程序即将退出
- (void)exp_applicationWillTerminate:(UIApplication *)application {
    ///保存用户书数据

    [QZHDataHelper saveValue:QZHUserModel.User forKey:QZHKEY_USER];
}

///Universal Links唤醒
- (BOOL)exp_application:(UIApplication*)application continueUserActivity:(NSUserActivity*)userActivity restorationHandler:(void(^)(NSArray* _Nullable))restorationHandler {
    
    return YES;
}

///openurl
- (BOOL)exp_application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *, id> *)options {
    //TODO: APP被其他应用打开
//    BOOL result = [QZHSocial socialApplication:app openURL:url options:options];
//
//    //BatteryOAM2018://link?key=1&value=xxxxx
//    if ([url.absoluteString hasPrefix:@"xxx"]) {
//
//    }
    
    return YES;
}

- (void)onConversionDataReceived:(NSDictionary*) installData {
    //Handle Conversion Data (Deferred Deep Link)
    NSLog(@"installData = %@", installData);
}

- (void)onConversionDataRequestFailure:(NSError *) error {
    NSLog(@"error = %@",error);
}


- (void)onAppOpenAttribution:(NSDictionary*) attributionData {
    //Handle Deep Link
    NSLog(@"installData = %@", attributionData);
}

- (void)onAppOpenAttributionFailure:(NSError *)error {
    NSLog(@"%@",error);
}

#pragma mark - rootvc

- (void)setVC {
    if (!QZHDataRead(QZHKKEY_FIRST_INSTALL)) {//是否是第一次安装打开
        //标记已经安装打开
        QZHDataSave(@YES, QZHKKEY_FIRST_INSTALL);
        [self showLeadVC];
    } else {
        if ([QZHDataHelper readValueForKey:QZHKEY_TOKEN]) {
                [self showTabbarVC];
            } else {//这里设置登陆后根视图
                [self showLoginVC];
            }
    }

}
///显示引导页
- (void)showLeadVC{
    TOTANewFeatureVC  *vc = [TOTANewFeatureVC new];
    self.window.rootViewController = vc;
}

///显示登录视图
- (void)showLoginVC {
   DDLoginVC *vc = [[DDLoginVC alloc] init];
   UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
   self.window.rootViewController = nav;
   [self.window makeKeyAndVisible];
}

///显示TabbarVC视图
- (void)showTabbarVC {
    [QZHKitHelper.kitHelper configNetwork];
    
    self.window.rootViewController = nil;
    self.window.rootViewController = [self createTbbarVC];
}
- (void)showFamilyVC {
   FirstRegistAddHomeVC *vc = [[FirstRegistAddHomeVC alloc] init];
   UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
   self.window.rootViewController = nav;
   [self.window makeKeyAndVisible];
}
//


#pragma mark --初始化tabar
/**
 初始化tabbar
 */

- (UITabBarController *)createTbbarVC {
    self.tabVC = [[UITabBarController alloc] init];
    self.tabVC.tabBar.translucent = NO;
    self.tabVC.delegate = self;
    self.tabVC.tabBar.barTintColor = QZHKIT_COLOR_TABBAR_BACK;
    
    HomeVC *vc1 = [[HomeVC alloc] init];
    MessageVC *vc2 = [[MessageVC alloc] init];
    MineVC *vc3 = [[MineVC alloc] init];
    
    NSArray *viewControllers = @[[vc1 exp_addNavigation], [vc2 exp_addNavigation], [vc3 exp_addNavigation]];
    self.tabVC.viewControllers = viewControllers;
    
    NSArray *titleArray = @[QZHLoaclString(@"home"), QZHLoaclString(@"message"), QZHLoaclString(@"mine")];
    NSArray *defImages = @[@"home", @"book", @"mine"];
    NSArray *chkImages = @[@"home_1", @"book_1", @"mine_1"];
    
    for (int i = 0; i <viewControllers.count; i++) {
        UITabBarItem *barItem = ((UIViewController *)viewControllers[i]).tabBarItem;
        
        NSString *imgdefStr = defImages[i];
        NSString *imgchkStr = chkImages[i];
        
        //设置文字及颜色
        barItem.title = titleArray[i];
        [barItem setTitleTextAttributes:@{NSForegroundColorAttributeName:QZHKIT_COLOR_TABBAR_TITLE_NORMAL} forState:UIControlStateNormal];
        [barItem setTitleTextAttributes:@{NSForegroundColorAttributeName:QZHKIT_COLOR_TABBAR_TITLE_SELECTED} forState:UIControlStateSelected];
        
        //设置默认图片
        barItem.image = [[UIImage imageNamed:imgdefStr] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        //设置选中图片
        barItem.selectedImage = [[UIImage imageNamed:imgchkStr] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        barItem.titlePositionAdjustment = UIOffsetMake(0, -2);
        barItem.imageInsets=UIEdgeInsetsMake(-1,0,1,0);
    }
    return self.tabVC;
}

- (void)loadNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sessionInvalid) name:TuyaSmartUserNotificationUserSessionInvalid object:nil];
}


- (void)observeDoorbellCall:(void(^)(NSString *devId, NSString *type))callback {
    if (!callback) {
        return;
    }
      // 监听门铃呼叫的通知
    [[NSNotificationCenter defaultCenter] addObserverForName:kTuyaDoorbellNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
        NSDictionary *eventInfo = note.object;
        NSString *devId = eventInfo[@"devId"];
        NSString *eType = [eventInfo objectForKey:@"etype"];
        if ([eType isEqualToString:@"doorbell"]) {
            callback(devId, eType);
            DoorbellVC *vc = [[DoorbellVC alloc] init];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
            vc.modalPresentationStyle = UIModalPresentationOverFullScreen;
            vc.eventInfo = eventInfo;
            [self.window.rootViewController presentViewController:nav animated:YES completion:nil];
        }
    }];
}

- (void)sessionInvalid {
        //跳转至登录页面
    [self showLoginVC];
    
}

@end
