//
// TuyaSmartHomeModelUtils.h
// TuyaSmartDeviceKit
//
// Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com)

#ifndef TuyaSmartHomeModelUtils_h
#define TuyaSmartHomeModelUtils_h

/// The five types of home role.
typedef NS_ENUM(NSInteger, TYHomeRoleType) {
    /// The invalid role type.
    TYHomeRoleType_Unknown = -999,
    /// The customized role type.
    TYHomeRoleType_Custom  = -1,
    /// The general family member type.
    TYHomeRoleType_Member  = 0,
    /// The family administrator type. No permission to add or remove other administrators
    TYHomeRoleType_Admin,
    /// The family super administrator type. Family super administrator means family owner.
    TYHomeRoleType_Owner,
};

/// The three types of home status.
typedef NS_ENUM(NSUInteger, TYHomeStatus) {
    /// The pending status type. To be joined, invitees have not decided whether to join the corresponding family.
    TYHomeStatusPending = 1,
    /// The accept type. Invitees have agreed to join the corresponding family.
    TYHomeStatusAccept,
    /// The reject type. Invitees have declined to join the corresponding family.
    TYHomeStatusReject
};

#endif /* TuyaSmartHomeModelUtils_h */
