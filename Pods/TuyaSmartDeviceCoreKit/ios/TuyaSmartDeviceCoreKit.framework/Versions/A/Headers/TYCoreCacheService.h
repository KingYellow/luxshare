//
// TYCoreCacheService.h
// TuyaSmartDeviceCoreKit
//
// Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com)

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol TYCoreCacheServiceDelegate <NSObject>

- (void)deviceWillRemove:(NSString *)devId;
- (void)groupWillRemove:(long long)groupId;


- (void)deviceWillAdd:(TuyaSmartDeviceModel *)deviceModel homeId:(long long)homeId;
- (void)groupWillAdd:(TuyaSmartGroupModel *)groupModel homeId:(long long)homeId;

- (void)deviceListWillAdd:(NSArray<TuyaSmartDeviceModel *> *)deviceList homeId:(long long)homeId;

@end

@interface TYCoreCacheService : NSObject

TYSDK_SINGLETON;

@property (nonatomic, weak) id<TYCoreCacheServiceDelegate> delegate;

/// Device cache.
@property (nonatomic, strong, readonly) NSMutableDictionary<NSString *, TuyaSmartDeviceModel *> *deviceData;

/// Group caching.
@property (nonatomic, strong, readonly) NSMutableDictionary<NSString *, TuyaSmartGroupModel *> *groupData;

/// Group product information cache.
@property (nonatomic, strong, readonly) NSMutableDictionary<NSString *, NSDictionary *> *groupProductData;

/// Group device relationship cache.
@property (nonatomic, strong, readonly) NSMutableDictionary<NSString *, NSArray<NSString *> *> *groupDeviceRelation;

/// Mesh information.
@property (nonatomic, strong, readonly) NSMutableDictionary<NSString *, TuyaSmartBleMeshModel *> *meshData;

/// Mesh Group information.
@property (nonatomic, strong, readonly) NSMutableDictionary *meshGroupAddData;


- (void)setCacheHandlerQueue:(dispatch_queue_t)queue;

- (void)reset;

- (TuyaSmartDeviceModel *)getDeviceInfoWithDevId:(NSString *)devId;

- (TuyaSmartGroupModel *)getGroupInfoWithGroupId:(long long)groupId;

- (NSDictionary *)getGroupProductWithProductId:(NSString *)productId;

- (NSArray <TuyaSmartDeviceModel *> *)getDeviceListWithGroupId:(long long)groupId;

- (void)updateGroupProductList:(NSArray <NSDictionary *> *)groupProductList;

- (void)updateDeviceGroupRelationWithDeviceList:(NSArray *)deviceList groupId:(long long)groupId;

- (void)updateDeviceGroupRelationWithDeviceList:(NSArray *)deviceList groupId:(long long)groupId shouldNotify:(BOOL)shouldNotify;

- (NSArray <TuyaSmartDeviceModel *> *)getAllDeviceList;
- (NSArray <TuyaSmartGroupModel *> *)getAllGroupList;

- (void)updateSharedDeviceList:(NSArray <TuyaSmartDeviceModel *> *)deviceList;

- (void)updateSharedGroupList:(NSArray <TuyaSmartGroupModel *> *)groupList;

- (NSArray <TuyaSmartDeviceModel *> *)getDeviceListWithHomeId:(long long)homeId;
// remove delegates

- (void)removeDeviceWithDevId:(NSString *)devId;
- (void)removeGroupWithGroupId:(long long)groupId;

// add delegate

- (void)addDeviceModel:(TuyaSmartDeviceModel *)deviceModel homeId:(long long)homeId;
- (void)addGroupModel:(TuyaSmartGroupModel *)groupModel homeId:(long long)homeId;

- (void)addDeviceModelList:(NSArray<TuyaSmartDeviceModel *> *)deviceModelList homeId:(long long)homeId;

// mesh
- (TuyaSmartBleMeshModel *)getMeshModelWithHomeId:(long long)homeId isSigMesh:(BOOL)isSigMesh;
- (TuyaSmartBleMeshModel *)getMeshModelWithMeshId:(NSString *)meshId;
- (void)updateMeshModel:(TuyaSmartBleMeshModel *)meshModel;
- (NSArray<TuyaSmartBleMeshModel *> *)getAllMeshList;

- (NSInteger)getMeshGroupAddressFromLocalWithMeshId:(NSString *)meshId;
- (NSInteger)getMeshGroupCountFromLocalWithMeshId:(NSString *)meshId;
- (void)removeMeshGroupWithAddress:(NSInteger)address meshId:(NSString *)meshId;

/// This is a special sharing type of device, such as sharing the family and sharing the device at the same time, to distinguish.
- (NSArray <NSString *> *)getSpecialSharedDevIds;

@end

NS_ASSUME_NONNULL_END
