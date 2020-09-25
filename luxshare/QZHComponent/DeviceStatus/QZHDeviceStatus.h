//
//  QZHDeviceStatus.h
//  luxshare
//
//  Created by 黄振 on 2020/9/14.
//  Copyright © 2020 KingYellow. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QZHDeviceStatus : NSObject
//设备是否在线
+ (BOOL)deviceIsOnline:(TuyaSmartDeviceModel *)deviceModel;

//是否是分享设备
+ (BOOL)deviceIsShared:(TuyaSmartDeviceModel *)deviceModel;

//设备供电类型  电池(YES)/常电(NO)版
+ (BOOL)deviceIsBattery:(TuyaSmartDeviceModel *)deviceModel;

//账号注册类型  电池(YES)/常电(NO)版
+ (BOOL)accountTypeOfRegist:(TuyaSmartDeviceModel *)deviceModel;

@end

NS_ASSUME_NONNULL_END
