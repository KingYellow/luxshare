//
//  QZHCommons.m
//  luxshare
//
//  Created by 黄振 on 2020/10/13.
//  Copyright © 2020 KingYellow. All rights reserved.
//

#import "QZHCommons.h"

@implementation QZHCommons
+ (SystemLanguageType)languageOfTheDeviceSystem{
    NSArray *languages = [NSLocale preferredLanguages];
    NSString *currentLanguage = [languages objectAtIndex:0];
    if ([currentLanguage isEqualToString:@"zh-Hans-CN"]){
        return LanguageChinese;
    }else if([currentLanguage isEqualToString:@"en"]){
        return  LanguageEnglish;;
    }else{
        return  LanguageEnglish;;
    }
}
//是否是管理员
+ (BOOL)isAdminOrOwner:(TuyaSmartHomeModel *)homeModel{
    if (homeModel.role == TYHomeRoleType_Admin || homeModel.role == TYHomeRoleType_Owner) {
        return YES;
    }
    return NO;
}

//是否是分享设备
+ (BOOL)isSharedDevice:(TuyaSmartDeviceModel *)deviceModel{
    return deviceModel.isShare;
}
@end
