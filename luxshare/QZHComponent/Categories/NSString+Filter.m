//
//  NSString+Filter.m
//  luxshare
//
//  Created by 黄振 on 2021/3/2.
//  Copyright © 2021 KingYellow. All rights reserved.
//

#import "NSString+Filter.h"

@implementation NSString (Filter)
//数字
#define NUM @"0123456789"
//字母
#define ALPHA @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
//数字和字母
#define ALPHANUM @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
 
+ (BOOL)exp_isEqualToReplacementString:(NSString *)string
{
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ALPHANUM] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        return [string isEqualToString:filtered];
}
@end
