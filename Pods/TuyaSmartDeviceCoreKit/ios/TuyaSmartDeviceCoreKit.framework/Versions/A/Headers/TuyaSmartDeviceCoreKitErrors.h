//
// TuyaSmartDeviceCoreKitErrors.h
// TuyaSmartDeviceCoreKit
//
// Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com)

#ifndef TuyaSmartDeviceCoreKitErrors_h
#define TuyaSmartDeviceCoreKitErrors_h

/*
 *  TYDeviceCoreKitError
 *
 *  Discussion:
 *    Error returned as code to NSError from TuyaSmartDeviceKit.
 */
extern NSString *const kTYDeviceCoreKitErrorDomain;

typedef NS_ENUM(NSInteger, TYDeviceCoreKitError) {
    kTYDeviceCoreKitErrorDeviceNotSupport                      = 3000, ///< The device does not support a certain capability (capability reported on the device dimension).
    kTYDeviceCoreKitErrorSocketSendDataFailed                  = 3001, ///< LAN downstream data failure
    kTYDeviceCoreKitErrorEmptyDpsData                          = 3002, // DPS command is empty.
    kTYDeviceCoreKitErrorGroupDeviceListEmpty                  = 3003, // Group device is empty.
    kTYDeviceCoreKitErrorGroupIdLengthError                    = 3004, // Group ID length error.
    kTYDeviceCoreKitErrorIllegalDpData                         = 3005, // Illegal dps, see product dp definition.
    kTYDeviceCoreKitErrorDeviceIdLengthError                   = 3006, // Device ID length error.
    kTYDeviceCoreKitErrorDeviceLocalKeyNotFound                = 3007, // Missing local key.
    kTYDeviceCoreKitErrorDeviceProductIDLengthError            = 3008, // Product ID length error.
    
};

#endif /* TuyaSmartDeviceCoreKitErrors_h */
