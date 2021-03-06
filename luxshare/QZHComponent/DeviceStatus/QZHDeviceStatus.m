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

//设备供电类型  电池/常电版
+ (BOOL)deviceIsBattery:(TuyaSmartDeviceModel *)deviceModel{
    
    return [deviceModel.productId isEqualToString:BATTERY_PRODUCT_ID_HS] || [deviceModel.productId isEqualToString:BATTERY_PRODUCT_ID] || [deviceModel.productId isEqualToString:DOORbell_PRODUCT_ID] ||[deviceModel.productId isEqualToString:DOORbell_PRODUCT_ID_HS];
}

//设备类型
+ (DeviceType)deviceType:(TuyaSmartDeviceModel *)deviceModel{
    if ([deviceModel.productId isEqualToString:DOORbell_PRODUCT_ID_HS] ||[deviceModel.productId isEqualToString:DOORbell_PRODUCT_ID]) {
        return DoorbellDevice;
    }else if([deviceModel.productId isEqualToString:BATTERY_PRODUCT_ID_HS] || [deviceModel.productId isEqualToString:BATTERY_PRODUCT_ID]){
        return IPCamBatteryDevice;
    }else if([deviceModel.productId isEqualToString:PTZ_PRODUCT_ID_LIST] || [deviceModel.productId isEqualToString:PTZ_PRODUCT_ID_LIST_T31]){
        return IPCamPTZDevice;
    }else{
        return IPCamACDevice;
    }
}
@end
