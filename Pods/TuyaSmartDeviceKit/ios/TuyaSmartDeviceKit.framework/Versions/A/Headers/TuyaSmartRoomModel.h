//
// TuyaSmartRoomModel.h
// TuyaSmartDeviceKit
//
// Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com)

#import <Foundation/Foundation.h>
/// @brief Room model.
///
@interface TuyaSmartRoomModel : NSObject

/// Room ID.
@property (nonatomic, assign) long long roomId;

/// Room icon.
@property (nonatomic, strong) NSString *iconUrl;

/// Room name.
@property (nonatomic, strong) NSString *name;

/// Order.
@property (nonatomic, assign) NSInteger displayOrder;


@end
