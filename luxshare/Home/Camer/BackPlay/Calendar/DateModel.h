//
//  DateModel.h
//  日历
//
//  Created by yurong on 2017/8/1.
//  Copyright © 2017年 1. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateModel : NSObject
@property(nonatomic,assign)NSInteger day;
@property(nonatomic,assign)NSInteger year;
@property(nonatomic,assign)NSInteger month;

@property(nonatomic,assign)NSInteger lastMonth;
@property(nonatomic,assign)NSInteger nextMonth;
+(instancetype)shareDateModel;
@end
