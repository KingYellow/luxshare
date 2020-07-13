//
//  QZHKitHelper.m
//  DDSample
//
//  Created by 黄振 on 2020/3/30.
//  Copyright © 2020 KingYellow. All rights reserved.
//

#import "QZHKitHelper.h"

@interface QZHKitHelper () <UITabBarControllerDelegate>

@end

@implementation QZHKitHelper

+(instancetype)kitHelper {
    static QZHKitHelper *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[QZHKitHelper alloc] init];
    });
    
    return instance;
}

///ui相关配置
- (void)configKit {
    [UINavigationBar appearance].translucent = NO;
    [UINavigationBar appearance].tintColor = QZHColorWhite;
    [[UINavigationBar appearance] setBackgroundImage:QZHLoadIcon(QZHICON_NAVI_BACK) forBarMetrics:UIBarMetricsDefault];
    [UINavigationBar appearance].titleTextAttributes = @{NSForegroundColorAttributeName:QZHColorWhite};
  
    //系统返回按钮title隐藏
    if (QZHiPhoneX) {
        [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor clearColor]} forState:UIControlStateNormal];
    } else {
        [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(-QZHScreenWidth, -QZHScreenHeight) forBarMetrics:UIBarMetricsDefault];
    }
    
    //设置emptyView全局属性
    [EasyEmptyGlobalConfig shared].bgColor = QZHColorGray;
    [EasyEmptyGlobalConfig shared].titleColor = QZHColorWhite;
    [EasyEmptyGlobalConfig shared].tittleFont = QZHTEXT_FONT(15);
    [EasyEmptyGlobalConfig shared].subTitleColor = QZHColorWhite;
    [EasyEmptyGlobalConfig shared].subtitleFont = QZHTEXT_FONT(13);
    [EasyEmptyGlobalConfig shared].buttonFont = QZHTEXT_FONT(13);
    [EasyEmptyGlobalConfig shared].buttonColor = QZHColorBlue;
    [EasyEmptyGlobalConfig shared].buttonBgColor = QZHColorWhite;
}

///网络服务配置
- (void)configNetwork {
    //网络请求默认参数配置
    [QZHNetworkConfig globalCofig].severHost = QZHApiHost;
    //请求方式配置
    [QZHNetworkConfig globalCofig].requestMethod = QZHRequestMethodPOST;
    //请求数据格式
    [QZHNetworkConfig globalCofig].requestFormat = QZHRequestFormatForm;
    ///超时时间
    [QZHNetworkConfig globalCofig].timeoutInterval = 20;
    //响应数据格式
    [QZHNetworkConfig globalCofig].responeFormat = QZHResponeFormatJSON;
    [QZHNetworkConfig globalCofig].headerFields[@"language"] = @"pt";
    [QZHNetworkConfig globalCofig].headerFields[@"lastLoginVersion"] = [self jk_version];
    [QZHNetworkConfig globalCofig].headerFields[@"lastLoginOs"] = [NSString stringWithFormat:@"iOS %@", [UIDevice currentDevice].systemVersion];
    [QZHNetworkConfig globalCofig] .headerFields[@"lastLoginMobile"] = [UIDevice jk_platformString];
    
    //请求时动作
    [QZHNetworkConfig globalCofig].requestAction = ^(QZHNetworkConfig *config) {
        //显示loading
//        if (config.showHDU) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [[QZHHUD HUD] loadingHUDWithImage:@"loading"];
//            });
//        }
        //全局参数
        config.headerFields[@"token"] = [QZHDataHelper readValueForKey:QZHKEY_TOKEN];
        config.headerFields[@"Authorization"] = [QZHDataHelper readValueForKey:QZHKEY_TOKEN];
    };
    //响应动作
    [QZHNetworkConfig globalCofig].responeAction = ^(QZHRespModel *model) {
        //隐藏loading
//        if (model.config.showHDU) {
//            [[QZHHUD HUD] hiddenHUD];
//        }
        if (model.status.integerValue == 403) {
            //token失效退出
            [QZHDataHelper removeForKey:QZHKEY_TOKEN];
            [QZHDataHelper removeForKey:QZHKEY_USER];
            [QZHROOT_DELEGATE setVC];
        }

    };
}

///创建tabbarvc
- (UITabBarController *)buildTabbarVC {
    UITabBarController *tabVC = [[UITabBarController alloc] init];
    
    tabVC.tabBar.translucent = NO;
    tabVC.delegate = self;
    tabVC.tabBar.barTintColor = QZHKIT_COLOR_TABBAR_BACK;
    UIImageView *lineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, QZHScreenWidth, 1)];
    lineView.image = QZHLoadIcon(@"tabbar");
    [tabVC.tabBar addSubview:lineView];
    
    for (int i = 0; i < QZHKitHelper.kitHelper.tabbarElements.count; i++) {
        UIViewController *vc = QZHKitHelper.kitHelper.tabbarElements[i];
        
        [tabVC addChildViewController:[vc exp_addNavigation]];
        UITabBarItem *barItem = vc.tabBarItem;
        
        NSString *imgdefStr = QZHKitHelper.kitHelper.tabbarNomarlIcons[i];
        NSString *imgchkStr = QZHKitHelper.kitHelper.tabbarSelectedIcons[i];
        
        //文字位置
//        barItem.titlePositionAdjustment = UIOffsetMake(0, -3);
        //设置文字及颜色
        barItem.title = QZHKitHelper.kitHelper.tabbarTitles[i];
        [barItem setTitleTextAttributes:@{NSForegroundColorAttributeName:QZHKIT_COLOR_TABBAR_TITLE_NORMAL, NSFontAttributeName:QZHTEXT_FONTBold(12)} forState:UIControlStateNormal];
        [barItem setTitleTextAttributes:@{NSForegroundColorAttributeName:QZHKIT_COLOR_TABBAR_TITLE_SELECTED, NSFontAttributeName:QZHTEXT_FONTBold(12)} forState:UIControlStateSelected];
        
        //设置默认图片
        barItem.image = [[UIImage imageNamed:imgdefStr] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        //设置选中图片
        barItem.selectedImage = [[UIImage imageNamed:imgchkStr] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    
    return tabVC;
}

///tabbar的代理，这里可以添加选中时的操作
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    
    return YES;
}

#pragma mark setter
- (void)setStatusBarStyle:(UIBarStyle)barStyle{
    _statusBarStyle = barStyle;
    [[self exp_getCurrentVC].navigationController.navigationBar setBarStyle:_statusBarStyle];
}
@end
