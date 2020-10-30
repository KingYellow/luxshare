//
//  QZHAppCheck.m
//  MYM
//
//  Created by 米翊米 on 2017/8/30.
//  Copyright © 2017年 miyimi. All rights reserved.
//

#import "QZHAppCheck.h"
#import <UIKit/UIKit.h>

@implementation QZHAppCheck

+ (void)updateCheckAppID:(NSString *)appstoreID {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [[QZHNetWorkRequest shareResuest] fetchConfigBlock:^(QZHNetworkConfig *config) {
            // AppStore地址(字符串)
            NSString *path = [NSString stringWithFormat:@"http://itunes.apple.com/cn/lookup?id=%@", appstoreID];
            
            config.severHost = path;
            config.showHDU = NO;
        } result:^(QZHRespModel *model) {
            NSString *currentVersion = [NSBundle.mainBundle infoDictionary][@"CFBundleShortVersionString"];
            NSDictionary *response = model.responseObject;
            if ([response[@"resultCount"] integerValue] > 0) {
                NSArray *array = response[@"results"];
                NSString *version = [array firstObject][@"version"];
                if ([currentVersion compare:version] == NSOrderedAscending) {
                    UIAlertController *vc = [UIAlertController alertControllerWithTitle:QZHLoaclString(@"versionUpdate") message:QZHLoaclString(@"newAppVersion") preferredStyle:UIAlertControllerStyleAlert];
                    
                    [vc addAction:[UIAlertAction actionWithTitle:QZHLoaclString(@"cancel") style:(UIAlertActionStyleCancel) handler:nil]];
                    [vc addAction:[UIAlertAction actionWithTitle:QZHLoaclString(@"update") style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                        NSString *url = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@?mt=8", appstoreID];
                        if (@available(iOS 10.0, *)) {
                            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url] options:@{} completionHandler:nil];
                        } else {
                            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
                        }
                        exit(0);
                    }]];
                    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:vc animated:YES completion:nil];
                }
            }
        }];
    });
}

@end
