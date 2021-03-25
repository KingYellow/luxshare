//
// TuyaSmartSIGMeshDiscoverDeviceInfo.h
// TuyaSmartBLEMeshKit
//
// Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com)

#import <Foundation/Foundation.h>
#import <TYBluetooth/TYBLEAgent.h>

typedef NS_ENUM(NSUInteger, SIGMeshNodeProvisionType) {
    SIGMeshNodeUnknow,
    SIGMeshNodeUnprovision, /// New device.
    SIGMeshNodeProvisioned, /// Provisiond device.
    SIGMeshNodeProxyed, /// Already proxy, only need connect and control.
};

typedef enum : NSUInteger {
    TYSIGMeshNodeActivatorTypeStandard = 0, /// Standard distribution network.
    TYSIGMeshNodeActivatorTypeQuick = 1 << 0, /// Fast distribution network.
} TYSIGMeshNodeActivatorType;

NS_ASSUME_NONNULL_BEGIN

#define kQuickVersion @"kQuickVersion"

@interface TuyaSmartSIGMeshDiscoverDeviceInfo : NSObject

@property (nonatomic, strong) TYBLEPeripheral *peripheral;

@property (nonatomic, assign) SIGMeshNodeProvisionType provisionType;

@property (nonatomic, assign) TYSIGMeshNodeActivatorType activatorType; /// < Distribution network type.

@property (nonatomic, copy) NSString *mac;

@property (nonatomic, copy) NSString *type;

@property (nonatomic, copy) NSString *productId;

/// For ota.
@property (nonatomic, copy) NSString *nodeId;

/// QuickSuccess: YES | NO , for extend.
@property (nonatomic, strong) NSDictionary *extendInfo;

@end

NS_ASSUME_NONNULL_END
