//
//  TYSocketPingModel.h
//  TuyaSmartKit
//
//  Created by XuChengcheng on 2016/11/28.
//  Copyright © 2016年 Tuya. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, TYSocketPingStatus) {
    TYSocketPingStatusDidStart,
    TYSocketPingStatusDidFailToSendPacket,
    TYSocketPingStatusDidReceivePacket,
    TYSocketPingStatusDidReceiveUnexpectedPacket,
    TYSocketPingStatusDidTimeout,
    TYSocketPingStatusError,
    TYSocketPingStatusFinished,
};

@interface TYSocketPingModel : NSObject

@property(nonatomic, strong) NSString *originalAddress;
@property(nonatomic, strong) NSString *IPAddress;

@property(nonatomic, assign) NSUInteger dateBytesLength;
@property(nonatomic, assign) double     timeMilliseconds;
@property(nonatomic, assign) NSInteger  timeToLive;
@property(nonatomic, assign) NSInteger  ICMPSequence;

@property(nonatomic, assign) TYSocketPingStatus status;

@end
