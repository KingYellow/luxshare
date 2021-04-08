//
// TuyaSmartMultiControlLinkModel.h
// TuyaSmartDeviceKit
//
// Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com)

#import <Foundation/Foundation.h>
#import "TuyaSmartMultiControlParentRuleModel.h"

NS_ASSUME_NONNULL_BEGIN

/// @brief Multi-Control group detail Model.
///
@interface TuyaSmartMultiControlGroupDetailModel : NSObject

/// Group detail ID.
@property (copy, nonatomic) NSString *detailId;

/// Multi-control group id.
@property (copy, nonatomic) NSString *multiControlId;

/// Attachment device id.
@property (copy, nonatomic) NSString *devId;

/// Name of attached device.
@property (copy, nonatomic) NSString *devName;

/// The dp id of the associated attached device.
@property (copy, nonatomic) NSString *dpId;

/// The dp name of the associated attached device.
@property (copy, nonatomic) NSString *dpName;

/// Whether affiliated devices that have been associated can be controlled by the multi-control function.
@property (assign, nonatomic) BOOL enabled;

/// Dp list.
@property (strong, nonatomic) NSArray<TuyaSmartMultiControlDatapointModel *> *datapoints;

@end

/// @brief Multi-Control group Model.
///
@interface TuyaSmartMultiControlGroupModel : NSObject

/// Multi-control group id.
@property (copy, nonatomic) NSString *multiControlId;

/// Multi-control group name.
@property (copy, nonatomic) NSString *groupName;

/// Multi-control group details.
@property (strong, nonatomic) NSArray<TuyaSmartMultiControlGroupDetailModel *> *groupDetail;

/// Whether the multi-control group is in effect.
@property (assign, nonatomic) BOOL enabled;

/// Multi-control group type.
@property (assign, nonatomic) NSInteger groupType;

/// Multi rule ID.
@property (copy, nonatomic) NSString *multiRuleId;

/// Family id.
@property (copy, nonatomic) NSString *ownerId;

/// User id.
@property (copy, nonatomic) NSString *uid;

@end

/// @brief Multi-Control link Model.
///
@interface TuyaSmartMultiControlLinkModel : NSObject

/// Multi-Control group Model.
@property (strong, nonatomic) TuyaSmartMultiControlGroupModel *multiGroup;

/// Automation List
@property (strong, nonatomic) NSArray<TuyaSmartMultiControlParentRuleModel *> *parentRules;

@end

NS_ASSUME_NONNULL_END
