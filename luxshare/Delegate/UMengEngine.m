//
//  UMengEngine.m
//  luxshare
//
//  Created by 黄振 on 2020/6/23.
//  Copyright © 2020 KingYellow. All rights reserved.
//

#import "UMengEngine.h"
#import <UserNotifications/UserNotifications.h>
#import <UIKit/UIKit.h>
#import <UMPush/UMessage.h>
//#import "NSString+MD5.h"
NSString* const UMAppId   = @"DYnk783NKvAQXg7cW4VsCA";
NSString* const UMAppKey  = @"ippD23s5vyAYHr2fFaPLF3";
NSString* const UMAppSecrt  = @"b17sMq677EA6usvtNTLha1";

@interface UMengEngine() <UNUserNotificationCenterDelegate>

@end

@implementation UMengEngine

+(instancetype)umengInstance {
    static UMengEngine *uMeng = nil;
    if (uMeng == nil) {
        uMeng = [[UMengEngine alloc] init];
    }

    return uMeng;
}

+(void)closePush {
//    [GeTuiSdk setPushModeForOff:NO];
}

+(void)startPush {
//    [GeTuiSdk setPushModeForOff:YES];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        //注册推送
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 10) {
            UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
            center.delegate = self;

            UNAuthorizationOptions options = UNAuthorizationOptionAlert|UNAuthorizationOptionBadge|UNAuthorizationOptionSound;
            [center requestAuthorizationWithOptions:options completionHandler:^(BOOL granted, NSError * _Nullable error) {
                if (granted) {

                }
            }];
        } else {
            UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil];
            [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        }
        [[UIApplication sharedApplication] registerForRemoteNotifications];
//        [GeTuiSdk startSdkWithAppId:UmAppId appKey:UMAppKey appSecret:UMAppSecrt delegate:self];
    }
    return self;
}

//注册token
-(void)umRemoteDeviceToken:(NSData *)deviceToken {
    NSString *token = [[[[deviceToken description] stringByReplacingOccurrencesOfString:@"<"withString:@""]
                        stringByReplacingOccurrencesOfString:@">" withString:@""]
                       stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"token ==== %@",token);
//    [GeTuiSdk registerDeviceToken:token];
}

- (void)umDidReceiveRemoteNotification:(NSDictionary *)userinfo {
//    [GeTuiSdk handleRemoteNotification:userinfo];
}

-(void)umApplicationDidBecomeActive {
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:1];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {

    completionHandler(UNNotificationPresentationOptionAlert|UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound);
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {

//    [GeTuiSdk handleRemoteNotification:response.notification.request.content.userInfo];
    completionHandler();
}

- (void)GeTuiSdkDidRegisterClient:(NSString *)clientId {
    //绑定别名
//    NSString *otherName = [[NSString stringWithFormat:@"%@meiqing",[UserInfo readValueForKey:User_phone]] getMD5];
//    [GeTuiSdk bindAlias:otherName andSequenceNum:@"qqq"];
//    NSLog(@"%@",otherName);//    [UserDef setObject:clientId forKey:@"cid"];
    [self submitCid];
}

- (void)GeTuiSdkDidReceivePayloadData:(NSData *)payloadData andTaskId:(NSString *)taskId andMsgId:(NSString *)msgId andOffLine:(BOOL)offLine fromGtAppId:(NSString *)appId {
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:payloadData options:NSJSONReadingAllowFragments error:nil];
    //    if ([dict[@"type"] integerValue] == 5) {
//    [UIAlertController showAlertVC:nil title:dict[@"title"] subTitle:dict[@"content"] okTitle:@"确定" complete:nil];
//    [UIAlertController showAlertVC:nil title:dict[@"title"] subTitle:dict[@"content"] okTitle:@"确定" complete:^{
//        JBTDetailBigSizeViewController *vc = [[JBTDetailBigSizeViewController alloc] init];
//        vc.serial = dict[@"serial"];
//        [[UIApplication sharedApplication].delegate.window.rootViewController.navigationController pushViewController:[vc hiddenBottomVC] animated:YES];
//    }];
//    NSLog(@"%@", dict);
//    //    }
}

- (void)submitCid {
//    NSString *cid = [UserDef objectForKey:@"cid"];
//    if (!cid) {
//        return;
//    }
//    [[YMNetworking shareNetwork] postUrl:[JBTHomeApi string:PushCid] params:@{@"cid":cid, @"device_type":@2} success:^(NSDictionary * _Nullable resp) {
//        NSLog(@"提交cid成功");
//    } failed:^(NSError * _Nullable error) {
//        NSLog(@"提交cid
}

/** SDK遇到错误回调 */
- (void)GeTuiSdkDidOccurError:(NSError *)error {
    NSString* sdkErrorInfo = [NSString stringWithFormat:@">>>[GexinSdk error]:%@", [error localizedDescription]];
    NSLog(@"sdkErrorInfo : %@", sdkErrorInfo);
}
@end
