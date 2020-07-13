//
//  UMengEngine.h
//  luxshare
//
//  Created by 黄振 on 2020/6/23.
//  Copyright © 2020 KingYellow. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UMengEngine : NSObject
+(instancetype)umengInstance;
+(void)closePush;
+(void)startPush;

//注册token
-(void)umRemoteDeviceToken:(NSData *)deviceToken;
- (void)umDidReceiveRemoteNotification:(NSDictionary *)userinfo;
-(void)umApplicationDidBecomeActive;

//提交cid
- (void)submitCid;
@end

NS_ASSUME_NONNULL_END
