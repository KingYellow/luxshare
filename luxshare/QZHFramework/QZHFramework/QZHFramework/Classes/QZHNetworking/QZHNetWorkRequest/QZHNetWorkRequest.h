//
//  QZHNetWorkRequest.h
//  QZH
//
//  Created by 米翊米 on 2017/8/28.
//  Copyright © 2017年 🐨🐨🐨. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QZHNetworkConfig.h"

@interface QZHNetWorkRequest : NSObject

/**
 单例

 @return 实例
 */
+ (instancetype)shareResuest;

/**
 取消所有请求
 */
+ (void)cancleAllRequest;

/**
 根据请求路径取消请求

 @param path 请求路径(http://xxx/xxx)
 */
+ (void)cancleRequest:(NSString *)path;

/**
 网络请求入口
 
 @param config 网络请求配置[QZHNetworkConfig config]
 @param completeResult 网络请求结果回调
 */
- (instancetype)fetchConfig:(QZHNetworkConfig *)config result:(ResponeHandler)completeResult;
- (instancetype)fetchConfigBlock:(RequestHandler)configBlock result:(ResponeHandler)completeResult;

/**
 上传文件

 @param config 网络请求配置[QZHNetworkConfig config]
 @param completeResult 网络请求结果回调
 */
- (instancetype)uploadFileConfig:(QZHNetworkConfig *)config result:(ResponeHandler)completeResult;
- (instancetype)uploadFileConfigBlock:(RequestHandler)configBlock result:(ResponeHandler)completeResult;

@end
