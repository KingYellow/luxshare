//
//  DateListTools.h
//  日历
//
//  Created by 1 on 2017/7/23.
//  Copyright © 2017年 1. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateListTools : NSObject


+ (NSInteger)getNumberOfDaysInMonthWithDate:(NSDate *)date;
+(NSInteger)GetTheWeekOfDayByYera:(NSInteger)year
                 andByMonth:(NSInteger)month;
+ (NSInteger)getDaysInMonth:(NSInteger)year month:(NSInteger)imonth ;
@end
