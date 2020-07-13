//
//  QZHDataHelper.h
//  Helper
//
//  Created by 米翊米 on 2017/12/13.
//  Copyright © 2017年 🐨🐨🐨. All rights reserved.
//

#import <Foundation/Foundation.h>

// --------------------------NSUserDefaults----------------------
#define QZHUserDefault               [NSUserDefaults standardUserDefaults]
#define QZHDataRead(key)             [QZHUserDefault objectForKey:key]
#define QZHDataSave(value, key)      [QZHUserDefault setValue:value forKey:key]; [QZHUserDefault synchronize];
// --------------------------NSUserDefaults-------------------------

@interface QZHDataHelper : NSObject

/**
 保存数据

 @param value 存储的数据
 @param key 存储key
 */
+ (void)saveValue:(id)value forKey:(NSString *)key;

/**
 获取存储值

 @param key 获取数据的key
 @return 返回key对应值
 */
+ (id)readValueForKey:(NSString *)key;

/**
 清空用户数据存储
 */
+ (void)removeAll;

/**
 根据key清除对应数据

 @param key key
 */
+ (void)removeForKey:(NSString *)key;

///加入白名单，防止清除数据时清除必须数据
+ (void)addWhiteList:(NSString *)key;

///移除白名单，key为空移除所有
+ (void)removeWhiteList:(NSString *)key;

@end
