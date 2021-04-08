//
// TuyaSmartMultiControlParentRuleModel.h
// TuyaSmartDeviceKit
//
// Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com)

#import <Foundation/Foundation.h>
#import "TuyaSmartMultiControlDatapointModel.h"

NS_ASSUME_NONNULL_BEGIN

/// @brief Multi-Control automation Dp Model.
///
@interface TuyaSmartMultiControlParentRuleDpModel : NSObject

/// Dp ID.
@property (copy, nonatomic) NSString *dpId;

/// Dp name.
@property (copy, nonatomic) NSString *dpName;

@end


/// @brief Multi-Control automation Model.
///
@interface TuyaSmartMultiControlParentRuleModel : NSObject

/// Automation ID.
@property (copy, nonatomic) NSString *ruleId;

/// Automation name.
@property (copy, nonatomic) NSString *name;

/// Dp List.
@property (strong, nonatomic) NSArray<TuyaSmartMultiControlParentRuleDpModel *> *dpList;

@end

NS_ASSUME_NONNULL_END
