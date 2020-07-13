//
//  TuyaSmartCameraMessage.h
//  TuyaSmartCameraKit
//
//  Created by 傅浪 on 2019/8/12.
//

#import <Foundation/Foundation.h>
#import "TuyaSmartCameraMessageModel.h"

@interface TuyaSmartCameraMessage : NSObject

/**
 [^en]
 default is [NSTimeZone systemTimeZone]
 [$en]

 [^zh]
 默认为 [NSTimeZone systemTimeZone]
 [$zh]
 */
@property (nonatomic, strong) NSTimeZone *timeZone;

- (instancetype)initWithDeviceId:(NSString *)devId timeZone:(NSTimeZone *)timeZone;


/**
 [^en]
 get day list which has messages
 [$en]

 [^zh]
 获取有消息的日期
 [$zh]
 

 @param year [^en]year[$en] [^zh]年[$zh]
 @param month [^en]month[$en] [^zh]月[$zh]
 @param success callback
 @param failure callback
 */
- (void)messageDaysForYear:(NSInteger)year
                     month:(NSInteger)month
                   success:(void (^)(NSArray<NSString *> *result))success
                   failure:(void (^)(NSError *error))failure;

/**
 [^en]
 get message list
 [$en]

 [^zh]
 获取消息列表
 [$zh]
 

 @param msgCodes msgCodes
 @param offset [^en]offset[$en] [^zh]偏移量[$zh]
 @param limit [^en]page size[$en] [^zh]页大小[$zh]
 @param startTime [^en]pass 0 for no time limit[$en] [^zh]传入0代表没有时间限制[$zh]
 @param endTime [^en]end time[$en] [^zh]结束时间[$zh]
 @param success callback
 @param failure callback
 */
- (void)messagesWithMessageCodes:(NSArray *)msgCodes
                          Offset:(NSInteger)offset
                           limit:(NSInteger)limit
                       startTime:(NSInteger)startTime
                         endTime:(NSInteger)endTime
                         success:(void (^)(NSArray<TuyaSmartCameraMessageModel *> *result))success
                         failure:(void (^)(NSError *error))failure;

/**
[^en]
remove messages by message id list
[$en]

[^zh]
删除消息
[$zh]

 @param msgIds [^zh] 需要删除的消息的id数组 [$zh] [^en] message id array whitch need removed [$en]
 @param success callback
 @param failure callback
*/
- (void)removeMessagesWithMessageIds:(NSArray *)msgIds
                             success:(void (^)(void))success
                             failure:(void (^)(NSError *))failure;

/**
 [^en]
 get message schemes list
 [$en]

 [^zh]
 获取消息分类列表
 [$zh]
 
 @param success callback
 @param failure callback
 */
- (void)getMessageSchemes:(void (^)(NSArray<TuyaSmartCameraMessageSchemeModel *> *result))success
                  failure:(void (^)(NSError *error))failure;

@end

