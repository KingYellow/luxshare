//
// TuyaSmartMultiControlDatapointModel.h
// TuyaSmartDeviceKit
//
// Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com)

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
/// @brief Multi-Control Datapoint Model.
///
@interface TuyaSmartMultiControlDatapointModel : NSObject

/// Dp id.
@property (copy, nonatomic) NSString *dpId;

/// Dp name.
@property (copy, nonatomic) NSString *name;

/// Dp standard name（dpCode）.
@property (copy, nonatomic) NSString *code;

/// The schema ID to which the key belongs.
@property (copy, nonatomic) NSString *schemaId;
@end

NS_ASSUME_NONNULL_END
