//
//  ZYYY_DateListView.m
//  日历
//
//  Created by 1 on 2017/7/23.
//  Copyright © 2017年 1. All rights reserved.
//

#import "zyyy_DateView.h"
#import "DateListTools.h"
#import "UIColor+Hex.h"
#import "UIView+Frame.h"
#define IPHONEHIGHT(b) [UIScreen mainScreen].bounds.size.height*((b)/1334.0)
#define IPHONEWIDTH(a) [UIScreen mainScreen].bounds.size.width*((a)/750.0)
#define horizontalInset IPHONEWIDTH(24) //水平方向间距
#define verticalInset IPHONEHIGHT(10) //垂直方向间距
#define XborderInset IPHONEWIDTH(12) //水平方向边界距离
#define YborderInset IPHONEHIGHT(10) //垂直方向边界距离
#define itemSize IPHONEWIDTH(55) //itemSize

#define visibleLabelFont IPHONEWIDTH(24)
#define visibleLabelTextColor [UIColor blackColor]

#define noVisibleLabelTextColor [UIColor grayColor]

#define itemSelectedColor  [UIColor colorWithHexString:@"c2d2d5"]
#define itemNotSelectedColor [UIColor colorWithHexString:@"efefef"]
@interface zyyy_DateView ()<TuyaSmartCameraDelegate>
{
    
    CGFloat width ;
    CGFloat height;
    NSInteger numberOfItem;//item数量
    NSInteger currentYear;
    NSInteger currentMonth;
    NSInteger currentDay;
    NSInteger selectedDay;
    NSArray *daysArr;
    
}
@end
@implementation zyyy_DateView
-(void)getDateInformation{
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
    
    currentYear = comp.year;
    currentMonth = comp.month;
    currentDay = comp.day;
   
    //默认当月当年
    _selectedMonth = currentMonth;
    _selectedYear = currentYear;
    NSLog(@"%ld",(long)comp.month);
    
}
-(void)btnSelector:(UIButton *)sender{
    NSInteger numberDay = [DateListTools getDaysInMonth:_selectedYear month:_selectedMonth];//当月有多少天
    NSInteger LastNumberDay = [DateListTools GetTheWeekOfDayByYera:_selectedYear andByMonth:_selectedMonth] + 1;//上月在这显示了多少天
    //可以选中
    if (_isSelected) {
        if (sender.tag>LastNumberDay&&sender.tag<numberDay+LastNumberDay+1) {
            //取消上一个选中
            UIButton *btn = [self viewWithTag:selectedDay+LastNumberDay];
            btn.backgroundColor = itemNotSelectedColor;
            //设置下一个选中
            selectedDay = sender.tag-LastNumberDay;
            sender.backgroundColor = QZHKIT_COLOR_SKIN;
        }
        //代理返回
        if ([self.delegate respondsToSelector:@selector(selectedDic:)]) {
            [self.delegate selectedDic:@{@"year":[NSString stringWithFormat:@"%ld",(long)_selectedYear],@"month":[NSString stringWithFormat:@"%ld",_selectedMonth],@"day":sender.titleLabel.text}];
        }
    }
    
    
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        width = frame.size.width;
        height = frame.size.height;
        
        numberOfItem = 1;
        
        [self getDateInformation];
        for (int indexY = 0; indexY<6; indexY++) {
            for (int indexX = 0; indexX<7; indexX++) {
                UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(XborderInset+indexX*(horizontalInset+itemSize), YborderInset+indexY*(verticalInset+itemSize), itemSize, itemSize)];
                NSLog(@"%f ",indexX*(horizontalInset+itemSize));
                
                [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                btn.titleLabel.font = [UIFont systemFontOfSize:visibleLabelFont];
                
                btn.tag = numberOfItem;
                numberOfItem++;
                [btn addTarget:self action:@selector(btnSelector:) forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:btn];
                //画圆角
                UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:btn.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:btn.bounds.size];
                
                CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
                
                //设置大小
                maskLayer.frame = btn.bounds;
                //设置图形样子
                maskLayer.path = maskPath.CGPath;
                btn.layer.mask = maskLayer;
                
            }
        }
        
        [self setUIchange];
    }
    return self;
}
-(void)setUIchange{
    //默认选中当天
    selectedDay = currentDay;
    
    NSInteger numberDay = [DateListTools getDaysInMonth:_selectedYear month:_selectedMonth];//当月有多少天
    NSInteger lastNumberDay;//上月有多少天
    if (_selectedMonth==1||_selectedMonth==12) {
        lastNumberDay = 31;
    }else{
        lastNumberDay = [DateListTools getDaysInMonth:_selectedYear month:_selectedMonth-1];//当月有多少天
    }
    
    NSInteger weekDay = [DateListTools GetTheWeekOfDayByYera:_selectedYear andByMonth:_selectedMonth] + 1;
    NSInteger numberOfLastMonth = weekDay;
    NSInteger numberOfNextMonth = 42 - weekDay - numberDay;
    
    for (int index = 0; index<42; index++) {
        UIButton *btn = [self viewWithTag:index+1];
        btn.userInteractionEnabled = YES;
        if (btn.tag<numberOfLastMonth+1) {
            //上月
            btn.backgroundColor = itemNotSelectedColor;
            [btn setTitleColor:noVisibleLabelTextColor forState:UIControlStateNormal];
            [btn setTitle:[NSString stringWithFormat:@"%ld",lastNumberDay-numberOfLastMonth+index+1] forState:UIControlStateNormal];
        }else if (numberOfLastMonth<btn.tag&&btn.tag<42-numberOfNextMonth+1){
            
            if ([daysArr containsObject:@(index-numberOfLastMonth+1)]) {
                [btn setTitleColor:visibleLabelTextColor forState:UIControlStateNormal];
                btn.titleLabel.font = QZHTEXT_FONTBold(IPHONEWIDTH(24));

            }else{
                [btn setTitleColor:[UIColor colorWithHexString:@"7c7c7c"] forState:UIControlStateNormal];
                btn.titleLabel.font = QZHTEXT_FONT(IPHONEWIDTH(24));
                btn.userInteractionEnabled = NO;
            }
//            //本月
//            if (btn.tag>numberOfLastMonth&&btn.tag<currentDay+numberOfLastMonth&&_selectedYear == currentYear &&_selectedMonth == currentMonth) {
//                //这月过去的日子
//
//                [btn setTitleColor:visibleLabelTextColor forState:UIControlStateNormal];
//
//            }else{
//                //这月没过去的日子
//                [btn setTitleColor:[UIColor colorWithHexString:@"7c7c7c"] forState:UIControlStateNormal];
//                btn.userInteractionEnabled = NO;
//            }
//
            [btn setTitle:[NSString stringWithFormat:@"%ld",index-numberOfLastMonth+1] forState:UIControlStateNormal];
            //当月显示
            if (_selectedYear == currentYear &&_selectedMonth == currentMonth&&btn.tag-weekDay == currentDay) {
                btn.backgroundColor = itemSelectedColor;

            }else{
                btn.backgroundColor = itemNotSelectedColor;
            }

        }else {
            //下月
            btn.backgroundColor = itemNotSelectedColor;
            [btn setTitleColor:noVisibleLabelTextColor forState:UIControlStateNormal];
            
            
            [btn setTitle:[NSString stringWithFormat:@"%ld",index+1-numberDay-numberOfLastMonth] forState:UIControlStateNormal];
        }
    }
    }

-(void)setSelectedMonth:(NSInteger)selectedMonth{

    if (selectedMonth ==13) {
        _selectedMonth = 1;
        _selectedYear +=1;
    }else if(selectedMonth == 0){
        _selectedMonth = 12;
        _selectedYear -=1;
    }else{
        _selectedMonth = selectedMonth;
    }
    
    [self setUIchange];
}

-(void)setSelectedYear:(NSInteger)selectedYear{
    _selectedYear = selectedYear;
    [self setUIchange];
}

-(void)setFreeMonth:(NSInteger)freeMonth{
    self.camera.delegate = self;
    [self.camera queryRecordDaysWithYear:_selectedYear month:_selectedMonth];
    
}

//查询某月与视频的日子结果回调
- (void)camera:(id<TuyaSmartCameraType>)camera didReceiveRecordDayQueryData:(NSArray<NSNumber *> *)days{
    daysArr = days;
    if (days.count > 0) {

    }

    [self setUIchange];
}
- (void)camera:(id<TuyaSmartCameraType>)camera ty_didReceiveVideoFrame:(CMSampleBufferRef)sampleBuffer frameInfo:(TuyaSmartVideoFrameInfo)frameInfo {
   
}
-(void)cameraDidBeginPlayback:(id<TuyaSmartCameraType>)camera{
    
}
-(void)cameraDidStopPlayback:(id<TuyaSmartCameraType>)camera{
    
}
@end
