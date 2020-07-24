//
//  ZFTimeLine.m
//  luxshare
//
//  Created by 黄振 on 2020/7/16.
//  Copyright © 2020 KingYellow. All rights reserved.
//

#import "ZFTimeLine.h"

@interface ZFTimeLine(){
    float intervalValue;                        //小刻度宽度 默认10
    NSDateFormatter *formatterScale;            //时间格式化 用于获取时刻表文字
    NSDateFormatter *formatterProject;          //时间格式化 用于项目同于时间格式转化
    ScaleType scaleType;                        //时间轴模式
    NSTimeInterval currentInterval;             //中间时刻对应的时间戳
    
    CGPoint moveStart;                          //移动的开始点
    float scaleValue;                           //缩放时记录开始的间距
    
    BOOL onTouch;                               //是否在触摸状态
}

@end

@implementation ZFTimeLine

- (instancetype)init{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        self.alpha = 0.8;
        intervalValue = 10;
        formatterScale = [[NSDateFormatter alloc]init];
        [formatterScale setDateFormat:@"HH:mm"];
        
        formatterProject = [[NSDateFormatter alloc]init];
        [formatterProject setDateFormat:@"yyyyMMddHHmmss"];
        
        scaleType = ScaleTypeBig;
        [self timeNow];
        self.multipleTouchEnabled = YES;
        onTouch = NO;
    }
    return self;
}
-(void)layoutSubviews{
    [self setNeedsDisplay];
}
#pragma mark --- 触摸事件
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (!self.userInteractionEnabled) {
        return;
    }
    onTouch = YES;
    if (touches.count == 1) {
        UITouch *touch = [touches anyObject];
        moveStart = [touch locationInView:self];
    }else if (touches.count == 2){
        NSArray *arr = [touches allObjects];
        UITouch *touch1 = arr[0];
        UITouch *touch2 = arr[1];
        scaleValue = fabs([touch2 locationInView:self].x - [touch1 locationInView:self].x);
    }
}
-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (!self.userInteractionEnabled) {
        return;
    }
    if (touches.count == 1) {
        UITouch *touch = [touches anyObject];
        CGPoint point = [touch locationInView:self];
        float x = point.x - moveStart.x;
        currentInterval = currentInterval - [self secondsOfIntervalValue] * x;
        moveStart = point;
        [self setNeedsDisplay];
    }else if (touches.count == 2){
        NSArray *arr = [touches allObjects];
        UITouch *touch1 = arr[0];
        UITouch *touch2 = arr[1];
        float value = fabs([touch2 locationInView:self].x - [touch1 locationInView:self].x) ;
        
        if (scaleType == ScaleTypeBig) {
            if (scaleValue - value < 0) {//变大
                intervalValue = intervalValue + (value - scaleValue)/100;
                if (intervalValue >= 15) {
                    scaleType = ScaleTypeSmall;
                    intervalValue = 10;
                }
            }else{//缩小
                intervalValue = intervalValue + (value - scaleValue)/100;
                if (intervalValue < 10) {
                    intervalValue = 10;
                }
            }
        }else{
            if (scaleValue - value < 0) {//变大
                intervalValue = intervalValue + (value - scaleValue)/100;
                if (intervalValue >= 15) {
                    intervalValue = 15;
                }
            }else{//缩小
                intervalValue = intervalValue + (value - scaleValue)/100;
                if (intervalValue < 10) {
                    scaleType = ScaleTypeBig;
                    intervalValue = 10;
                }
            }
        }
        [self setNeedsDisplay];
    }
}
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (!self.userInteractionEnabled) {
        return;
    }
    onTouch = NO;

    if (self.delegate && [self.delegate respondsToSelector:@selector(timeLine:moveToDate:)]) {
        [self.delegate timeLine:self moveToDate:[self currentTimeStr]];
    }
//    [DFTime delaySec:0.5 perform:^{
//
//    }];
}
//锁定 不可拖动
- (void)lockMove{
    self.userInteractionEnabled = NO;
}
//解锁 可拖动
- (void)unLockMove{
    self.userInteractionEnabled = YES;
}
//刷新,但不改变时间
-(void)refresh{
    [self setNeedsDisplay];
}
#pragma mark --- 刷新到当到前时间
- (void)refreshNow{
    if (onTouch || !self.userInteractionEnabled) {
        return;
    }
    [self timeNow];
    [self setNeedsDisplay];
}
#pragma mark --- 移动到某时间
// date数据格式举例 20170815121020
- (void)moveToDate:(NSString *)date{
    if (onTouch || !self.userInteractionEnabled) {
        return;
    }
    currentInterval = [self intervalWithTime:date];
    [self setNeedsDisplay];
//    if (self.delegate && [self.delegate respondsToSelector:@selector(timeLine:moveToDate:)]) {
//        [self.delegate timeLine:self moveToDate:[self currentTimeStr]];
//    }
}
#pragma mark --- 获取时间轴指向的时间
-(NSString *)currentTimeStr{
    return [self projectTimeWithInterval:currentInterval];
}
//设置中心刻度为当前时间
- (void)timeNow{
    currentInterval = [[NSDate date] timeIntervalSince1970];
}
//宽度1所代表的秒数
- (float)secondsOfIntervalValue{
    if (scaleType == ScaleTypeBig) {
        return 6.0*60.0/intervalValue;
    }else if (scaleType == ScaleTypeSmall){
        return 60.0/intervalValue;
    }
    return 6.0*60.0/intervalValue;
}
//绘图
-(void)drawRect:(CGRect)rect{
    //计算x=0时对应的时间戳
    float centerX = rect.size.width/2.0;
    NSTimeInterval leftInterval = currentInterval - centerX * [self secondsOfIntervalValue];
    NSTimeInterval rightInterval = currentInterval + centerX * [self secondsOfIntervalValue];

    //左边第一个刻度对应的x值和时间戳
    float x;
    NSTimeInterval interval;
    if (scaleType == ScaleTypeBig) {
        float a = leftInterval/(60.0*6.0);
        interval = (((int)a) + 1) * (60.0 * 6.0);
        x = (interval - leftInterval) / [self secondsOfIntervalValue];
    }else {
        float a = leftInterval/(60.0);
        interval = (((int)a) + 1) * (60.0);
        x = (interval - leftInterval) / [self secondsOfIntervalValue];
    }
  CGContextRef contex = UIGraphicsGetCurrentContext();

//    //视频文件信息
//    NSArray * array = [NSArray array];
//    if (array == nil) {
//        array = @[];
//    }
//    for (VideoInfo *info in array) {
//        NSTimeInterval start = [self intervalWithTime:[NSString stringWithFormat:@"%lld",info.date]];
//        NSTimeInterval end = start + info.time;
//        if ((start > leftInterval && start < rightInterval) || (end > leftInterval && end < rightInterval ) || (start < leftInterval && end > rightInterval)) {
//            //计算起始位置对应的x值
//            float startX = (start - leftInterval)/[self secondsOfIntervalValue];
//            //计算时间长度对应的宽度
//            float length = (info.time)/[self secondsOfIntervalValue] + 0.5;
////            if ([info.path containsString:@"SOS"]) {
////                [self drawRedRect:startX Context:contex length:length];
////            }else{
//                [self drawGreenRect:startX Context:contex length:length];
////            }
//        }
//    }

    while (x >= 0 && x <= rect.size.width) {
        int b;
        if (scaleType == ScaleTypeBig) {
            b = 60 * 6;
        }else{
            b = 60;
        }
        int rem = ((int)interval) % (b * 5);
        if (rem != 0) {//小刻度
            [self drawSmallScale:x context:contex height:rect.size.height];
        }else{//大刻度
            [self drawBigScale:x context:contex height:rect.size.height];
            [self drawText:x interval:interval context:contex height:rect.size.height];
        }
        x = x + intervalValue;
        interval = interval + b;
    }
    if (self.dateArr.count > 0) {
        [self drawGreenRectContext:contex];

    }

    [self drawCenterLine:rect.size.width/2 context:contex height:rect.size.height];
}

#pragma mark --- 画小刻度
-(void)drawSmallScale:(float)x context:(CGContextRef)ctx height:(float)height{
    // 创建一个新的空图形路径。
    CGContextBeginPath(ctx);
    
    CGContextMoveToPoint(ctx, x-0.5, height-5);
    CGContextAddLineToPoint(ctx, x-0.5, height);
    // 设置图形的线宽
    CGContextSetLineWidth(ctx, 1.0);
    // 设置图形描边颜色
    CGContextSetStrokeColorWithColor(ctx, [UIColor whiteColor].CGColor);
    // 根据当前路径，宽度及颜色绘制线
    CGContextStrokePath(ctx);
}
#pragma mark --- 画大刻度
-(void)drawBigScale:(float)x context:(CGContextRef)ctx height:(float)height{
    // 创建一个新的空图形路径。
    CGContextBeginPath(ctx);
    
    CGContextMoveToPoint(ctx, x-0.5, height-10);
    CGContextAddLineToPoint(ctx, x-0.5, height);
    // 设置图形的线宽
    CGContextSetLineWidth(ctx, 1.0);
    // 设置图形描边颜色
    CGContextSetStrokeColorWithColor(ctx, [UIColor whiteColor].CGColor);
    // 根据当前路径，宽度及颜色绘制线
    CGContextStrokePath(ctx);
}
#pragma mark --- 画中间线
-(void)drawCenterLine:(float)x context:(CGContextRef)ctx height:(float)height{
    // 创建一个新的空图形路径。
    CGContextBeginPath(ctx);
    
    CGContextMoveToPoint(ctx, x-0.5, 0);
    CGContextAddLineToPoint(ctx, x-0.5, height);
    // 设置图形的线宽
    CGContextSetLineWidth(ctx, 1.0);
    // 设置图形描边颜色
    CGContextSetStrokeColorWithColor(ctx, [UIColor whiteColor].CGColor);
    // 根据当前路径，宽度及颜色绘制线
    CGContextStrokePath(ctx);
}
#pragma mark --> 在刻度上标记文本
-(void)drawText:(float)x interval:(NSTimeInterval)interval context:(CGContextRef)ctx height:(float)height{
    NSString *text = [self timeWithInterval:interval];
    CGContextSetRGBFillColor(ctx, 1, 0, 0, 1);
    UIFont *font = [UIFont systemFontOfSize:10];
    NSMutableParagraphStyle *paragraph=[[NSMutableParagraphStyle alloc]init];
    paragraph.alignment=NSTextAlignmentCenter;//居中
    [text drawInRect:CGRectMake(x-15, height-21, 30, 10) withAttributes:@{NSFontAttributeName : font,NSForegroundColorAttributeName:[UIColor whiteColor],NSParagraphStyleAttributeName:paragraph}];
}
#pragma mark --- 时间戳转 显示的时刻文字
-(NSString *)timeWithInterval:(NSTimeInterval)interval{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    return [formatterScale stringFromDate:date];
}
#pragma mark --- 文字转时间戳
-(NSTimeInterval)intervalWithTime:(NSString *)time{
    NSDate *date = [formatterProject dateFromString:time];
    return [date timeIntervalSince1970];
}
#pragma mark --- 时间戳转 当前的时间 格式举例: 20170814122034
-(NSString *)projectTimeWithInterval:(NSTimeInterval)interval{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    return [formatterProject stringFromDate:date];
}
#pragma mark --- 绿色色块
-(void)drawGreenRect:(float)x Context:(CGContextRef)ctx length:(float)length{
    // 创建一个新的空图形路径。
    CGContextBeginPath(ctx);
    
    CGContextMoveToPoint(ctx, x, 0.0);
    CGContextAddLineToPoint(ctx, x+length, 0.0);
    CGContextAddLineToPoint(ctx, x+length, self.frame.size.height);
    CGContextAddLineToPoint(ctx, x, self.frame.size.height);
    // 关闭并终止当前路径的子路径，并在当前点和子路径的起点之间追加一条线
    CGContextClosePath(ctx);
    // 设置当前视图填充色(浅灰色)
    CGContextSetFillColorWithColor(ctx, QZHKIT_COLOR_SKIN_AlPHA.CGColor);
    // 绘制当前路径区域
    CGContextFillPath(ctx);
    
}
#pragma mark --- 绿色色块
-(void)drawRedRect:(float)x Context:(CGContextRef)ctx length:(float)length{
    // 创建一个新的空图形路径。
    CGContextBeginPath(ctx);
    
    CGContextMoveToPoint(ctx, x, 0.0);
    CGContextAddLineToPoint(ctx, x+length, 0.0);
    CGContextAddLineToPoint(ctx, x+length, self.frame.size.height);
    CGContextAddLineToPoint(ctx, x, self.frame.size.height);
    // 关闭并终止当前路径的子路径，并在当前点和子路径的起点之间追加一条线
    CGContextClosePath(ctx);
    // 设置当前视图填充色(浅灰色)
    CGContextSetFillColorWithColor(ctx, [UIColor colorWithRed:233.0/255.0
                                                        green:64.0/255.0
                                                         blue:73.0/255.0
                                                        alpha:1.0].CGColor);
    // 绘制当前路径区域
    CGContextFillPath(ctx);
    
}
-(void)setDateArr:(NSArray *)dateArr{
    _dateArr = dateArr;
    if (dateArr.count > 0) {
        NSDictionary *d = self.dateArr.firstObject;
        currentInterval = [d[kTuyaSmartTimeSliceStartTime] integerValue];
        [self setNeedsDisplay];
    }

}
- (void)drawGreenRectContext:(CGContextRef)ctx {
//        NSDictionary *d = self.dateArr.firstObject;
//        currentInterval = [d[kTuyaSmartTimeSliceStartTime] integerValue];
//        //计算x=0时对应的时间戳
//        float centerX = QZHScreenWidth/2.0;
//        NSTimeInterval leftInterval = currentInterval - centerX * [self secondsOfIntervalValue];
//        NSTimeInterval rightInterval = currentInterval + centerX * [self secondsOfIntervalValue];
    //    NSInteger startTime = [timeSlice[kTuyaSmartTimeSliceStartTime] integerValue];
    //    NSInteger stopTime = [timeSlice[kTuyaSmartTimeSliceStopTime] integerValue];
    //左边第一个刻度对应的x值和时间戳
    
    //计算x=0时对应的时间戳
    float centerX = QZHScreenWidth/2.0;
    NSTimeInterval leftInterval = currentInterval - centerX * [self secondsOfIntervalValue];
    NSTimeInterval rightInterval = currentInterval + centerX * [self secondsOfIntervalValue];
    
    float x;
    NSTimeInterval interval;
    if (scaleType == ScaleTypeBig) {
        float a = leftInterval/(60.0*6.0);
        interval = (((int)a) + 1) * (60.0 * 6.0);
        x = (interval - leftInterval) / [self secondsOfIntervalValue];
    }else {
        float a = leftInterval/(60.0);
        interval = (((int)a) + 1) * (60.0);
        x = (interval - leftInterval) / [self secondsOfIntervalValue];
    }
      //视频文件信息
      NSArray * array = self.dateArr;
      if (array == nil) {
          array = @[];
      }
      for (NSDictionary *info in array) {
          NSTimeInterval start = [info[kTuyaSmartTimeSliceStartTime] integerValue];
          NSTimeInterval end = [info[kTuyaSmartTimeSliceStopTime] integerValue];
          if (start > interval) {
              //计算起始位置对应的x值
              float startX = x + (start - interval)/[self secondsOfIntervalValue];
              //计算时间长度对应的宽度
              float length = (end - start)/[self secondsOfIntervalValue] + 0.5;

                [self drawGreenRect:startX Context:ctx length:length];

          }
      }

}

@end
