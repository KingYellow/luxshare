//
// TuyaSmartStatusSchemaModel.h
// TuyaSmartDeviceCoreKit
//
// Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com)

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// Reported Mapping Policies.
@interface TuyaSmartStatusSchemaModel : NSObject

@property (nonatomic, strong) NSString     *strategyValue; /// Mapping Rules.
@property (nonatomic, strong) NSString     *strategyCode; /// Policy designators, currently supporting more than 10.
@property (nonatomic, strong) NSString     *dpCode; /// The reported dpId corresponds to a dpCode that is not a standard dpCode.
@property (nonatomic, strong) NSString     *standardType; /// DpValue type after standard.


@end

/// Distributed mapping strategy.
@interface TuyaSmartFunctionSchemaModel : NSObject

@property (nonatomic, strong) NSString     *strategyCode; /// At present, more than 10 kinds of policy codes are supported.
@property (nonatomic, strong) NSString     *strategyValue; /// Mapping rules.
@property (nonatomic, strong) NSString     *standardCode; /// Standardized dpcode.
@property (nonatomic, strong) NSString     *standardType; /// Dpvalue type after standard.

@end


@interface TuyaSmartStandSchemaModel : NSObject

@property (nonatomic, assign) BOOL isProductCompatibled;

@property (nonatomic, strong) NSArray<TuyaSmartStatusSchemaModel *> *statusSchemaList;

@property (nonatomic, strong) NSArray<TuyaSmartFunctionSchemaModel *> *functionSchemaList;

@end

NS_ASSUME_NONNULL_END
