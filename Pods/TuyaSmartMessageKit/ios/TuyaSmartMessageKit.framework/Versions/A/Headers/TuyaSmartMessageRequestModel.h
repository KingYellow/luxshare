//
// TuyaSmartMessageRequestModel.h
// TuyaSmartMessageKit
//
// Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com)

#import <Foundation/Foundation.h>
#import "TuyaSmartMessageUtils.h"

NS_ASSUME_NONNULL_BEGIN

/// Message center message list request model.
@interface TuyaSmartMessageListRequestModel : NSObject

/// Message type.
@property (nonatomic, assign) TYMessageType msgType;

/// Limit count.
@property (nonatomic, assign) NSInteger limit;

@property (nonatomic, assign) NSInteger offset;

@end

/// Message center message detail list request model.
@interface TuyaSmartMessageDetailListRequestModel : NSObject

/// Message type (Currently only supported TYMessageTypeAlarm).
@property (nonatomic, assign) TYMessageType msgType;

/// Limit count.
@property (nonatomic, assign) NSInteger limit;

@property (nonatomic, assign) NSInteger offset;

/// Message device ID.
@property (nonatomic, copy) NSString *msgSrcId;

@end

@interface TuyaSmartMessageListDeleteRequestModel : NSObject
/// Message type.
@property (nonatomic, assign) TYMessageType msgType;

/// Message ID.
@property (nonatomic, copy) NSArray<NSString *> *msgIds;

/// Message device ID.
@property (nonatomic, copy) NSArray<NSString *> *msgSrcIds;

@end

@interface TuyaSmartMessageListReadRequestModel : NSObject

/// Message type (Currently only supported TYMessageTypeAlarm).
@property (nonatomic, assign) TYMessageType msgType;

/// Message ID.
@property (nonatomic, copy) NSArray<NSString *> *msgIds;

@end

#pragma mark - setting
@interface TuyaSmartMessageSettingDNDRequestModel : NSObject

/// 开始时间 start time
@property (nonatomic, copy) NSString *startTime;

/// 结束时间 end time
@property (nonatomic, copy) NSString *endTime;

/// 设备ID列表 device ID list
@property (nonatomic, copy) NSArray<NSString *> *devIDs;

/// 每周重复 周一 ～ 周日 0 代表当天不开启 1 代表当天开启 如@“0000111”, 代表仅仅周五～周天开启 Repeat days per week
@property (nonatomic, copy) NSString *loops;

/// 是否是全部设备免打扰，YES是忽略 devIDs中值 all device DND
@property (nonatomic, assign) BOOL isAllDevIDs;

@end

NS_ASSUME_NONNULL_END
