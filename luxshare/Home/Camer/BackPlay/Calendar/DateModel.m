//
//  DateModel.m
//  日历
//
//  Created by yurong on 2017/8/1.
//  Copyright © 2017年 1. All rights reserved.
//

#import "DateModel.h"
static DateModel *datemodel;
@implementation DateModel

+(instancetype)shareDateModel{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!datemodel) {
            datemodel = [[DateModel alloc]init];
        }
    });
    return datemodel;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        // 获取代表公历的NSCalendar对象
        NSCalendar *gregorian = [[NSCalendar alloc]
                                 initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        // 获取当前日期
        NSDate* dt = [NSDate date];
        // 定义一个时间字段的旗标，指定将会获取指定年、月、日、时、分、秒的信息
        unsigned unitFlags = NSCalendarUnitYear |
        NSCalendarUnitMonth |  NSCalendarUnitDay |
        NSCalendarUnitHour |  NSCalendarUnitMinute |
        NSCalendarUnitSecond | NSCalendarUnitWeekday;
        // 获取不同时间字段的信息
        NSDateComponents* comp = [gregorian components: unitFlags
                                              fromDate:dt];
        _day = comp.day;
        _year = comp.year;
        _month = comp.month;
    }
    return self;
}

-(NSInteger)lastMonth{
    NSInteger  lastmonth;
    if (datemodel.month == 1) {
        lastmonth = 12;
    }else{
        lastmonth = datemodel.month-1;
    }
    
    return lastmonth;
}

-(NSInteger)nextMonth{
    NSInteger  nextmonth;
    if (datemodel.month == 12) {
        nextmonth = 1;
    }else{
        nextmonth = datemodel.month+1;
    }
    return nextmonth;
}

@end
