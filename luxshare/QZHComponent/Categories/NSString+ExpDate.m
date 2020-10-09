//
//  NSString+Exp.m
//  luxshare
//
//  Created by 黄振 on 2020/10/8.
//  Copyright © 2020 KingYellow. All rights reserved.
//

#import "NSString+ExpDate.h"

@implementation NSString (ExpDate)
- (NSString *)exp_dateStringChangeStyle{
    NSString *year = [[[[self componentsSeparatedByString:@" "] firstObject] componentsSeparatedByString:@"-"] objectAtIndex:0];

    NSString *month = [[[[self componentsSeparatedByString:@" "] firstObject] componentsSeparatedByString:@"-"] objectAtIndex:1];
    if (month.length == 1) {
        month = [@"0" stringByAppendingString:month];
    }
    NSString *day=[[[[self componentsSeparatedByString:@" "] firstObject] componentsSeparatedByString:@"-"] objectAtIndex:2];
    if (day.length == 1) {
        day = [@"0" stringByAppendingString:day];
    }
    NSString *currentStr1=[NSString stringWithFormat:@"%@-%@-%@",year,month,day];
    
    return currentStr1;
}
@end
