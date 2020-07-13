//
//  QZHDataHelper.m
//  Helper
//
//  Created by 米翊米 on 2017/12/13.
//  Copyright © 2017年 🐨🐨🐨. All rights reserved.
//

#import "QZHDataHelper.h"

//用户信息存放文件
#define UserInfoPath  [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"app.data"]
//白名单key
#define WhiteList   @"WhiteList"

@implementation QZHDataHelper

+ (void)saveValue:(id)value forKey:(NSString *)key {
    if (!key && !value) {
        return;
    }
    NSMutableDictionary *dictionary = [NSKeyedUnarchiver unarchiveObjectWithFile:UserInfoPath];
    if (!dictionary) {
        dictionary = [NSMutableDictionary dictionary];
    }
    if (key && value) {
        dictionary[key] = value;
    } else if (!value && key) {
        [dictionary removeObjectForKey:key];
    }
    [NSKeyedArchiver archiveRootObject:dictionary toFile:UserInfoPath];
}

+ (id)readValueForKey:(NSString *)key {
    NSMutableDictionary *dictory = [NSKeyedUnarchiver unarchiveObjectWithFile:UserInfoPath];
    return dictory[key];
}

+ (void)removeAll {
    NSMutableDictionary *dictionary = [NSKeyedUnarchiver unarchiveObjectWithFile:UserInfoPath];
    NSMutableArray *keys = dictionary[WhiteList];
    if (keys.count == 0 || !keys) {
        [[NSFileManager defaultManager] removeItemAtPath:UserInfoPath error:nil];
    } else {
        for (NSString *key in dictionary.allKeys) {
            if (![keys containsObject:key]) {
                [dictionary removeObjectForKey:key];
            }
        }
        [NSKeyedArchiver archiveRootObject:dictionary toFile:UserInfoPath];
    }
}

+ (void)removeForKey:(NSString *)key {
    NSMutableDictionary *dictionary = [NSKeyedUnarchiver unarchiveObjectWithFile:UserInfoPath];
    [dictionary removeObjectForKey:key];
    if (dictionary) {
        [NSKeyedArchiver archiveRootObject:dictionary toFile:UserInfoPath];
    } else {
        [self removeAll];
    }
}

///加入白名单，防止清除数据时清除必须数据
+ (void)addWhiteList:(NSString *)key {
    if (!key) {
        return;
    }
    NSMutableDictionary *dictionary = [NSKeyedUnarchiver unarchiveObjectWithFile:UserInfoPath];
    if (!dictionary) {
        dictionary = [NSMutableDictionary dictionary];
    }
    NSMutableArray *keys = dictionary[WhiteList];
    if (!keys) {
        keys = [NSMutableArray array];
        [keys addObject:WhiteList];
    }
    if (![keys containsObject:key]) {
        [keys addObject:key];
        dictionary[WhiteList] = keys;
        [NSKeyedArchiver archiveRootObject:dictionary toFile:UserInfoPath];
    }
}

///移除白名单，key为空移除所有
+ (void)removeWhiteList:(NSString *)key {
    NSMutableDictionary *dictionary = [NSKeyedUnarchiver unarchiveObjectWithFile:UserInfoPath];
    NSMutableArray *keys = dictionary[WhiteList];
    if (key) {
        [keys removeObject:key];
        dictionary[WhiteList] = keys;
        [NSKeyedArchiver archiveRootObject:dictionary toFile:UserInfoPath];
    } else {
        [dictionary removeObjectForKey:WhiteList];
        [NSKeyedArchiver archiveRootObject:dictionary toFile:UserInfoPath];
    }
}

@end
