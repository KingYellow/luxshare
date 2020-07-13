//
//  QZHUserModel.h
//  DDSample
//
//  Created by 黄振 on 2020/3/30.
//  Copyright © 2020 KingYellow. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QZHUserModel : NSObject

// 令牌
@property (strong, nonatomic)NSString *_token;

//用户名字
@property (strong, nonatomic)NSString *name;

//角色ID
@property (nonatomic, assign)double role_id;

// 账号ID
@property (nonatomic, assign)double userId;

@property (strong, nonatomic)NSString *phone;

//用户头像链接
@property (strong, nonatomic)NSString *headIconUrl;

//用户昵称
@property (strong, nonatomic)NSString *nickname;

//用户名。如果主账号是手机号，userName 就是手机号。如果主账号是邮箱，userName 就是邮箱
@property (strong, nonatomic)NSString *userName;

//手机号
@property (strong, nonatomic)NSString *phoneNumber;

//邮箱
@property (strong, nonatomic)NSString *email;

//国家码，86：中国，1：美国
@property (strong, nonatomic)NSString *countryCode;

//当前账号所在的国家区域。AY：中国，AZ：美国，EU：欧洲
@property (strong, nonatomic)NSString *regionCode;

//用户时区信息，例如： Asia/Shanghai
@property (strong, nonatomic)NSString *timezoneId;

//用户时区信息，例如：温度单位。1：°C， 2：°F
@property (strong, nonatomic)NSString *tempUnit;

//第三方账号的昵称
@property (strong, nonatomic)NSString *snsNickname;

//账号注册的类型
@property (assign, nonatomic)TYRegType regFrom;

//登录的状态
@property (assign, nonatomic)BOOL isLogin;

+ (QZHUserModel *)User;
+ (void)setModel:(QZHUserModel *)umodel;

@end

NS_ASSUME_NONNULL_END
