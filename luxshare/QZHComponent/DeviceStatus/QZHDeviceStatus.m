//
//  QZHDeviceStatus.m
//  luxshare
//
//  Created by 黄振 on 2020/9/14.
//  Copyright © 2020 KingYellow. All rights reserved.
//

#import "QZHDeviceStatus.h"

@implementation QZHDeviceStatus

//设备是否在线
+ (BOOL)deviceIsOnline:(TuyaSmartDeviceModel *)deviceModel{
   
   TuyaSmartDevice *device = [TuyaSmartDevice deviceWithDeviceId:deviceModel.devId];
    TuyaSmartDeviceModel *lastModel = device.deviceModel;
    return lastModel.isOnline;
}

//是否是分享设备
+ (BOOL)deviceIsShared:(TuyaSmartDeviceModel *)deviceModel{
   
   TuyaSmartDevice *device = [TuyaSmartDevice deviceWithDeviceId:deviceModel.devId];
    TuyaSmartDeviceModel *lastModel = device.deviceModel;
    return lastModel.isShare;
}

//设备供电类型  电池(YES)/常电(NO)版
+ (BOOL)deviceIsBattery:(TuyaSmartDeviceModel *)deviceModel{
    
    return [deviceModel.productId isEqualToString:BATTERY_PRODUCT_ID];
    
}
@end
