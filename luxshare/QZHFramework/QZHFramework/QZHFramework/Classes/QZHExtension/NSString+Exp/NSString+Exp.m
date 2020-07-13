//
//  NSString+Exp.m
//  MYM
//
//  Created by 米翊米 on 2018/6/5.
//  Copyright © 2018年 米翊米. All rights reserved.
//

#import "NSString+Exp.h"
#import <CommonCrypto/CommonDigest.h>
#import <objc/runtime.h>

@implementation NSString (Exp)

///排除 nil
+ (BOOL)exp_isEmpty:(NSString *)string {
    if ([string isEqualToString:@""]) {
        return YES;
    }
    
    return NO;
}

//判断时候为空
+ (BOOL)exp_isBlankString:(NSString *)oriString {
    if (![oriString isKindOfClass:[NSString class]]) {
        return YES;
    }
    if ([self exp_isEmpty:oriString]) {
        return YES;
    }
    
    if ([oriString isKindOfClass:[NSNull class]]) {
        return YES;
    }
    
    if (!oriString) {
        return YES;
    }
    
    if (oriString.length <= 0) {
        return YES;
    }
    
    if ([oriString isEqualToString:@"<null>"] || [oriString isEqualToString:@"<nil>"] || [oriString isEqualToString:@"null"]) {
        return YES;
    }
    
    NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *trimmedStr = [oriString stringByTrimmingCharactersInSet:set];
    if (!trimmedStr.length) {
        return YES;
    }
    
    return NO;
}

///空字符串替换为""
+ (NSString *)exp_nullSafe:(NSString *)string {
    if ([NSString exp_isBlankString:string]) {
        return @"";
    }
    
    return string;
}

///时间戳转格式化时间字符串 (eg. 20180912)
- (NSString *)exp_dateFormart:(NSString *)formart {
    NSTimeInterval interval = [self doubleValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:formart];
    NSString *dateString = [formatter stringFromDate: date];
    
    return dateString;
}

//格式化时间字符串计算与当前时间的间隔(eg. 刚刚、5分钟前、1小时前，4天前、3个月前，1年前)
- (NSString *)exp_compareFormart:(NSString *)formart {
    //把字符串转为NSdate
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formart];
    NSDate *timeDate = [dateFormatter dateFromString:self];
    NSDate *currentDate = [NSDate date];
    NSTimeInterval timeInterval = [currentDate timeIntervalSinceDate:timeDate];
    long temp = 0;
    NSString *result;
    if (timeInterval/60 < 1)
    {
        result = [NSString stringWithFormat:@"刚刚"];
    }
    else if((temp = timeInterval/60) <60){
        result = [NSString stringWithFormat:@"%ld分钟前",temp];
    }
    else if((temp = temp/60) <24){
        result = [NSString stringWithFormat:@"%ld小时前",temp];
    }
    else if((temp = temp/24) <30){
        result = [NSString stringWithFormat:@"%ld天前",temp];
    }
    else if((temp = temp/30) <12){
        result = [NSString stringWithFormat:@"%ld月前",temp];
    }
    else{
        temp = temp/12;
        result = [NSString stringWithFormat:@"%ld年前",temp];
    }
    return  result;
}

/// 获取连接指定参数值
+ (NSString *)exp_paramValueOfUrl:(NSString *)url withParam:(NSString *)param {
    
    NSError *error;
    NSString *regTags=[[NSString alloc] initWithFormat:@"(^|&|\\?)+%@=+([^&]*)(&|$)",param];
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regTags
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    
    // 执行匹配的过程
    NSArray *matches = [regex matchesInString:url
                                      options:0
                                        range:NSMakeRange(0, [url length])];
    for (NSTextCheckingResult *match in matches) {
        NSString *tagValue = [url substringWithRange:[match rangeAtIndex:2]];  // 分组2所对应的串
        return tagValue;
    }
    return nil;
}

///补全url 拼接完整的连接(http://xxxx/xxx.jpg)
- (NSString *)exp_urlCompelete:(NSString *)domain {
    NSString *url = @"";
    if ([self hasPrefix:@"http://"] || [self hasPrefix:@"https://"]) {
        url = self;
    } else {
        url = [NSString stringWithFormat:@"%@%@", domain, self];
    }
    
    return url;
}

/// 去掉头尾的空白字符
- (NSString *)exp_trimEndWhiteSpace {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

/// 去掉整段文字内的所有空白字符（包括换行符）
- (NSString *)exp_trimAllWhiteSpace {
    return [self stringByReplacingOccurrencesOfString:@"\\s" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, self.length)];
}

/// 将文字中的换行符替换为空格
- (NSString *)exp_trimLineBreakCharacter {
    return [self stringByReplacingOccurrencesOfString:@"[\r\n]" withString:@" " options:NSRegularExpressionSearch range:NSMakeRange(0, self.length)];
}

/// 把该字符串转换为对应的 md5
- (NSString *)exp_mD5 {
    const char *cStr = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]];
}

//判断是否为整形：
- (BOOL)exp_isPureInt {
    NSScanner* scan = [NSScanner scannerWithString:self];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}

//判断是否为浮点形：
- (BOOL)exp_isPureFloat {
    NSScanner* scan = [NSScanner scannerWithString:self];
    float val;
    return [scan scanFloat:&val] && [scan isAtEnd];
}

//判断是否为长浮点形：
- (BOOL)exp_isPureDobule {
    NSScanner* scan = [NSScanner scannerWithString:self];
    double val;
    return [scan scanDouble:&val] && [scan isAtEnd];
}

//判断是否是纯数字
- (BOOL)exp_isPureNumber {
    if(![self exp_isPureFloat] || ![self exp_isPureDobule]) {
        return NO;
    }
    
    return YES;
}

///除去空格后文本长度
- (NSInteger)exp_Length {
    return [self exp_trimAllWhiteSpace].length;
}

///文本反转
- (NSString *)exp_reversed {
    NSMutableString *string = [NSMutableString string];
    for (NSUInteger i=self.length; i>0; i--) {
        [string appendString:[self substringWithRange:NSMakeRange(i-1, 1)]];
    }
    
    return string;
}

@end
