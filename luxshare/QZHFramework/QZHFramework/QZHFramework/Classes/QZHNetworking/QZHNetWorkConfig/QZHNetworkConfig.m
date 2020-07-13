//
//  QZHConfigRequest.m
//  QZH
//
//  Created by 米翊米 on 2017/8/28.
//  Copyright © 2017年 🐨🐨🐨. All rights reserved.
//

#import "QZHNetworkConfig.h"

@implementation QZHNetworkConfig

/**
 配置全局参数使用
 
 @return 全局实例
 */
+(instancetype)globalCofig {
    static QZHNetworkConfig *config;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        config = [[QZHNetworkConfig alloc] init];
        config.timeoutInterval = 30;
        config.showHDU = YES;
    });
    
    return config;
}

/**
 创建网络请求配置

 @return QZHNetworkConfig
 */
+ (instancetype)config {
    QZHNetworkConfig *instance = [[QZHNetworkConfig alloc] init];
    
    //配置全局头、实体
    instance.severHost = [QZHNetworkConfig globalCofig].severHost;
    instance.requestMethod = [QZHNetworkConfig globalCofig].requestMethod;
    instance.requestFormat = [QZHNetworkConfig globalCofig].requestFormat;
    instance.responeFormat = [QZHNetworkConfig globalCofig].responeFormat;
    instance.timeoutInterval = [QZHNetworkConfig globalCofig].timeoutInterval;
    instance.showHDU = [QZHNetworkConfig globalCofig].showHDU;
    instance.params = [NSMutableDictionary dictionaryWithDictionary:[QZHNetworkConfig globalCofig].params];
    instance.headerFields = [NSMutableDictionary dictionaryWithDictionary:[QZHNetworkConfig globalCofig].headerFields];
    instance.requestAction = [QZHNetworkConfig globalCofig].requestAction;
    instance.responeAction = [QZHNetworkConfig globalCofig].responeAction;
    
    return instance;
}

/**
 移除不需要的全局header
 
 @param key header对应的key
 */
- (void)removeGlobalHeader:(NSString *)key  {
    [self.headerFields removeObjectForKey:key];
}

/**
 移除不需要的全局param
 
 @param key param对应的key
 */
- (void)removeGlobalParam:(NSString *)key {
    [self.params removeObjectForKey:key];
}

/**
 移除全局header
 */
- (void)removeGlobalHeaders {
    [self.headerFields removeAllObjects];
}

/**
 移除全局param
 */
- (void)removeGlobalParams {
    [self.params removeAllObjects];
}

/**
 根据请求参数格式，设置对应Content-Type

 @param requestFormat 请求参数格式
 */
- (void)setRequestFormat:(QZHRequestFormat)requestFormat {
    _requestFormat = requestFormat;
    switch (self.requestFormat) {
        case QZHRequestFormatJSON:
            self.headerFields[@"Content-Type"] = @"application/json;charset=utf-8";
            break;
        case QZHRequestFormatForm:
            self.headerFields[@"Content-Type"] = @"application/x-www-form-urlencoded;charset=utf-8";
            break;
        case QZHRequestFormatTextHtml:
            self.headerFields[@"Content-Type"] = @"text/html;charset=utf-8";
            break;
        case QZHRequestFormatTextPlain:
            self.headerFields[@"Content-Type"] = @"text/plain;charset=utf-8";
            break;
        case QZHRequestFormatMultipart:
            self.headerFields[@"Content-Type"] = @"multipart/form-data;charset=utf-8";
            break;
    }
}


/**
 请求body参数

 @return 请求body参数容器
 */
- (NSMutableDictionary *)params {
    if (!_params) {
        _params = [NSMutableDictionary dictionary];
    }
    
    return _params;
}


/**
 请求header参数

 @return 请求header参数容器
 */
- (NSMutableDictionary *)headerFields {
    if (!_headerFields) {
        _headerFields = [NSMutableDictionary dictionary];
    }
    
    return _headerFields;
}

@end
