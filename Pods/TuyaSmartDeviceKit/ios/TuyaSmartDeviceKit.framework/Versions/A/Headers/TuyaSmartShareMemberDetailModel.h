//
// TuyaSmartShareMemberDetailModel.h
// TuyaSmartDeviceKit
//
// Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com)

@class TuyaSmartShareDeviceModel;

/// @brief Share member detail model.
///
@interface TuyaSmartShareMemberDetailModel : NSObject

/// DeviceModel list.
@property (nonatomic, strong) NSArray <TuyaSmartShareDeviceModel *> *devices;

/// Mobile.
@property (nonatomic, strong) NSString *mobile;

/// Name.
@property (nonatomic, strong) NSString *name;

/// Remark name.
@property (nonatomic, strong) NSString *remarkName;

/// Auto sharing.
@property (nonatomic, assign) BOOL autoSharing;


@end
