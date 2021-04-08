//
// TuyaSmartMultiControlDeviceModel.h
// TuyaSmartDeviceKit
//
// Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com)

#import <Foundation/Foundation.h>
#import "TuyaSmartMultiControlDatapointModel.h"

NS_ASSUME_NONNULL_BEGIN
/// @brief Multi-Control Device Model.
///
@interface TuyaSmartMultiControlDeviceModel : NSObject

/// Device ID.
@property (copy, nonatomic) NSString *devId;

/// Product ID.
@property (copy, nonatomic) NSString *productId;

/// Device name.
@property (copy, nonatomic) NSString *name;

/// Device Icon download link.
@property (copy, nonatomic) NSString *iconUrl;

/// Room name.
@property (copy, nonatomic) NSString *roomName;

/// A boolean value indicates whether the device in an automated condition.
@property (assign, nonatomic) BOOL inRule;

/// Dp list.
@property (strong, nonatomic) NSArray<TuyaSmartMultiControlDatapointModel *> *datapoints;

/// Multiple control group ID arrays that the device has been associated with.
@property (strong, nonatomic) NSArray<NSString *> *multiControlIds;

@end

NS_ASSUME_NONNULL_END
