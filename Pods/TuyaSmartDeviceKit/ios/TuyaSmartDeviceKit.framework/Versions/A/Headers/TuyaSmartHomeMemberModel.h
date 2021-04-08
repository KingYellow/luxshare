//
// TuyaSmartHomeMemberModel.h
// TuyaSmartDeviceKit
//
// Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com)

#import <Foundation/Foundation.h>
#import "TuyaSmartHomeModelUtils.h"
/// @brief Home member model.
///
@interface TuyaSmartHomeMemberModel : NSObject

/// Member ID.
@property (nonatomic, assign) long long memberId;

/// Head portraits of members.
@property (nonatomic, strong) NSString *headPic;

/// Name of members.
@property (nonatomic, strong) NSString *name;

/// Role.
@property (nonatomic, assign) TYHomeRoleType role;

/// Home Id.
@property (nonatomic, assign) long long homeId;

/// Mobile.
@property (nonatomic, strong) NSString *mobile;

/// User name.
@property (nonatomic, strong) NSString *userName;

/// Uid.
@property (nonatomic, strong) NSString *uid;

/// State of deal.
@property (nonatomic, assign) TYHomeStatus dealStatus;

#pragma mark - deprecated
/// Admin or not.
/// @deprecated This property is deprecated. Use 'role' instead.
@property (nonatomic, assign) BOOL isAdmin __deprecated_msg("The property will be deprecated and remove in a future version，Please use role");

@end
