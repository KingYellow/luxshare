//
// TuyaSmartDeviceCoreKit.h
// TuyaSmartDeviceCoreKit
//
// Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com)

#ifndef TuyaSmartDeviceCoreKit_h
#define TuyaSmartDeviceCoreKit_h

/// The highest currently supported extranet communication protocol for clients.
#define TUYA_CURRENT_GW_PROTOCOL_VERSION 2.2

/// Highest currently supported LAN communication protocol for clients.
#define TUYA_CURRENT_LAN_PROTOCOL_VERSION 3.4

#import <TuyaSmartBaseKit/TuyaSmartBaseKit.h>

#if TARGET_OS_IOS
    #import <TuyaSmartMQTTChannelKit/TuyaSmartMQTTChannelKit.h>
    #import <TuyaSmartSocketChannelKit/TuyaSmartSocketChannelKit.h>
#elif TARGET_OS_WATCH
    #define TuyaSmartMQTTChannelDelegate NSObject
    #define TuyaSmartSocketChannelDelegate NSObject
#endif

#import "TuyaSmartDevice.h"
#import "TuyaSmartGroup.h"
#import "TuyaSmartBleMeshModel.h"
#import "TuyaSmartSingleTransfer.h"
#import "TYCoreCacheService.h"

#import "TuyaSmartDeviceCoreKitErrors.h"

#import "TuyaSmartDevice+OfflineReminder.h"

#endif /* TuyaSmartDeviceCoreKit_h */
