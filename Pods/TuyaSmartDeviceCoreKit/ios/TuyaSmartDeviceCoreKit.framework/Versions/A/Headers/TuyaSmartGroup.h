//
// TuyaSmartGroup.h
// TuyaSmartDeviceCoreKit
//
// Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com)

#ifndef TuyaSmart_TuyaSmartGroup
#define TuyaSmart_TuyaSmartGroup

#import <Foundation/Foundation.h>
#import "TuyaSmartGroupModel.h"
#import "TuyaSmartGroupDevListModel.h"

NS_ASSUME_NONNULL_BEGIN

@class TuyaSmartGroup;

@protocol TuyaSmartGroupDelegate<NSObject>

@optional

/// Group dps data update.
/// @param group The instance of TuyaSmartGroup.
/// @param dps dps.
- (void)group:(TuyaSmartGroup *)group dpsUpdate:(NSDictionary *)dps;

/// Group Information Update.
/// @param group The instance of TuyaSmartGroup.
- (void)groupInfoUpdate:(TuyaSmartGroup *)group;

/// Group removal.
/// @param groupId The group ID.
- (void)groupRemove:(NSString *)groupId;

/// Group dpCodes data update.
/// @param group The instance of TuyaSmartGroup.
/// @param dpCodes Dp Codes
- (void)group:(TuyaSmartGroup *)group dpCodesUpdate:(NSDictionary *)dpCodes;

/// Group Response of Zigbee Devices Joining Gateway. 1: Over the Scenario Limit 2: Sub-device Timeout 3: Setting Value Out of Range 4: Write File Error 5: Other Errors.
/// @param group The instance of TuyaSmartGroup.
/// @param responseCode Response code.
- (void)group:(TuyaSmartGroup *)group addResponseCode:(NSArray <NSNumber *>*)responseCode;

/// Group Response of Zigbee Devices removing Gateway 1: Over the Scenario Limit 2: Sub-device Timeout 3: Setting Value Out of Range 4: Write File Error 5: Other Errors.
/// @param group The instance of TuyaSmartGroup.
/// @param responseCode Response code.
- (void)group:(TuyaSmartGroup *)group removeResponseCode:(NSArray <NSNumber *>*)responseCode;

@end

@interface TuyaSmartGroup : NSObject

@property (nonatomic, strong, readonly) TuyaSmartGroupModel *groupModel;

@property (nonatomic, weak, nullable) id<TuyaSmartGroupDelegate> delegate;

/// Get TuyaSmartGroup instance.
/// @param groupId The group ID.
+ (nullable instancetype)groupWithGroupId:(NSString *)groupId;

/// Get TuyaSmartGroup instance.
/// @param groupId The group ID.
- (nullable instancetype)initWithGroupId:(NSString *)groupId NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;

/// Creating Groups of Wifi Devices.
/// @param name The group name.
/// @param productId Product ID.
/// @param homeId Home ID.
/// @param devIdList DeviceId list.
/// @param success Called when the task finishes successfully.
/// @param failure Called when the task is interrupted by an error.
+ (void)createGroupWithName:(NSString *)name
                  productId:(NSString *)productId
                     homeId:(long long)homeId
                  devIdList:(NSArray<NSString *> *)devIdList
                    success:(nullable void (^)(TuyaSmartGroup *group))success
                    failure:(nullable TYFailureError)failure;

/// Get list of WiFi devices that support groups based on productId.
/// @param productId Product ID.
/// @param homeId Home ID.
/// @param success Called when the task finishes successfully.
/// @param failure Called when the task is interrupted by an error.
+ (void)getDevList:(NSString *)productId
            homeId:(long long)homeId
           success:(nullable void(^)(NSArray <TuyaSmartGroupDevListModel *> *list))success
           failure:(nullable TYFailureError)failure;

/// Get the device list for the corresponding group based on productId.
/// @param productId Product ID.
/// @param success Called when the task finishes successfully.
/// @param failure Called when the task is interrupted by an error.
- (void)getDevList:(NSString *)productId
           success:(nullable void(^)(NSArray <TuyaSmartGroupDevListModel *> *list))success
           failure:(nullable TYFailureError)failure;

/// Group control command issuance.
/// @param dps dps.
/// @param success Called when the task finishes successfully.
/// @param failure Called when the task is interrupted by an error.
- (void)publishDps:(NSDictionary *)dps success:(nullable TYSuccessHandler)success failure:(nullable TYFailureError)failure;

/// Rename the group name.
/// @param name The group name.
/// @param success Called when the task finishes successfully.
/// @param failure Called when the task is interrupted by an error.
- (void)updateGroupName:(NSString *)name success:(nullable TYSuccessHandler)success failure:(nullable TYFailureError)failure;

/// Edit group icon.
/// @param icon Group icon.
/// @param success Called when the task finishes successfully.
/// @param failure Called when the task is interrupted by an error.
- (void)updateIcon:(UIImage *)icon
           success:(nullable TYSuccessHandler)success
           failure:(nullable TYFailureError)failure;

/// Edit group icon.
/// @param cloudKey The cloud key.
/// @param success Called when the task finishes successfully.
/// @param failure Called when the task is interrupted by an error.
- (void)updateIconWithCloudKey:(NSString *)cloudKey
                       success:(nullable TYSuccessHandler)success
                       failure:(nullable TYFailureError)failure;

/// Modify the device list of the group.
/// @param devList Device list.
/// @param success Called when the task finishes successfully.
/// @param failure Called when the task is interrupted by an error.
- (void)updateGroupRelations:(NSArray <NSString *>*)devList
                     success:(nullable TYSuccessHandler)success
                     failure:(nullable TYFailureError)failure;

/// Remove Group.
/// @param success Called when the task finishes successfully.
/// @param failure Called when the task is interrupted by an error.
- (void)dismissGroup:(nullable TYSuccessHandler)success failure:(nullable TYFailureError)failure;


#pragma mark - zigbee

/// Create groups of zigBee devices.
/// @param name Group name.
/// @param homeId Home ID.
/// @param gwId Gateway ID.
/// @param productId Product ID.
/// @param success Called when the task finishes successfully.
/// @param failure Called when the task is interrupted by an error.
+ (void)createGroupWithName:(NSString *)name
                     homeId:(long long)homeId
                       gwId:(NSString *)gwId
                  productId:(NSString *)productId
                    success:(nullable void (^)(TuyaSmartGroup *))success
                    failure:(nullable TYFailureError)failure;

/// Get a list of ZigBee sub devices for the corresponding support group based on productId and gwId.
/// @param productId Product ID.
/// @param gwId Gateway ID.
/// @param homeId Home ID.
/// @param success Called when the task finishes successfully.
/// @param failure Called when the task is interrupted by an error.
+ (void)getDevListWithProductId:(NSString *)productId
                           gwId:(NSString *)gwId
                         homeId:(long long)homeId
                        success:(nullable void (^)(NSArray<TuyaSmartGroupDevListModel *> *))success
                        failure:(nullable TYFailureError)failure;

#if TARGET_OS_IOS

/// Add ZigBee devices to groups (interacting locally with gateways).
/// @param nodeList Zigbee sub-devce nodeId list.
/// @param success Called when the task finishes successfully.
/// @param failure Called when the task is interrupted by an error.
- (void)addZigbeeDeviceWithNodeList:(NSArray <NSString *>*)nodeList
                            success:(nullable TYSuccessHandler)success
                            failure:(nullable TYFailureError)failure;

/// Remove ZigBee devices from groups (interacting locally with gateways).
/// @param nodeList Zigbee subdevce nodeId list.
/// @param success Called when the task finishes successfully.
/// @param failure Called when the task is interrupted by an error.
- (void)removeZigbeeDeviceWithNodeList:(NSArray <NSString *>*)nodeList
                               success:(nullable TYSuccessHandler)success
                               failure:(nullable TYFailureError)failure;

#endif

/// Cancel Request
- (void)cancelRequest;


@end

NS_ASSUME_NONNULL_END

#endif
