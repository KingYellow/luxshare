//
//  QZHConfigRequest.h
//  QZH
//
//  Created by 米翊米 on 2017/8/28.
//  Copyright © 2017年 🐨🐨🐨. All rights reserved.
//

#import "QZHNetworkConfig.h"
#import "QZHNetEnum.h"
#import "QZHFileModel.h"
#import "QZHRespModel.h"

@class QZHNetworkConfig;

///请求回调
typedef void(^RequestHandler)(QZHNetworkConfig *config);
///响应回调
typedef void(^ResponeHandler)(QZHRespModel *model);

@interface QZHNetworkConfig : NSObject

/**
 配置全局参数使用

 @return 全局实例
 */
+(instancetype)globalCofig;

/**
 网络请求配置

 @return 配置实例
 */
+ (instancetype)config;

/**
 移除不需要的全局header

 @param key header对应的key
 */
- (void)removeGlobalHeader:(NSString *)key;

/**
 移除不需要的全局param
 
 @param key param对应的key
 */
- (void)removeGlobalParam:(NSString *)key;

/**
 移除全局header
 */
- (void)removeGlobalHeaders;

/**
 移除全局param
 */
- (void)removeGlobalParams;

/**
 网络请求开始时操作(这里可以添加弹窗提示等)
 */
@property (nonatomic, strong) RequestHandler requestAction;

/**
 网络请求结束响应操作(根据返回结果的操作，比如token失效退出app)
 */
@property (nonatomic, strong) ResponeHandler responeAction;

/**
 请求服务端主机地址
 */
@property (nonatomic, copy)NSString *severHost;

/**
 请求服务端路径
 */
@property (nonatomic, copy)NSString *severPath;

/**
 请求服务端超时时间，默认30s
 */
@property (nonatomic, assign)NSInteger timeoutInterval;

/**
 请求头设置如Accept等
 */
@property (nonatomic, strong)NSMutableDictionary *headerFields;

/**
 请求方式post/get/put, 默认为post
 */
@property (nonatomic, assign)QZHRequestMethod requestMethod;

/**
 请求参数格式--Content-Type，默认为QZHParamsTypeJSON
 */
@property (nonatomic, assign)QZHRequestFormat requestFormat;

/**
 请求响应格式，默认为QZHResponeTypeDefault
 */
@property (nonatomic, assign)QZHResponeFormat responeFormat;

/**
 请求参数
 */
@property (nonatomic, strong)NSMutableDictionary *params;

///https加密cer证书路径例如my.cer
@property (nonatomic, strong) NSString *cerName;

/**
 文件数组类型（FileModel）
 */
@property (nonatomic, strong) NSArray <QZHFileModel *>*fileDatas;

/**
 是否显示HUD
 */
@property (nonatomic, assign)BOOL showHDU;

@end
