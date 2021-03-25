//
//  TYSmartHouseIndexProtocol.h
//  Pods
//
//  Created by 房栋 on 2018/4/20.
//

#import <Foundation/Foundation.h>

@protocol TYSmartHouseIndexProtocol <NSObject>

/**
 判断当前家庭是否是管理员身份
 
 @return YES or NO
 */
- (BOOL)homeAdminValidation;

@end
