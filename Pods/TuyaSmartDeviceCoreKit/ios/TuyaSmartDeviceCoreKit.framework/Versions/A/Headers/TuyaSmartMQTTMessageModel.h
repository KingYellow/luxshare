//
// TuyaSmartMQTTMessageModel.h
// TuyaSmartDeviceCoreKit
//
// Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com)

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TuyaSmartMQTTMessageModel : NSObject

@property (nonatomic, assign) NSInteger    protocol;

@property (nonatomic, strong) NSString     *type;

@property (nonatomic, strong) id           data;

@property (nonatomic, strong) NSString     *devId;

@end

NS_ASSUME_NONNULL_END
