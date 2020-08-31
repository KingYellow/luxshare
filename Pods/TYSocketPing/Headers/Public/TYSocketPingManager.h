//
//  TYSocketPingManager.h
//  STPingTest
//
//  Created by XuChengcheng on 2016/11/28.
//  Copyright © 2016年 Suen. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TYSocketPingManagerDelegate <NSObject>

@optional

- (void)ty_socketPingWithAllCount:(NSInteger)allCount receivedCount:(NSInteger)receivedCount minElapsed:(float)minElapsed maxElapsed:(float)maxElapsed averageElapsed:(float)averageElapsed;

@end

@interface TYSocketPingManager : NSObject

+ (instancetype)sharedInstance;

@property (nonatomic, weak) id<TYSocketPingManagerDelegate> delegate;

- (void)startPingSocketWithAddress:(NSString *)address timeout:(NSInteger)timeout pingTimes:(NSInteger)pingTimes needLog:(BOOL)needLog token:(NSString *)token;
- (void)cancel;

@end
