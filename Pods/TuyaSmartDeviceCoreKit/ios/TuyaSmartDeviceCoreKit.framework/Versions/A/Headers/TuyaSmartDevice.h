//
// TuyaSmartDevice.h
// TuyaSmartDeviceCoreKit
//
// Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com)

#ifndef TuyaSmart_TuyaSmartDevice
#define TuyaSmart_TuyaSmartDevice

#import <TuyaSmartUtil/TuyaSmartUtil.h>
#import "TuyaSmartFirmwareUpgradeModel.h"
#import "TuyaSmartFirmwareUpgradeStatusModel.h"
#import "TuyaSmartDeviceModel.h"
#import "TuyaSmartMQTTMessageModel.h"
#import "TuyaSmartLanMessageModel.h"
#import "TuyaSmartBackupWifiModel.h"

NS_ASSUME_NONNULL_BEGIN

/// Device online status
typedef enum : NSUInteger {
    TYDeviceOnlineModeLocal, ///< Local network online
    TYDeviceOnlineModeInternet, ///<  Internet online
    TYDeviceOnlineModeOffline, ///<  Offline
} TYDeviceOnlineMode;

/// dp publish channel
typedef enum : NSUInteger {
    TYDevicePublishModeLocal, ///<  Through local network
    TYDevicePublishModeInternet, ///<  Through internet
    TYDevicePublishModeAuto, ///<  Auto (If local network is available, use local)
} TYDevicePublishMode;

@class TuyaSmartDevice;

@protocol TuyaSmartDeviceDelegate<NSObject>

@optional

/// Device info update, such as the name, online.
/// @param device The device instance.
- (void)deviceInfoUpdate:(TuyaSmartDevice *)device;

/// Device removed.
/// @param device The device instance.
- (void)deviceRemoved:(TuyaSmartDevice *)device;

/// Dp data update.
/// @param device The device instance.
/// @param dps Command dictionary.
- (void)device:(TuyaSmartDevice *)device dpsUpdate:(NSDictionary *)dps;

/// Dp data update.
/// @param device The device instance.
/// @param dpCodes dpCodes.
- (void)device:(TuyaSmartDevice *)device dpCommandsUpdate:(NSDictionary *)dpCodes;

/// Firmware upgrade progress.
/// @param device The device instance.
/// @param type The device type.
/// @param progress Upgrade progress
- (void)device:(TuyaSmartDevice *)device firmwareUpgradeProgress:(NSInteger)type progress:(double)progress;

/// The delegate of device firmware upgrade status update.
/// @param device The device instance.
/// @param upgradeStatusModel Equipment upgrade status model.
- (void)device:(TuyaSmartDevice *)device firmwareUpgradeStatusModel:(TuyaSmartFirmwareUpgradeStatusModel *)upgradeStatusModel;

/// Wifi signal strength callback.
/// @param device The device instance.
/// @param signal Signal strength.
- (void)device:(TuyaSmartDevice *)device signal:(NSString *)signal;

/// Receive MQTT custom message.
/// @param device The device instance.
/// @param message Custom message.
- (void)device:(TuyaSmartDevice *)device didReceiveCustomMessage:(TuyaSmartMQTTMessageModel *)message;

/// Receive LAN custom message.
- (void)device:(TuyaSmartDevice *)device didReceiveLanMessage:(TuyaSmartLanMessageModel *)message;

/// The delegate of warning information update.
/// @param device The device instance.
/// @param warningInfo Warning info.
- (void)device:(TuyaSmartDevice *)device warningInfoUpdate:(NSDictionary *)warningInfo;

#pragma - deprecated

/// The delegate of device firmware upgrade status update.
/// @param device The device instance.
/// @param type The device type.
/// @param upgradeStatus The device upgrade status.
/// @deprecated This method is deprecated, Use TuyaSmartDeviceDelegate::device:firmwareUpgradeStatusModel: instead.
- (void)device:(TuyaSmartDevice *)device type:(NSInteger)type upgradeStatus:(TuyaSmartDeviceUpgradeStatus)upgradeStatus __deprecated_msg("This method is deprecated, Use device:firmwareUpgradeStatusModel: instead");

/// Device firmware upgrade success.
/// @param device The device instance.
/// @param type The device type.
/// @deprecated This method is deprecated, Use TuyaSmartDeviceDelegate::device:upgradeStatus: instead.
- (void)deviceFirmwareUpgradeSuccess:(TuyaSmartDevice *)device type:(NSInteger)type __deprecated_msg("This method is deprecated, Use device:upgradeStatus: instead");

/// Device firmware upgrade failure.
/// @param device The device instance.
/// @param type The device type.
/// @deprecated This method is deprecated, Use TuyaSmartDeviceDelegate::device:upgradeStatus: instead
- (void)deviceFirmwareUpgradeFailure:(TuyaSmartDevice *)device type:(NSInteger)type __deprecated_msg("This method is deprecated, Use device:upgradeStatus: instead");

/// Device firmware upgrading.
/// @param device The device instance.
/// @param type The device type.
/// @deprecated This method is deprecated, Use TuyaSmartDeviceDelegate::device:upgradeStatus: instead.
- (void)deviceFirmwareUpgrading:(TuyaSmartDevice *)device type:(NSInteger)type __deprecated_msg("This method is deprecated, Use device:upgradeStatus: instead");

@end

/// Device-related functions.
@interface TuyaSmartDevice : NSObject

@property (nonatomic, strong, readonly) TuyaSmartDeviceModel *deviceModel;
@property (nonatomic, weak, nullable) id<TuyaSmartDeviceDelegate> delegate;

/// Get TuyaSmartDevice instance. If current user don't have this device, a nil will be return.
/// @param devId The device ID.
+ (nullable instancetype)deviceWithDeviceId:(NSString *)devId;

/// Get TuyaSmartDevice instance. If current user don't have this device, a nil will be return.
/// @param devId The device ID.
- (nullable instancetype)initWithDeviceId:(NSString *)devId NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;

/// Get device online status.
- (TYDeviceOnlineMode)onlineMode;

/// Dp command publish.
/// @param dps The dp dictionary.
/// @param success Called when the task finishes successfully.
/// @param failure Called when the task is interrupted by an error.
- (void)publishDps:(NSDictionary *)dps
           success:(nullable TYSuccessHandler)success
           failure:(nullable TYFailureError)failure;

/// Dp command publish.
/// @param dps The dp dictionary.
/// @param mode Publish mode(Lan/Internet/Auto).
/// @param success Called when the task finishes successfully.
/// @param failure Called when the task is interrupted by an error.
- (void)publishDps:(NSDictionary *)dps
              mode:(TYDevicePublishMode)mode
           success:(nullable TYSuccessHandler)success
           failure:(nullable TYFailureError)failure;

/// Edit device name.
/// @param name The device name.
/// @param success Called when the task finishes successfully.
/// @param failure Called when the task is interrupted by an error.
- (void)updateName:(NSString *)name
           success:(nullable TYSuccessHandler)success
           failure:(nullable TYFailureError)failure;

/// Edit device icon.
/// @param icon The device icon.
/// @param success Called when the task finishes successfully.
/// @param failure Called when the task is interrupted by an error.
- (void)updateIcon:(UIImage *)icon
           success:(nullable TYSuccessHandler)success
           failure:(nullable TYFailureError)failure;

/// Edit device icon.
/// @param cloudKey Cloud Key.
/// @param success Called when the task finishes successfully.
/// @param failure Called when the task is interrupted by an error.
- (void)updateIconWithCloudKey:(NSString *)cloudKey
                       success:(nullable TYSuccessHandler)success
                       failure:(nullable TYFailureError)failure;

/// Sync device information.
/// @param success Called when the task finishes successfully.
/// @param failure Called when the task is interrupted by an error.
- (void)syncWithCloud:(nullable TYSuccessHandler)success
              failure:(nullable TYFailureError)failure;

/// Sync device information.
/// @param devId The device ID.
/// @param homeId The home ID.
/// @param success Called when the task finishes successfully.
/// @param failure Called when the task is interrupted by an error.
+ (void)syncDeviceInfoWithDevId:(NSString *)devId
                         homeId:(long long)homeId
                        success:(nullable TYSuccessHandler)success
                        failure:(nullable TYFailureError)failure;

/// Sync subdevice information.
/// @param gatewayId The gateway ID.
/// @param devId The device ID.
/// @param success Called when the task finishes successfully.
/// @param failure Called when the task is interrupted by an error.
+ (void)syncSubDeviceInfoWithGatewayId:(NSString *)gatewayId
                                 devId:(NSString *)devId
                               success:(nullable TYSuccessHandler)success
                               failure:(nullable TYFailureError)failure;

/// Remove device. Unbind the device with current user.
/// @param success Called when the task finishes successfully.
/// @param failure Called when the task is interrupted by an error.
- (void)remove:(nullable TYSuccessHandler)success failure:(nullable TYFailureError)failure;

/// Restore factory settings.
/// @param success Called when the task finishes successfully.
/// @param failure Called when the task is interrupted by an error.
- (void)resetFactory:(nullable TYSuccessHandler)success failure:(nullable TYFailureError)failure;

/// Get sub-device list of current gateway.
/// @param success Called when the task finishes successfully.
/// @param failure Called when the task is interrupted by an error.
- (void)getSubDeviceListFromCloudWithSuccess:(nullable void (^)(NSArray <TuyaSmartDeviceModel *> *subDeviceList))success failure:(nullable TYFailureError)failure;

/// Synchronize the Longitude and Latitude of the Mobile Phone to the Device.
/// @param success Called when the task finishes successfully.
/// @param failure Called when the task is interrupted by an error.
- (void)syncLocationToDeviceWithSucecess:(nullable TYSuccessHandler)success failure:(nullable TYFailureError)failure;

#pragma mark - firmware upgrade

/// Get firmware upgrade information.
/// @param success Called when the task finishes successfully.
/// @param failure Called when the task is interrupted by an error.
- (void)getFirmwareUpgradeInfo:(nullable void (^)(NSArray <TuyaSmartFirmwareUpgradeModel *> *upgradeModelList))success
                       failure:(nullable TYFailureError)failure;

/// Upgrade firmware. Receive success or failure callback from TuyaSmartDeviceDelegate.
/// @param type The device type of "TuyaSmartFirmwareUpgradeModel".
/// @param success Called when the task finishes successfully.
/// @param failure Called when the task is interrupted by an error.
- (void)upgradeFirmware:(NSInteger)type success:(nullable TYSuccessHandler)success failure:(nullable TYFailureError)failure;

/// Cancel firmware upgrade network request.
- (void)cancelFirmwareRequest;

/// Report device firmware version.
/// @param version The device version.
/// @param type The device type.
/// @param success Called when the task finishes successfully.
/// @param failure Called when the task is interrupted by an error.
- (void)updateDeviceVersion:(NSString *)version
                       type:(NSInteger)type
                    success:(nullable TYSuccessHandler)success
                    failure:(nullable TYFailureError)failure;

/// Get the switch value for the device OTA auto-upgrade
/// @param success Called when the task finishes successfully.
/// @param failure Called when the task is interrupted by an error.
- (void)getAutoUpgradeSwitchInfoWithSuccess:(nullable TYSuccessID)success
                                    failure:(nullable TYFailureError)failure;

/// Save the switch value for automatic device OTA upgrade.
/// @param switchValue The value of the auto switch. 0 represents off, and 1 means on.
/// @param success Called when the task finishes successfully.
/// @param failure Called when the task is interrupted by an error.
- (void)saveUpgradeInfoWithSwitchValue:(NSInteger)switchValue
                               success:(nullable TYSuccessHandler)success
                               failure:(nullable TYFailureError)failure;

#if TARGET_OS_IOS

/// Get wifi signal strength. Receive signal strength from`-[TuyaSmartDeviceDelegate device:signal:]`.
/// @param success Called when the task finishes successfully.
/// @param failure Called when the task is interrupted by an error.
- (void)getWifiSignalStrengthWithSuccess:(nullable TYSuccessHandler)success failure:(nullable TYFailureError)failure;

/// Publish message in LAN.
/// @param body The message body.
/// @param type The message type.
/// @param success Called when the task finishes successfully.
/// @param failure Called when the task is interrupted by an error.
- (void)publishMessageInLanWithBody:(NSDictionary *)body
                               type:(NSInteger)type
                            success:(nullable TYSuccessDict)success
                            failure:(nullable TYFailureError)failure;

/// Query dp initiative. Some dp won't report initiative when changed.
/// @param dpsArray DpId array. If nil or empty array passed in, All dp will be queried.
/// @param success Called when the task finishes successfully.
/// @param failure Called when the task is interrupted by an error.
- (void)getInitiativeQueryDpsInfoWithDpsArray:(nullable NSArray *)dpsArray
                                      success:(nullable TYSuccessHandler)success
                                      failure:(nullable TYFailureError)failure;

/// Awake low energy device.
/// @param success Called when the task finishes successfully.
/// @param failure Called when the task is interrupted by an error.
- (void)awakeDeviceWithSuccess:(nullable TYSuccessHandler)success failure:(nullable TYFailureError)failure;

#pragma mark - wifi backup

/// Get current Wi-Fi info.
/// @param success Called when the task finishes successfully. TYSuccessDict will be returned.
/// @param failure Called when the task is interrupted by an error.
- (void)getCurrentWifiInfoWithSuccess:(TYSuccessDict)success failure:(TYFailureError)failure __IOS_AVAILABLE(10.0);


/// Get a list of alternate networks
/// @param success Called when the task finishes successfully. TYSuccessDict will be returned.
/// @param failure Called when the task is interrupted by an error.
- (void)getBackupWifiListWithSuccess:(TYSuccessDict)success failure:(TYFailureError)failure __IOS_AVAILABLE(10.0);


/// Setting up an alternate network list
/// @param list Backup wifi list.
/// @param success Called when the task finishes successfully. A list of TuyaSmartBackupWifiModel will be returned.
/// @param failure Called when the task is interrupted by an error.
- (void)setBackupWifiList:(NSArray<TuyaSmartBackupWifiModel *> *)list success:(TYSuccessDict)success failure:(TYFailureError)failure __IOS_AVAILABLE(10.0);


/// Switching to a saved alternate network
/// @param hash Hash for the SSID + password, returned from device.
/// @param success Called when the task finishes successfully.
/// @param failure Called when the task is interrupted by an error.
- (void)switchToBackupWifiWithHash:(NSString *)hash success:(TYSuccessDict)success failure:(TYFailureError)failure __IOS_AVAILABLE(10.0);


/// Switching to a new alternate network
/// @param ssid SSID
/// @param password SSID
/// @param success Called when the task finishes successfully.
/// @param failure Called when the task is interrupted by an error.
- (void)switchToBackupWifiWithSSID:(NSString *)ssid password:(NSString *)password success:(TYSuccessDict)success failure:(TYFailureError)failure __IOS_AVAILABLE(10.0);

#pragma mark - publish custom message

/// Add custom message delegate.  Receive custom message from `- (void)device:(TuyaSmartDevice *)device didReceiveCustomMessage:(TuyaSmartMQTTMessageModel *)message`.
/// @param delegate The delegate of TuyaSmartDevice.
/// @param protocol Protocol.
- (void)addDelegate:(id<TuyaSmartDeviceDelegate>)delegate forProtocol:(NSInteger)protocol;

/// Remove custom message delegate.
/// @param delegate The delegate of TuyaSmartDevice.
/// @param protocol Protocol
- (void)removeDelegate:(id<TuyaSmartDeviceDelegate>)delegate forProtocol:(NSInteger)protocol;

/// Send to custom message.
/// @param data Data.
/// @param protocol Protocol.
/// @param success Called when the task finishes successfully.
/// @param failure Called when the task is interrupted by an error.
- (void)publishCustomMessageWithData:(NSDictionary *)data
                            protocol:(NSInteger)protocol
                             success:(nullable TYSuccessHandler)success
                             failure:(nullable TYFailureError)failure;

#endif

/// Dp command publish.
/// @param commands DpCode - value dictionary.
/// @param success Called when the task finishes successfully.
/// @param failure Called when the task is interrupted by an error.
- (void)publishDpWithCommands:(NSDictionary *)commands
                      success:(nullable TYSuccessHandler)success
                      failure:(nullable TYFailureError)failure;

@end

NS_ASSUME_NONNULL_END

#endif
