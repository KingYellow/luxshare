//
// TuyaSmartMultiControlDpRelationModel.h
// TuyaSmartDeviceKit
//
// Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com)

#import <Foundation/Foundation.h>
#import "TuyaSmartMultiControlParentRuleModel.h"

NS_ASSUME_NONNULL_BEGIN
/// @brief Multi-Control group detail Model.
///
@interface TuyaSmartMcGroupDetailModel : NSObject

/// Group detail ID.
@property (copy, nonatomic) NSString *detailId;

/// Dp id.
@property (copy, nonatomic) NSString *dpId;

/// Dp name.
@property (copy, nonatomic) NSString *dpName;

/// Device ID.
@property (copy, nonatomic) NSString *devId;

/// Device name.
@property (copy, nonatomic) NSString *devName;

/// Availability.
@property (assign, nonatomic) BOOL enabled;

/// Multi-control group ID.
@property (copy, nonatomic) NSString *multiControlId;

@end

/// @brief Multi-Control group Model.
///
@interface TuyaSmartMcGroupModel : NSObject

/// Multi-control group id.
@property (copy, nonatomic) NSString *multiControlId;

/// Multi-control group name.
@property (copy, nonatomic) NSString *groupName;

/// Multi-control group association details.
@property (strong, nonatomic) NSArray<TuyaSmartMcGroupDetailModel *> *groupDetail;

/// Whether the multi-control group is in effect.
@property (assign, nonatomic) BOOL enabled;

/// Multi-control group type.
@property (assign, nonatomic) NSInteger groupType;

/// Multi rule ID.
@property (copy, nonatomic) NSString *multiRuleId;

/// Family ID.
@property (copy, nonatomic) NSString *ownerId;

/// User ID.
@property (copy, nonatomic) NSString *uid;

@end

/// @brief Multi-Control data Model.
///
@interface TuyaSmartMultiControlDpRelationModel : NSObject

/// Dp list.
@property (strong, nonatomic) NSArray<TuyaSmartMultiControlDatapointModel *> *datapoints;

/// Dp group List.
@property (strong, nonatomic) NSArray<TuyaSmartMcGroupModel *> *mcGroups;

/// Automation List
@property (strong, nonatomic) NSArray<TuyaSmartMultiControlParentRuleModel *> *parentRules;

@end

NS_ASSUME_NONNULL_END
