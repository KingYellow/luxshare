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

//摄像头设备供电类型  电池(YES)/常电(NO)版
+ (BOOL)deviceIsBattery:(TuyaSmartDeviceModel *)deviceModel;
//设备类型  
+ (DeviceType)deviceType:(TuyaSmartDeviceModel *)deviceModel;

//账号注册类型  邮箱/手机号
//+ (BOOL)accountTypeOfRegist:(TuyaSmartDeviceModel *)deviceModel;

@end

NS_ASSUME_NONNULL_END
