//
//  NSString+Exp.h
//  MYM
//
//  Created by 米翊米 on 2018/6/5.
//  Copyright © 2018年 米翊米. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Exp)

///字符串为空判断
+ (BOOL)exp_isBlankString:(NSString *)oriString;

/// 空字符处理
+ (NSString *)exp_nullSafe:(NSString *)string;

///时间戳转格式化时间字符串 (eg. 20180912)
- (NSString *)exp_dateFormart:(NSString *)formart;

//格式化时间字符串计算与当前时间的间隔(eg. 刚刚、5分钟前、1小时前，4天前、3个月前，1年前)
- (NSString *)exp_compareFormart:(NSString *)formart;

/// 获取连接指定参数值
+ (NSString *)exp_paramValueOfUrl:(NSString *)url withParam:(NSString *)param;

///补全url 拼接完整的连接(http://xxxx/xxx.jpg)
- (NSString *)exp_urlCompelete:(NSString *)domain;

/// 去掉头尾的空白字符
- (NSString *)exp_trimEndWhiteSpace;

/// 去掉整段文字内的所有空白字符（包括换行符）
- (NSString *)exp_trimAllWhiteSpace;

/// 将文字中的换行符替换为空格
- (NSString *)exp_trimLineBreakCharacter;

/// 把该字符串转换为对应的 md5
- (NSString *)exp_mD5;

/// 判断是否为整型
- (BOOL)exp_isPureInt;

///判断是否为浮点型
- (BOOL)exp_isPureFloat;

/// 判断是否为长浮点型
- (BOOL)exp_isPureDobule;

/// 判断是否是纯数字
- (BOOL)exp_isPureNumber;

///除去空格后文本长度
- (NSInteger)exp_Length;

///文本反转
- (NSString *)exp_reversed;

@end
