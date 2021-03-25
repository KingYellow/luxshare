//
// TuyaSmartMessageSetting.h
// TuyaSmartMessageKit
//
// Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com)

#import <Foundation/Foundation.h>
#import <TuyaSmartBaseKit/TuyaSmartBaseKit.h>
#import "TuyaSmartMessageRequestModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TuyaSmartMessageSetting : NSObject

/// 设置设备消息免打扰开关 set device Do Not Disturb status
/// @param flags 开关状态 switch status
/// @param success 成功回调 success
/// @param failure 失败回调 failure
- (void)setDeviceDNDSettingStatus:(BOOL)flags success:(TYSuccessHandler)success failure:(TYFailureError)failure;

/// 获取设备消息免打扰状态 get device Do Not Disturb status
/// @param success 成功回调 success
/// @param failure 失败回调 failure
- (void)getDeviceDNDSettingstatusSuccess:(TYSuccessBOOL)success failure:(TYFailureError)failure;

/// 获取免打扰时间段列表 get Do Not Disturb list
/// @param success 成功回调 success
/// @param failure 失败回调 failure
- (void)getDNDListSuccess:(TYSuccessList)success failure:(TYFailureError)failure;

/// 获取设备列表 get device list
/// @param success 成功回调 success
/// @param failure 失败回调 failure
- (void)getDNDDeviceListSuccess:(TYSuccessList)success failure:(TYFailureError)failure;

/// 添加设备免打扰时间段 add device  Do Not Disturb time
/// @param requestModel 免打扰设置模型 DND request model
/// @param success 成功回调 success
/// @param failure 失败回调 failure
- (void)addDNDWithDNDRequestModel:(TuyaSmartMessageSettingDNDRequestModel *)requestModel success:(TYSuccessHandler)success failure:(TYFailureError)failure;

/// 更新设备免打扰时间段 modify device  Do Not Disturb time
/// @param timerID 时间ID time ID
/// @param requestModel 免打扰设置模型 DND request model
/// @param success 成功回调 success
/// @param failure 失败回调 failure
- (void)modifyDNDWithTimerID:(long)timerID DNDRequestModel:(TuyaSmartMessageSettingDNDRequestModel *)requestModel success:(TYSuccessHandler)success failure:(TYFailureError)failure;

/// 移除设置的免打扰时间段 remove Do Not Disturb time
/// @param timerID 时间ID time ID
/// @param success 成功回调 success
/// @param failure 失败回调 failure
- (void)removeDNDWithTimerID:(long)timerID success:(TYSuccessHandler)success failure:(TYFailureError)failure;

@end

NS_ASSUME_NONNULL_END
