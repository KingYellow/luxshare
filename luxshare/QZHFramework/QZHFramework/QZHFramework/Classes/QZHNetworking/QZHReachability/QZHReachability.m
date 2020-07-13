//
//  QZHReachability.m
//  Demo
//
//  Created by 米翊米 on 2018/5/25.
//  Copyright © 2018年 米翊米. All rights reserved.
//

#import "QZHReachability.h"
#import "AFNetworking.h"

@implementation QZHReachability

///网络状态监测
+ (void)reachability:(NetworkStatusHandler)statusChange {
    // 如果要检测网络状态的变化,必须用检测管理器的单例的startMonitoring
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    // 检测网络连接的单例,网络变化时的回调方法
    [[AFNetworkReachabilityManager sharedManager]setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        NSLog(@"%ld",(long)status);
        QZHNetworkStatus qzhStatus;
        NSString *describe = @"";
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                NSLog(@"网络错误");
                qzhStatus = QZHNetworkStatusUnkown;
                describe = @"网络错误";
                break;
            case AFNetworkReachabilityStatusNotReachable:
                NSLog(@"没有连接网络");
                describe = @"网路无连接";
                qzhStatus = QZHNetworkStatusNotReachable;
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                NSLog(@"手机自带网络");
                describe = @"运营商网络";
                qzhStatus = QZHNetworkStatusReachableViaWWAN;
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                NSLog(@"wifi");
                describe = @"WiFi网络";
                qzhStatus = QZHNetworkStatusReachableViaWiFi;
                break;
        }
        if (statusChange) {
            statusChange(qzhStatus, describe);
        }
    }];
}

@end
