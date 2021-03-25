//
// TuyaSmartDevice+OfflineReminder.h
// TuyaSmartDeviceCoreKit
//
// Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com)

#import "TuyaSmartDevice.h"

NS_ASSUME_NONNULL_BEGIN

@interface TuyaSmartDevice (OfflineReminder)

/// Check if the device supports offline alerts
///
/// @param success Called when the task finishes successfully.
/// @param failure Called when the task is interrupted by an error.
- (void)getOfflineReminderSupportStatusWithSuccess:(nullable TYSuccessBOOL)success failure:(nullable TYFailureError)failure;


/// Get the device offline reminder status
///
/// @param success Called when the task finishes successfully.
/// @param failure Called when the task is interrupted by an error.
- (void)getOfflineReminderStatusWithSuccess:(nullable TYSuccessBOOL)success failure:(nullable TYFailureError)failure;


/// Set device offline reminder
///
/// @param status  Need remind when device offline
/// @param success Called when the task finishes successfully.
/// @param failure Called when the task is interrupted by an error.
- (void)setOfflineReminderStatus:(BOOL)status success:(nullable TYSuccessBOOL)success failure:(nullable TYFailureError)failure;

@end

NS_ASSUME_NONNULL_END
