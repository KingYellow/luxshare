//
//  QZHNetEnum.h
//  QZH
//
//  Created by 米翊米 on 2018/5/25.
//  Copyright © 2018年 米翊米. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 响应状态
 
 - QZHNetCodeSuccess: 成功
 - QZHNetCodeRedirect: 重定向
 - QZHNetCodeReject: 拒绝访问,
 - QZHNetCodeNotFount: 资源不存在,
 - QZHNetCodeForbiden: 禁止访问
 - QZHNetCodeTimeout: 超时,
 - QZHNetCodeServiceError: 服务端内部错误
 - QZHNetCodeCancel: 取消请求
 */
typedef NS_ENUM(NSInteger, QZHNetCode) {
    QZHNetCodeSuccess = 200,
    QZHNetCodeRedirect = 302,
    QZHNetCodeReject = 403,
    QZHNetCodeNotFount = 404,
    QZHNetCodeForbiden = 405,
    QZHNetCodeTimeout = 408,
    QZHNetCodeServiceError = 500,
    QZHNetCodeCancel = -999,
};

/**
 请求方式
 
 - QZHRequestMethodPOST: post
 - QZHRequestMethodGET: get
 - QZHRequestMethodPUT: put
 - QZHRequestMethodPUT: patch
 - QZHRequestMethodHEAD: patch
 - QZHRequestMethodDELETE: patch
 */
typedef NS_ENUM(NSInteger, QZHRequestMethod) {
    QZHRequestMethodPOST = 0,
    QZHRequestMethodGET,
    QZHRequestMethodPUT,
    QZHRequestMethodPATCH,
    QZHRequestMethodHEAD,
    QZHRequestMethodDELETE,
};

/**
 请求参数格式
 
 - QZHRequestFormatJSON: application/json
 - QZHRequestFormatForm: application/x-www-form-urlencoded
 - QZHRequestFormatTextPlain: text/plain
 - QZHRequestFormatTextHtml: text/html
 - QZHRequestFormatMultipart: multipart/form-data
 */
typedef NS_ENUM(NSInteger, QZHRequestFormat) {
    QZHRequestFormatJSON = 0,
    QZHRequestFormatForm,
    QZHRequestFormatTextPlain,
    QZHRequestFormatTextHtml,
    QZHRequestFormatMultipart,
};

/**
 请求参数格式
 
 - QZHResponeTypeDefault: 文本格式
 - QZHResponeTypeJSON: json格式
 - QZHResponeTypeXML: xml格式
 */
typedef NS_ENUM(NSInteger, QZHResponeFormat) {
    QZHResponeFormatText = 0,
    QZHResponeFormatJSON,
    QZHResponeFormatXML,
};

/**
 网络状态
 
 - QZHNetworkStatusUnkown: 未知网络
 - QZHNetworkStatusNotReachable: 无连接
 - QZHNetworkStatusReachableViaWWAN: 运营商网络
 - AQZHNetworkStatusReachableViaWiFi: WIFI
 */
typedef NS_ENUM(NSInteger, QZHNetworkStatus) {
    QZHNetworkStatusUnkown = -1,
    QZHNetworkStatusNotReachable = 0,
    QZHNetworkStatusReachableViaWWAN = 1,
    QZHNetworkStatusReachableViaWiFi = 2,
};

/**
 网络状态变化
 
 @param status 网络状态
 */
typedef void(^NetworkStatusHandler)(QZHNetworkStatus status, NSString *describe);
