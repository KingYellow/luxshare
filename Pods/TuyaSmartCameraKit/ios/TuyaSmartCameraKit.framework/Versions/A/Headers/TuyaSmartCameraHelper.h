//
//  TuyaSmartCameraHelper.h
//  TuyaSmartCameraKit
//
//  Created by 傅浪 on 2020/3/12.
//

#import <Foundation/Foundation.h>
#import <TuyaSmartCameraBase/TuyaSmartCameraBase.h>

@interface TuyaSmartCameraAbility : TuyaSmartCameraConfig

/// 设备支持几路码流
@property (nonatomic, assign, readonly) NSInteger videoNum;

/// 全景摄像机图像参数
@property (nonatomic, strong, readonly) NSDictionary *panoramicParams;

/// 设备是否支持扬声器
@property (nonatomic, assign, readonly) BOOL isSupportSpeaker;

/// 设备是否支持声音采集
@property (nonatomic, assign, readonly) BOOL isSupportPickup;

/// 设备默认的对讲方式
@property (nonatomic, assign, readonly) TuyaSmartCameraTalkbackMode defaultTalkbackMode;

/// 是否支持切换对讲模式
@property (nonatomic, assign, readonly) BOOL couldChangeTalkbackMode;

/// 设备默认清晰度
@property (nonatomic, assign, readonly) TuyaSmartCameraDefinition defaultDefinition;

/// 原始数据
@property (nonatomic, strong, readonly) NSDictionary *rowData;


- (instancetype)initWithUid:(NSString *)uid traceId:(NSString *)traceId configData:(NSDictionary *)configData;

@end

@interface TuyaSmartCameraHelper : NSObject

+ (void)requestConfigDataWithDeviceId:(NSString *)devId traceId:(NSString *)traceId success:(void(^)(NSDictionary *result))success failure:(void(^)(NSError *error))failure;

@end

