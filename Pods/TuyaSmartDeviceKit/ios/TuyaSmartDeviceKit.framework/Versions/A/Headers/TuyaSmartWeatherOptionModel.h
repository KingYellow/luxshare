//
// TuyaSmartWeatherOptionModel.h
// TuyaSmartDeviceKit
//
// Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com)

#import <Foundation/Foundation.h>

/// The types of weather pressure unit.
typedef enum : NSUInteger {
    /// The unknown type.
    TuyaSmartWeatherOptionPressureUnit_unknown = 0,
    /// The hPa type.
    TuyaSmartWeatherOptionPressureUnit_hPa = 1,
    /// The inHg type.
    TuyaSmartWeatherOptionPressureUnit_inHg = 2,
    /// The mmHg type.
    TuyaSmartWeatherOptionPressureUnit_mmHg = 3,
    /// The mb type.
    TuyaSmartWeatherOptionPressureUnit_mb = 4,
} TuyaSmartWeatherOptionPressureUnit;

/// The types of weather wind speed unit.
typedef enum : NSUInteger {
    /// The unknown type.
    TuyaSmartWeatherOptionWindSpeedUnit_unknown = 0,
    /// The mph type.
    TuyaSmartWeatherOptionWindSpeedUnit_mph = 1,
    /// The m/s type.
    TuyaSmartWeatherOptionWindSpeedUnit_m_s = 2,
    /// The kph type.
    TuyaSmartWeatherOptionWindSpeedUnit_kph = 3,
    /// The km/h type.
    TuyaSmartWeatherOptionWindSpeedUnit_km_h = 4
} TuyaSmartWeatherOptionWindSpeedUnit;

/// The types of weather temperature unit.
typedef enum : NSUInteger {
    /// The unknown type.
    TuyaSmartWeatherOptionTemperatureUnit_unknown = 0,
    /// The Degrees Celsius type. ℃
    TuyaSmartWeatherOptionTemperatureUnit_Centigrade = 1,
    /// The Fahrenheit type. ℉
    TuyaSmartWeatherOptionTemperatureUnit_Fahrenheit = 2,
} TuyaSmartWeatherOptionTemperatureUnit;

NS_ASSUME_NONNULL_BEGIN
/// @brief Get home weather request entry.
///
@interface TuyaSmartWeatherOptionModel : NSObject

/// Barometric unit.
@property (nonatomic, assign) TuyaSmartWeatherOptionPressureUnit pressureUnit;

/// Wind speed unit
@property (nonatomic, assign) TuyaSmartWeatherOptionWindSpeedUnit windspeedUnit;

/// Temperature units
@property (nonatomic, assign) TuyaSmartWeatherOptionTemperatureUnit temperatureUnit;

/// The number of requests for weather details, if not configured, all are returned by default.
@property (nonatomic, assign) NSInteger limit;

@end

NS_ASSUME_NONNULL_END
