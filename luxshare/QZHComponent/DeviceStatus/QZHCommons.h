//
//  QZHCommons.h
//  luxshare
//
//  Created by 黄振 on 2020/10/13.
//  Copyright © 2020 KingYellow. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QZHCommons : NSObject

//手机系统语言
+ (SystemLanguageType)languageOfTheDeviceSystem;

//是否是管理员
+ (BOOL)isAdminOrOwner:(TuyaSmartHomeModel *)homeModel;

//是否是分享设备
+ (BOOL)isSharedDevice:(TuyaSmartDeviceModel *)deviceModel;


@end

NS_ASSUME_NONNULL_END
