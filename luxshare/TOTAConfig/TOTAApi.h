//
//  QZHApi.h
//  DDSample
//
//  Created by 黄振 on 2020/3/30.
//  Copyright © 2020 KingYellow. All rights reserved.
//

#ifndef QZHApi_h
#define QZHApi_h

#if APPEnvironment == 0
    //测试环境地址
    static NSString * QZHApiHost = @"http://121.199.53.9:7792/";
    static NSString * QZHWebHost = @"http://121.199.53.9:7792/";
    static NSString * QZHPicHost = @"http://121.199.53.9:7792/";
#else
    //发布环境地址
    static NSString * QZHApiHost = @"http://121.199.53.9:7792/";
    static NSString * QZHWebHost = @"http://121.199.53.9:7792/";
    static NSString * QZHPicHost = @"http://121.199.53.9:7792/";
#endif
// --------------------------server host----------------------
// 分页数据条数
static NSInteger const QZHApiPageSize = 10;

// --------------------------server host-------------------------

// --------------------------Api path----------------------
//登录
static NSString * const Api_Login = @"login";
//发送验证码校验手机号
static NSString * const Api_SendCode = @"sms/send";


//上传图片
static NSString * const Api_UploadImage = @"api/upload/upload-image";

#endif /* QZHApi_h */
