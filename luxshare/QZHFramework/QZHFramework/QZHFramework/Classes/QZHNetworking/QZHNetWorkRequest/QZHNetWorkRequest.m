//
//  QZHNetWorkRequest.m
//  QZH
//
//  Created by 米翊米 on 2017/8/28.
//  Copyright © 2017年 🐨🐨🐨. All rights reserved.
//

#import "QZHNetWorkRequest.h"
#import "AFNetworking.h"

//weak self
#define QZHWS(weakSelf)            __weak __typeof(&*self)weakSelf = self;
#define NetworkComplete     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable \
                    responseObject) { \
                        [weakSelf fetchSuccess:config task:task response:responseObject result:completeResult]; \
                    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) { \
                        [weakSelf fetchFailed:config task:task response:error result:completeResult]; \
                    }

@interface QZHNetWorkRequest ()

@property (nonatomic, strong) AFHTTPSessionManager *manager;
@property (nonatomic, strong, readwrite) NSString *cookies;
@property (nonatomic, strong) NSMutableArray <NSURLSessionDataTask *>*requestTasks;

@end

@implementation QZHNetWorkRequest

+ (instancetype)shareResuest {
    static QZHNetWorkRequest *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[QZHNetWorkRequest alloc] init];
        instance.manager = [[AFHTTPSessionManager alloc] init];
        
        instance.requestTasks = [[NSMutableArray alloc] init];
    });
    
    return instance;
}

#pragma mark - 取消请求

/**
 取消所有请求
 */
+ (void)cancleAllRequest {
    for (NSURLSessionTask *task in QZHNetWorkRequest.shareResuest.requestTasks) {
        [task cancel];
    }
    [QZHNetWorkRequest.shareResuest.requestTasks removeAllObjects];
}

/**
 根据请求路径取消请求
 
 @param path 请求路径(http://xxx/xxx)
 */
+ (void)cancleRequest:(NSString *)path {
    for (NSURLSessionDataTask *task in QZHNetWorkRequest.shareResuest.requestTasks) {
        if ([task.originalRequest.URL.absoluteString isEqualToString:path]) {
            NSLog(@"%@请求已取消", path);
            [task cancel];
            [QZHNetWorkRequest.shareResuest.requestTasks removeObject:task];
            return;
        }
    }
}

#pragma mark -设置https模式
- (void)setHttps:(QZHNetworkConfig *)config {
    if (config.cerName) {
        NSArray *cers = [config.cerName componentsSeparatedByString:@"."];
        NSString *cerPath = [[NSBundle mainBundle] pathForResource:cers.firstObject ofType:@"cer"];
        NSData *cerData = [NSData dataWithContentsOfFile:cerPath];
        if (cerData) {
            [self.manager.securityPolicy setPinnedCertificates:[NSSet setWithObject:cerData]];
        }
    } else {
        self.manager.securityPolicy.allowInvalidCertificates = YES;
        self.manager.securityPolicy.validatesDomainName = NO;
    }
}

#pragma mark - 普通请求
/**
 网络请求入口

 @param config 网络请求配置，可为空，为空时默认为config
 @param completeResult 网络请求结果回调
 */
- (instancetype)fetchConfig:(QZHNetworkConfig *)config result:(ResponeHandler)completeResult {
    [self executeConfig:config Result:completeResult];
    
    return self;
}

/**
 网络请求入口（block方式）

 @param configBlock 请求配置
 @param completeResult 网络请求结果回调
 */
- (instancetype)fetchConfigBlock:(RequestHandler)configBlock result:(ResponeHandler)completeResult {
    QZHNetworkConfig *config = [QZHNetworkConfig config];
    configBlock(config);
    
    if (config.severHost.length > 0) {
        [self executeConfig:config Result:completeResult];
    } else {
        completeResult(nil);
        NSLog(@"server is empty!!!");
    }
    
    return self;
}

/**
 执行请求
 
 @param config 请求配置
 @param completeResult 请求结果
 */
- (void)executeConfig:(QZHNetworkConfig *)config Result:(ResponeHandler)completeResult {
//    //请求时要做的动作
//    if (config.requestAction) {
//        config.requestAction(config);
//    }
//    //配置
//    [self networkConfig:config];
//
//    NSURLSessionDataTask *task;
//    QZHWS(weakSelf);
//    switch (config.requestMethod) {
//        case QZHRequestMethodPOST:
//            if (config.requestFormat == QZHRequestFormatMultipart) {
//                [self uploadFileConfig:config result:completeResult];
//            } else {
//                task = [self.manager POST:config.severPath parameters:config.params progress:nil NetworkComplete];
//            }
//            break;
//        case QZHRequestMethodGET:
//        {
//            task = [self.manager GET:config.severPath parameters:config.params progress:nil NetworkComplete];
//        }
//            break;
//        case QZHRequestMethodPUT:
//        {
//            task = [self.manager PUT:config.severPath parameters:config.params NetworkComplete];
//        }
//            break;
//        case QZHRequestMethodPATCH:
//        {
//            task = [self.manager PATCH:config.severPath parameters:config.params NetworkComplete];
//        }
//            break;
//        case QZHRequestMethodHEAD:
//        {
//            task = [self.manager HEAD:config.severPath parameters:config.params success:^(NSURLSessionDataTask * _Nonnull task) {
//                [weakSelf fetchSuccess:config task:task response:nil result:completeResult];
//            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//                [weakSelf fetchFailed:config task:task response:error result:completeResult];
//            }];
//        }
//            break;
//        case QZHRequestMethodDELETE:
//        {
//            task = [self.manager DELETE:config.severPath parameters:config.params NetworkComplete];
//        }
//            break;
//    }
//    if (task) {
//        [QZHNetWorkRequest.shareResuest.requestTasks addObject:task];
//    }
}

#pragma mark - 文件上传
/**
 上传文件/表单提交

 @param config 请求配置
 @param completeResult 请求结果
 */
- (instancetype)uploadFileConfig:(QZHNetworkConfig *)config result:(ResponeHandler)completeResult {
    QZHWS(weakSelf);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf executeUploadConfig:config Result:completeResult];
    });
    
    return self;
}

/**
 上传文件/表单提交（block）
 
 @param configBlock 请求配置
 @param completeResult 请求结果
 */
- (instancetype)uploadFileConfigBlock:(RequestHandler)configBlock result:(ResponeHandler)completeResult {
    QZHNetworkConfig *config = [QZHNetworkConfig config];
    configBlock(config);
    
    if (config.severHost.length > 0) {
        QZHWS(weakSelf);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf executeUploadConfig:config Result:completeResult];
        });
    }  else {
        completeResult(nil);
        NSLog(@"server is empty!!!");
    }

    return self;
}

/**
 执行操作
 
 @param config 请求配置
 @param completeResult 请求结果
 */
- (void)executeUploadConfig:(QZHNetworkConfig *)config Result:(ResponeHandler)completeResult {
//    //请求时要做的动作
//    if (config.requestAction) {
//        config.requestAction(config);
//    }
//    //配置
//    [self networkConfig:config];
//
//    QZHWS(weakSelf);
//    config.requestFormat = QZHRequestFormatMultipart;
//    NSURLSessionDataTask *task = [self.manager POST:config.severPath parameters:config.params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
//        for (QZHFileModel *model in config.fileDatas) {
//            if (!model.fileData) {
//                NSLog(@"fileData is empty!!!");
//                [weakSelf fetchFailed:config task:nil response:nil result:completeResult];
//                return;
//            }
//
//            if (!model.fileName || model.fileName.length <= 0) {
//                NSDate *date = [NSDate date];
//                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//                [dateFormatter setDateFormat:@"yyyyMMddHHmmssSSS"];
//                NSString *timeStr = [dateFormatter stringFromDate:date];
//                NSString *randStr = [NSString stringWithFormat:@"%u", arc4random()%100000+10000];
//                model.fileName = [NSString stringWithFormat:@"file%@%@%@", timeStr, randStr, model.fileExp];
//            }
//            [formData appendPartWithFileData:model.fileData name:model.fileKey fileName:model.fileName mimeType:model.fileType];
//        }
//    } progress:^(NSProgress * _Nonnull uploadProgress) {
//
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        [weakSelf fetchSuccess:config task:task response:responseObject result:completeResult];
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        [weakSelf fetchFailed:config task:task response:error result:completeResult];
//    }];
//
//    if (task) {
//        [QZHNetWorkRequest.shareResuest.requestTasks addObject:task];
//    }
}


#pragma mark - 请求结果
/**
 请求成功

 @param config 请求配置
 @param task 原始数据
 @param responseObject 成功结果数据
 @param completeResult 成功回调
 */
- (void)fetchSuccess:(QZHNetworkConfig *)config task:(NSURLSessionDataTask * _Nonnull)task response:(id  _Nullable)responseObject result:(ResponeHandler)completeResult {
    NSHTTPURLResponse *HTTPResponse = (NSHTTPURLResponse *)task.response;
                              
    QZHRespModel *model = [QZHRespModel yy_modelWithJSON:responseObject];
    model.responseObject = responseObject;
    model.config = config;
    model.respHeaderFields = [HTTPResponse allHeaderFields];
    if (config.responeAction) {
        config.responeAction(model);
    }
    if (completeResult) {
        completeResult(model);
    }
    
    if (task) {
        [QZHNetWorkRequest.shareResuest.requestTasks removeObject:task];
    }
    
    NSURLRequest *httpRequest = (NSURLRequest *)task.currentRequest;
    NSLog(@"url = %@\n RequestHeaderFields = %@\n ResponseHeaderFields = %@\n params = %@\n error = %@", config.severPath, httpRequest.allHTTPHeaderFields, HTTPResponse.allHeaderFields, config.params, model.responseObject);
}

/**
 请求失败

 @param config 请求配置
 @param error 失败信息
 @param completeResult 失败回调
 */
- (void)fetchFailed:(QZHNetworkConfig *)config task:(NSURLSessionDataTask *)task response:(NSError *)error result:(ResponeHandler)completeResult {
    NSURLRequest *httpRequest = (NSURLRequest *)task.currentRequest;
    NSHTTPURLResponse *HTTPResponse = (NSHTTPURLResponse *)task.response;
    
    QZHRespModel *model = [[QZHRespModel alloc] init];
    model.config = config;
    model.respHeaderFields = [HTTPResponse allHeaderFields];
    NSString *message;
    switch (error.code) {
        case QZHNetCodeRedirect:
            message = @"请求资源重定向";
            break;
        case QZHNetCodeReject:
        case QZHNetCodeForbiden:
            message = @"请求资源被拒绝";
            break;
        case QZHNetCodeTimeout:
            message = @"请求资源超时";
            break;
        case QZHNetCodeServiceError:
            message = @"服务端错误";
            break;
        case QZHNetCodeCancel:
            break;
        default:
            message = @"网络错误";
            break;
    }
    NSLog(@"%@", message);
    model.message = message;
    
    if (config.responeAction) {
        config.responeAction(model);
    }
    if (completeResult) {
        completeResult(model);
    }
    if (task) {
        [QZHNetWorkRequest.shareResuest.requestTasks removeObject:task];
    }
    
    NSLog(@"url = %@\n RequestHeaderFields = %@\n ResponseHeaderFields = %@\n params = %@\n error = %@", config.severPath, httpRequest.allHTTPHeaderFields, HTTPResponse.allHeaderFields, config.params, error.description);
}

#pragma mark - 配置
/**
 根据配置参数配置
 */
- (void)networkConfig:(QZHNetworkConfig *)config {
    //请求数据格式
    QZHRequestFormat paramsFormat = config.requestFormat;
    
    switch (paramsFormat) {
        case QZHRequestFormatForm:
            self.manager.requestSerializer = [AFHTTPRequestSerializer serializer];
            break;
        case QZHRequestFormatJSON:
        case QZHRequestFormatMultipart:
        case QZHRequestFormatTextHtml:
        case QZHRequestFormatTextPlain:
            self.manager.requestSerializer = [AFJSONRequestSerializer serializer];
            break;
    }
    //响应数据格式
    switch (config.responeFormat) {
        case QZHResponeFormatText:
            self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            break;
        case QZHResponeFormatJSON:
            self.manager.responseSerializer = [AFJSONResponseSerializer serializer];
            break;
        case QZHResponeFormatXML:
            self.manager.responseSerializer = [AFXMLParserResponseSerializer serializer];
            break;
        default:
            break;
    }
    self.manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
    self.manager.requestSerializer.stringEncoding = NSUTF8StringEncoding;
    self.manager.requestSerializer.HTTPShouldHandleCookies = NO;
    self.manager.requestSerializer.timeoutInterval = config.timeoutInterval;
    [self setHttps:config];
    
    NSString *path = config.severHost;
    if (config.severPath) {
        path = [path stringByAppendingString:config.severPath];
    }
    config.severPath = path;
    
    //设置头部参数
    NSArray *headers = [config.headerFields allKeys];
    for (NSString *key in headers) {
        NSString *value = config.headerFields[key];;
        [self.manager.requestSerializer setValue:value forHTTPHeaderField:key];
    }
}

@end
