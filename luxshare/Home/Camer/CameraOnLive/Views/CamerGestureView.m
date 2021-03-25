//
//  CamerGestureView.m
//  luxshare
//
//  Created by 黄振 on 2021/3/16.
//  Copyright © 2021 KingYellow. All rights reserved.
//

#import "CamerGestureView.h"

@implementation CamerGestureView
-(instancetype)initWithFrame:(CGRect)frame{
    if (self =[super initWithFrame:frame]) {
//        self.alpha = 0;
        self.gestureScale = 1.0;
        self.gestureY = 0;
        self.gestureX = 0;
        //设置 背景为clear
        self.backgroundColor = [UIColor clearColor];
        self.opaque = NO;
        self.selectView.frame = CGRectMake(QZH_VIDEO_LEFTMARGIN, 0, QZH_VIDEO_RIGHTMARGIN - QZH_VIDEO_LEFTMARGIN, QZHScreenWidth);
        self.oldFrame = self.selectView.frame;
        [self addGestureRecognizerToView:self];
 
    }
    return self;
}

- (void)initConfigs{
    
}
#pragma mark  -- 操作中心选择框
- (void)addGestureRecognizerToView:(UIView *)view{

    // 缩放手势
//    UIPinchGestureRecognizer *pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchView:)];
//    [view addGestureRecognizer:pinchGestureRecognizer];

    // 移动手势

    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panView:)];

    [view addGestureRecognizer:panGestureRecognizer];
}

// 处理缩放手势

- (void) pinchView:(UIPinchGestureRecognizer *)pinchGestureRecognizer{

    UIView *view = pinchGestureRecognizer.view;
    if (pinchGestureRecognizer.state == UIGestureRecognizerStateBegan){
        self.oldFrame = view.frame;
    }
    
    if (pinchGestureRecognizer.state == UIGestureRecognizerStateChanged){

            NSLog(@"scale === %f width==%f",pinchGestureRecognizer.scale,view.frame.size.width);
        self.scaGestureBolok(pinchGestureRecognizer.scale * self.gestureScale);

//        pinchGestureRecognizer.scale = 1;
//        self.leftBackBtn.hidden = YES;
//        self.gestureBolok(self.selectView.frame, YES);
    }
    if (pinchGestureRecognizer.state == UIGestureRecognizerStateEnded || pinchGestureRecognizer.state == UIGestureRecognizerStateCancelled){
        self.gestureScale = pinchGestureRecognizer.scale;

        NSLog(@"end");
//        self.gestureBolok(self.selectView.frame, NO);
//        self.leftBackBtn.hidden = NO;
        
    };
}

// 处理拖拉手势

- (void)panView:(UIPanGestureRecognizer *)panGestureRecognizer{

    UIView *view = panGestureRecognizer.view;

    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan){
        CGPoint point = [panGestureRecognizer locationInView:panGestureRecognizer.view];
        NSLog(@"beginX =%f,begainY =%f , old x = %f, oidY = %f",point.x,point.y,self.oldTouchLocal.x,self.oldTouchLocal.y);
        self.oldTouchLocal = point;
        self.orginalX = point.x;
        self.orginalY = point.y;
    }
    if (panGestureRecognizer.state == UIGestureRecognizerStateChanged){
        CGPoint point = [panGestureRecognizer locationInView:panGestureRecognizer.view];

        NSLog(@"beginX =%f,begainY =%f , old x = %f, oidY = %f",point.x,point.y,self.oldTouchLocal.x,self.oldTouchLocal.y);

        [panGestureRecognizer setTranslation:CGPointZero inView:view.superview];
        CGFloat x = point.x - self.oldTouchLocal.x;
        CGFloat y = point.y - self.oldTouchLocal.y;
        if (fabs(x) >= fabs(y)) {
            self.gestureX += x;
        }else{
            self.gestureY += y;
        }
        if (self.gestureScale > 1) {
            self.panGestureBolok(self.gestureX, self.gestureY, self.gestureScale,NO);

        }else{
            if (point.x  - self.orginalX < -20) {
                self.orginalX -= 20;
                self.panGestureBolok(2, -1, 1,NO);

            }
            if (point.x  - self.orginalX > 20) {
                self.orginalX += 20;
                self.panGestureBolok(6, -1, 1,NO);
            }
            if (point.y  - self.orginalY < -20) {
                self.orginalY -= 20;
                self.panGestureBolok(-1, 4, 1,NO);

            }
            if (point.y  - self.orginalY > 20) {
                self.orginalY += 20;
                self.panGestureBolok(-1, 0, 1,NO);
            }
            
        }

        self.oldTouchLocal = [panGestureRecognizer locationInView:panGestureRecognizer.view];
        
    }
    if (panGestureRecognizer.state == UIGestureRecognizerStateEnded || panGestureRecognizer.state == UIGestureRecognizerStateCancelled){
        CGPoint point = [panGestureRecognizer locationInView:panGestureRecognizer.view];
//        self.panGestureBolok(self.gestureX, self.gestureY);
        self.panGestureBolok(0, 0, 1,YES);

        NSLog(@"end");
//        self.gestureBolok(self.selectView.frame, NO);
//        self.leftBackBtn.hidden = NO;
        self.oldTouchLocal = [panGestureRecognizer locationInView:view];

    }
}
@end
