//
// TuyaSmartMultiControlModel.h
// TuyaSmartDeviceKit
//
// Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com)

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
/// @brief Multi-Control detail Model.
///
@interface TuyaSmartMultiControlDetailModel : NSObject

/// Multi-Control detail ID.
@property (copy, nonatomic) NSString *detailId;

/// Attachment device ID.
@property (copy, nonatomic) NSString *devId;

/// The dp id of the associated attached device.
@property (copy, nonatomic) NSString *dpId;

/// Whether affiliated devices that have been associated can be controlled by the multi-control function.
@property (assign, nonatomic) BOOL enable;

@end

/// @brief Multi-Control Model.
///
@interface TuyaSmartMultiControlModel : NSObject

/// Multi-control group id.
@property (copy, nonatomic) NSString *multiControlId;

/// Multi-control group name.
@property (copy, nonatomic) NSString *groupName;

/// Group detail list.
@property (strong, nonatomic) NSArray<TuyaSmartMultiControlDetailModel *> *groupDetail;

/// Multi-control group type. Default is 1.
@property (assign, nonatomic, readonly) NSInteger groupType;

/// Home id.
@property (copy, nonatomic, readonly) NSString *ownerId;

/// User id.
@property (copy, nonatomic, readonly) NSString *uid;

@end

NS_ASSUME_NONNULL_END
