//
// TuyaSmartWeatherModel.h
// TuyaSmartDeviceKit
//
// Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com)

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// @brief Weather model.
///
@interface TuyaSmartWeatherModel : NSObject

/// The weather icon.
@property (nonatomic, copy) NSString *icon;

/// Weather parameter name.
@property (nonatomic, copy) NSString *name;

/// Parameter unit.
@property (nonatomic, copy) NSString *unit;

/// Parameter ID.
@property (nonatomic, assign) long long objId;

/// Whether to display; business layer not used.
@property (nonatomic, assign) BOOL show;

/// Weather parameter value.
@property (nonatomic, copy) NSString *value;

/// Weather parameter meta value.
@property (nonatomic, copy) NSString *metaValue;

/// Weather elements name.
@property (nonatomic, copy) NSString *fieldName;

/// Room name.
@property (nonatomic, copy) NSString *roomName;

@end

NS_ASSUME_NONNULL_END
