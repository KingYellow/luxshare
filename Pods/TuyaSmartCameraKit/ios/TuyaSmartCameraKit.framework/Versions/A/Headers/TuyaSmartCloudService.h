//
//  TuyaSmartCloudService.h
//  TuyaSmartCamera_Example
//
//  Created by 傅浪 on 2019/3/27.
//  Copyright © 2019 fulang@tuya.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TuyaSmartBaseKit/TuyaSmartBaseKit.h>

@interface TuyaSmartCloudService : TuyaSmartRequest


- (void)requestCloudStorageStateWithParams:(NSDictionary *)params success:(TYSuccessString)success failure:(TYFailureError)failure;

- (void)requestCloudStorageCountWithDeviceId:(NSString *)devId success:(TYSuccessList)success failure:(TYFailureError)failure;

- (void)requestCloudStorageSecretWithDeviceId:(NSString *)devId success:(TYSuccessString)success failure:(TYFailureError)failure;

- (void)requestCloudStoragePrefixsWithParams:(NSDictionary *)params success:(TYSuccessID)success failure:(TYFailureError)failure;

- (void)requestCloudStorageTimelineWithParams:(NSDictionary *)params success:(TYSuccessList)success failure:(TYFailureError)failure;

- (void)requestCloudStorageEventWithParams:(NSDictionary *)params success:(TYSuccessList)success failure:(TYFailureError)failure;

- (void)requestCloudStorageAuthorityWithDeviceId:(NSString *)devId success:(TYSuccessID)success failure:(TYFailureError)failure;

/// V2
- (void)requestCloudStorageAuthorityWithDeviceId:(NSString *)devId bukets:(NSString*)bukets success:(TYSuccessID)success failure:(TYFailureError)failure;

@end

