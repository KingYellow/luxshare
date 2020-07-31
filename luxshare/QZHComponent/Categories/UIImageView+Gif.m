//
//  UIImageView+Gif.m
//  luxshare
//
//  Created by 黄振 on 2020/7/29.
//  Copyright © 2020 KingYellow. All rights reserved.
//

#import "UIImageView+Gif.h"
#import <objc/runtime.h>

@implementation UIImageView (Gif)
//加载动画
-(void)startPlayGifWithImages:(NSArray *)imgArr{

    __block NSString *str = imgArr.firstObject;
    self.image = [UIImage imageNamed:str];
    //定时器开始执行的延时时间
    NSTimeInterval delayTime = 0.0f;
    //定时器间隔时间
    NSTimeInterval timeInterval = 0.5f;
    
   __block NSInteger index = 0;
    //创建子线程队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //使用之前创建的队列来创建计时器
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    //设置延时执行时间，delayTime为要延时的秒数
    dispatch_time_t startDelayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayTime * NSEC_PER_SEC));
    //设置计时器
    dispatch_source_set_timer( self.timer, startDelayTime, timeInterval * NSEC_PER_SEC, 0.5 * NSEC_PER_SEC);
    dispatch_source_set_event_handler( self.timer, ^{
//        //执行事件
//        if ([str isEqualToString:@"ty_adddevice_light"]) {
//            str = @"ty_adddevice_lighting";
//        } else {
//            str = @"ty_adddevice_light";
//        }
        str = imgArr[index];
        index++;
        if (index == imgArr.count) {
            index = 0;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setImage:[UIImage imageNamed:str]];
        }) ;
    });
    // 启动计时器
    dispatch_resume(self.timer);
}
//停止动画
-(void)stopGif{
    if (self.timer) {
        dispatch_source_cancel(self.timer);
    }
    self.hidden = YES;

}


-(void)setTimer:(dispatch_source_t)timer{
    objc_setAssociatedObject(self, @"timerkey", timer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);


}
-(dispatch_source_t)timer{
    return objc_getAssociatedObject(self, @"timerkey");

}
@end
