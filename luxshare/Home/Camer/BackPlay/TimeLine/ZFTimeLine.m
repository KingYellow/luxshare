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
        self.backgroundColor = UIColorFromHex(0x000000);
        intervalValue = 10;
        formatterScale = [[NSDateFormatter alloc]init];
        [formatterScale setDateFormat:@"HH:mm"];
        
        formatterProject = [[NSDateFormatter alloc]init];
        [formatterProject setDateFormat:@"yyyyMMddHHmmss"];
        
        scaleType = ScaleTypeBig;
        [self timeNow];
        self.multipleTouchEnabled = YES;
        onTouch = NO;
        UIPinchGestureRecognizer *pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchView:)];
        [self addGestureRecognizer:pinchGestureRecognizer];
        // 移动手势

        UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panView:)];

        [self addGestureRecognizer:panGestureRecognizer];
    }
    return self;
}
-(void)layoutSubviews{
    [self setNeedsDisplay];
}
#pragma mark --- 触摸事件

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
    }else if (scaleType == ScaleTypeNormal){
        return 60.0/intervalValue;
    }else{
        return 6.0/intervalValue;
    }
}
-(void)drawRect:(CGRect)rect{
    NSTimeInterval centerLeftInterval;
    NSTimeInterval centerRightInterval;
    NSTimeInterval zeroInterval = [self getZeroInterval:currentInterval];
    NSTimeInterval twofourInterva = [self getTwoFourInterval:currentInterval];
    //左边第一个刻度对应的x值和时间戳
    float xLeft;
    float xRight;
    int b;
    if (scaleType == ScaleTypeBig) {
        b = 60 * 6 ;
        int a = currentInterval/(60 * 6);
        centerLeftInterval = (a) * (60 * 6);
        centerRightInterval = (a + 1) * (60 * 6);
        xLeft = (centerLeftInterval - currentInterval) / [self secondsOfIntervalValue] + rect.size.width/2;
        xRight = (centerRightInterval - currentInterval) / [self secondsOfIntervalValue] + rect.size.width/2;

    }else if(scaleType == ScaleTypeNormal){
        b = 60 ;
        int a = currentInterval/(60);
        centerLeftInterval = (a) * (60);
        centerRightInterval = (a + 1) * (60);
        xLeft = (centerLeftInterval - currentInterval) / [self secondsOfIntervalValue] + rect.size.width/2;
        xRight = (centerRightInterval - currentInterval) / [self secondsOfIntervalValue] + rect.size.width/2;
    }else{
        b = 6;
        int a = currentInterval/(6);
        centerLeftInterval = (a) * (6);
        centerRightInterval = (a + 1) * (6);
        xLeft = (centerLeftInterval - currentInterval) / [self secondsOfIntervalValue] + rect.size.width/2;
        xRight = (centerRightInterval - currentInterval) / [self secondsOfIntervalValue] + rect.size.width/2;
    }
  CGContextRef contex = UIGraphicsGetCurrentContext();
    while (xRight >= rect.size.width/2 && xRight <= rect.size.width + intervalValue) {

        if (centerLeftInterval >= zeroInterval) {
            int remleft = ((int)centerLeftInterval) % (b * 10);
            if (remleft != 0) {//小刻度
                    [self drawSmallScale:xLeft context:contex height:rect.size.height];
            }else{//大刻度

                [self drawBigScale:xLeft context:contex height:rect.size.height];
                [self drawText:xLeft interval:centerLeftInterval context:contex height:rect.size.height];
            }
        }
        if (centerRightInterval <= (twofourInterva + 1)) {
            int remright = ((int)centerRightInterval) % (b * 10);

            if (remright != 0) {//小刻度
                [self drawSmallScale:xRight context:contex height:rect.size.height];
            }else{//大刻度
                [self drawBigScale:xRight context:contex height:rect.size.height];
                [self drawText:xRight interval:centerRightInterval context:contex height:rect.size.height];
            }
        }
        xLeft = xLeft - intervalValue;
        xRight = xRight + intervalValue;

        centerLeftInterval = centerLeftInterval - b;
        centerRightInterval = centerRightInterval + b;
    }
    
    if (self.dateArr.count > 0) {
        [self drawGreenRectContext:contex rect:rect];
    }

    [self drawCenterLine:rect.size.width/2 context:contex height:rect.size.height];
}
#pragma mark --- 画小刻度
-(void)drawSmallScale:(float)x context:(CGContextRef)ctx height:(float)height{
    // 创建一个新的空图形路径。
    CGContextBeginPath(ctx);
    
    CGContextMoveToPoint(ctx, x-0.5, height/2-2.5);
    CGContextAddLineToPoint(ctx, x-0.5, height/2 + 2.5);
    // 设置图形的线宽
    CGContextSetLineWidth(ctx, 1.0);
    // 设置图形描边颜色
    CGContextSetStrokeColorWithColor(ctx, QZH_KIT_Color_WHITE_70.CGColor);
    // 根据当前路径，宽度及颜色绘制线
    CGContextStrokePath(ctx);
}
#pragma mark --- 画大刻度
-(void)drawBigScale:(float)x context:(CGContextRef)ctx height:(float)height{
    // 创建一个新的空图形路径。
    CGContextBeginPath(ctx);
    
    CGContextMoveToPoint(ctx, x-0.5, height/2-5);
    CGContextAddLineToPoint(ctx, x-0.5, height/2 + 5);
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
    CGContextSetLineWidth(ctx, 2.0);
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
- (void)drawGreenRectContext:(CGContextRef)ctx rect:(CGRect)rect {
    
    //计算x=0时对应的时间戳
    float centerX = rect.size.width/2.0;
    NSTimeInterval leftInterval = currentInterval - centerX * [self secondsOfIntervalValue];
    NSTimeInterval rightInterval = currentInterval + centerX * [self secondsOfIntervalValue];

    float x;
    NSTimeInterval interval;
    if (scaleType == ScaleTypeBig) {
        float a = leftInterval/(60.0*6.0);
        interval = (((int)a) + 1) * (60.0 * 6.0);
        x = (interval - leftInterval) / [self secondsOfIntervalValue];
    }else if (scaleType == ScaleTypeNormal) {
        float a = leftInterval/(60.0);
        interval = (((int)a) + 1) * (60.0);
        x = (interval - leftInterval) / [self secondsOfIntervalValue];
    }else {
        float a = leftInterval/(6.0);
        interval = (((int)a) + 1) * (6.0);
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
          if (end > leftInterval && start < rightInterval) {
              //计算起始位置对应的x值
              float startX = x + (start - interval)/[self secondsOfIntervalValue];
              //计算时间长度对应的宽度
              float length = (end - start)/[self secondsOfIntervalValue] + 0.5;

                [self drawGreenRect:startX Context:ctx length:length];
          }
      }
}
// 处理缩放手势

- (void) pinchView:(UIPinchGestureRecognizer *)pinchGestureRecognizer{

    if (pinchGestureRecognizer.state == UIGestureRecognizerStateBegan){
        onTouch = YES;
    }
    
    if (pinchGestureRecognizer.state == UIGestureRecognizerStateChanged){
        if (scaleType == ScaleTypeBig) {
            if (pinchGestureRecognizer.scale > 1) {
                intervalValue = intervalValue *pinchGestureRecognizer.scale;
                if (intervalValue > 15) {
                    intervalValue = 10;
                    scaleType = ScaleTypeNormal;
                }
            }else{
                if (intervalValue > 10) {
                    intervalValue = intervalValue *pinchGestureRecognizer.scale;

                }else{
                    intervalValue = 10;
                }
            }
        }else if (scaleType == ScaleTypeNormal) {
            if (pinchGestureRecognizer.scale > 1) {//变大
                intervalValue = intervalValue *pinchGestureRecognizer.scale;
                if (intervalValue > 15) {
                    intervalValue = 10;
                    scaleType = ScaleTypeSmall;
                }
            }else{//缩小
                intervalValue = intervalValue *pinchGestureRecognizer.scale;
                if (intervalValue < 5 ) {
                    intervalValue = 10;
                    scaleType = ScaleTypeBig;
                }
            }
            
        }else{
            if (pinchGestureRecognizer.scale < 1) {
                intervalValue = intervalValue *pinchGestureRecognizer.scale;
                if (intervalValue < 5) {
                    intervalValue = 10;
                    scaleType = ScaleTypeNormal;
                }
            }else{
                if (intervalValue < 10) {
                    intervalValue = intervalValue *pinchGestureRecognizer.scale;

                }else{
                    intervalValue = 10;
                }
            }
        }
        pinchGestureRecognizer.scale = 1;

    }
    if (pinchGestureRecognizer.state == UIGestureRecognizerStateEnded || pinchGestureRecognizer.state == UIGestureRecognizerStateCancelled){
        pinchGestureRecognizer.scale = 1;

        if (!self.userInteractionEnabled) {
            return;
        }
        onTouch = NO;

        if (self.delegate && [self.delegate respondsToSelector:@selector(timeLine:moveToDate:)]) {
            [self.delegate timeLine:self moveToDate:[self currentTimeStr]];
        }
    };
    [self setNeedsDisplay];


}
// 处理拖拉手势
//
- (void) panView:(UIPanGestureRecognizer *)panGestureRecognizer{

    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan){
        moveStart = [panGestureRecognizer locationInView:panGestureRecognizer.view];
        onTouch = YES;

    }
    if (panGestureRecognizer.state == UIGestureRecognizerStateChanged){
        CGPoint point = [panGestureRecognizer locationInView:panGestureRecognizer.view];
        float x = point.x - moveStart.x;
        if ((currentInterval - [self secondsOfIntervalValue] * x) > [self getTwoFourInterval:currentInterval]) {
            currentInterval = [self getTwoFourInterval:currentInterval];
        }else if((currentInterval - [self secondsOfIntervalValue] * x) < [self getZeroInterval:currentInterval]){
            currentInterval = [self getZeroInterval:currentInterval];

        }else{
            currentInterval = currentInterval - [self secondsOfIntervalValue] * x;
        }
        
        moveStart = point;
     
    }
    if (panGestureRecognizer.state == UIGestureRecognizerStateEnded || panGestureRecognizer.state == UIGestureRecognizerStateCancelled){
        if (!self.userInteractionEnabled) {
            return;
        }
        onTouch = NO;
        if (self.delegate && [self.delegate respondsToSelector:@selector(timeLine:moveToDate:)]) {
            [self.delegate timeLine:self moveToDate:[self currentTimeStr]];
        }
    }
    [self setNeedsDisplay];
}
- (NSTimeInterval)getZeroInterval:(NSTimeInterval)timeInterval{
    NSString *date = [self projectTimeWithInterval:timeInterval];
    NSString *dateStr;
    if (date.length == 14) {
       dateStr = [date stringByReplacingCharactersInRange:NSMakeRange(8, 6) withString:@"000000"];
    }
    NSTimeInterval lastTimeInterval = [self intervalWithTime:dateStr];
    return lastTimeInterval;
}
- (NSTimeInterval)getTwoFourInterval:(NSTimeInterval)timeInterval{
    NSString *date = [self projectTimeWithInterval:timeInterval];
    NSString *dateStr;
    if (date.length == 14) {
       dateStr = [date stringByReplacingCharactersInRange:NSMakeRange(8, 6) withString:@"235959"];
    }
    NSTimeInterval lastTimeInterval = [self intervalWithTime:dateStr];
    return lastTimeInterval;
}
-(void)setIsHor:(BOOL)isHor{
    _isHor = isHor;
}
@end
