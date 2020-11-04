//
//  DateListTools.m
//  日历
//
//  Created by 1 on 2017/7/23.
//  Copyright © 2017年 1. All rights reserved.
//

#import "DateListTools.h"

@implementation DateListTools

//获得某年某月第一天周几
+(NSInteger)GetTheWeekOfDayByYera:(NSInteger)year
                 andByMonth:(NSInteger)month{
    int numWeek = ((year-1)+ (year-1)/4- (year-1)/100+(year-1)/400+1)%7;//numWeek为years年的第一天是星期几
    //NSLog(@"%d",numWeek);
    int ar[12] = {0,31,59,90,120,151,181,212,243,273,304,334};
    int numdays = (((year/4==0&&year/100!=0)||(year/400==0))&&(month>2))?(ar[month-1]+1):(ar[month-1]);//numdays为month月years年的第一天是这一年的第几天
    //NSLog(@"%d",numdays);
    int dayweek = (numdays%7 + numWeek)%7;//month月第一天是星期几，周日则为0
    //NSLog(@"%d",dayweek);
    return dayweek;
}
// 获取某年某月总共多少天
+ (NSInteger)getDaysInMonth:(NSInteger)year month:(NSInteger)imonth {
    // imonth == 0的情况是应对在CourseViewController里month-1的情况
    if((imonth == 0)||(imonth == 1)||(imonth == 3)||(imonth == 5)||(imonth == 7)||(imonth == 8)||(imonth == 10)||(imonth == 12))
        return 31;
    if((imonth == 4)||(imonth == 6)||(imonth == 9)||(imonth == 11))
        return 30;
    if((year%4 == 1)||(year%4 == 2)||(year%4 == 3))
    {
        return 28;
    }
    if(year%400 == 0)
        return 29;
    if(year%100 == 0)
        return 28;
    return 29;
}
@end
