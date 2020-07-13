//
//  QZHRespModel.h
//  FrameworkDemo
//
//  Created by 米翊米 on 2018/7/5.
//  Copyright © 2018年 米翊米. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYModel/YYModel.h>
#import "QZHNetEnum.h"

@class QZHNetworkConfig;

@interface QZHRespModel : NSObject

@property (nonatomic, assign) NSNumber *status;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) id data;

@property (nonatomic, weak) QZHNetworkConfig *config;
@property (nonatomic, strong) NSDictionary *respHeaderFields;
@property (nonatomic, strong) id responseObject;

@end
