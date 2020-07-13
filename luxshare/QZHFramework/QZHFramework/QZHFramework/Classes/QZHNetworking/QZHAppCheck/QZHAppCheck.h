//
//  QZHAppCheck.h
//  MYM
//
//  Created by 米翊米 on 2017/8/30.
//  Copyright © 2017年 miyimi. All rights reserved.
//

#import "QZHNetWorkRequest.h"

@interface QZHAppCheck : NSObject

/// 检测版本更新 传入appid
+ (void)updateCheckAppID:(NSString *)appstoreID;

@end
