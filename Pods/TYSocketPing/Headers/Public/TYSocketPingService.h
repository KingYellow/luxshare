//
//  TYSocketPingService.h
//  TuyaSmartKit
//
//  Created by XuChengcheng on 2016/11/28.
//  Copyright © 2016年 Tuya. All rights reserved.
//


@interface TYSocketPingService : TuyaSmartRequest

- (void)addLog:(NSDictionary *)data success:(TYSuccessHandler)success failure:(TYFailureError)failure;

@end
