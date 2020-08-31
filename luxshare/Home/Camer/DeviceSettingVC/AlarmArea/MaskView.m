//
//  MaskView.m
//  luxshare
//
//  Created by 黄振 on 2020/8/11.
//  Copyright © 2020 KingYellow. All rights reserved.
//

#import "MaskView.h"

@implementation MaskView
- (instancetype)initWithFrame:(CGRect)frame
    {
        self = [super initWithFrame:frame];
        if (self) {
        //设置 背景为clear
        self.backgroundColor = [UIColor clearColor];
        self.opaque = NO;
        self.selectView.frame = CGRectMake(QZH_VIDEO_LEFTMARGIN, 0, QZH_VIDEO_RIGHTMARGIN - QZH_VIDEO_LEFTMARGIN, QZHScreenWidth);
        self.oldFrame = self.selectView.frame;
        [self addGestureRecognizerToView:self.selectView];
        [self addSubview:self.selectView];
        [self addSubview:self.leftBackBtn];
        self.leftBackBtn.frame = CGRectMake(30, 30, 30, 30);
 
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    [[UIColor colorWithWhite:0 alpha:0.5] setFill];
    //半透明区域
    UIRectFill(rect);
    //透明的区域
    CGRect holeRection = self.selectView.frame;
    /** union: 并集
    CGRect CGRectUnion(CGRect r1, CGRect r2)
    返回并集部分rect
    */
    /** Intersection: 交集
    CGRect CGRectIntersection(CGRect r1, CGRect r2)
    返回交集部分rect
    */
    CGRect holeiInterSection = CGRectIntersection(holeRection, rect);
    [QZHKIT_Color_BLACK_26 setFill];
    //CGContextClearRect(ctx, <#CGRect rect#>)
    //绘制
    //CGContextDrawPath(ctx, kCGPathFillStroke);
    UIRectFill(holeiInterSection);
}
-(void)setCenterRect:(CGRect)centerRect{
    _selectView.frame = centerRect;
    [self drawRect:self.frame];
}
-(UIView *)selectView{
    if (!_selectView) {
        _selectView = [[UIView alloc] init];
        _selectView.backgroundColor = QZHColorClear;
        _selectView.layer.borderColor = QZHKIT_COLOR_SKIN.CGColor;
        _selectView.layer.borderWidth = 1.5;
    }
    return _selectView;
}
-(UIButton *)leftBackBtn{
    if (!_leftBackBtn) {
        _leftBackBtn = [[UIButton alloc] init];
        [_leftBackBtn setImage:QZHLoadIcon(@"nav_btn_back") forState:UIControlStateNormal];
        [_leftBackBtn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
        _leftBackBtn.tag = -100;
    }
    return _leftBackBtn;
}
#pragma mark  -- 操作中心选择框
- (void)addGestureRecognizerToView:(UIView *)view{

    // 缩放手势
    UIPinchGestureRecognizer *pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchView:)];
    [view addGestureRecognizer:pinchGestureRecognizer];

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

        if (view.frame.size.width * pinchGestureRecognizer.scale <= QZHSIZE_WIDTH_ALARMAREA && pinchGestureRecognizer.scale < 1) {
            [view setFrame:CGRectMake(view.center.x - QZHSIZE_WIDTH_ALARMAREA/2, view.center.y - QZHSIZE_WIDTH_ALARMAREA * self.oldFrame.size.height/self.oldFrame.size.width/2, QZHSIZE_WIDTH_ALARMAREA,QZHSIZE_WIDTH_ALARMAREA * self.oldFrame.size.height/self.oldFrame.size.width)];
        }else if (view.frame.size.height <= QZHSIZE_WIDTH_ALARMAREA && pinchGestureRecognizer.scale < 1) {
            [view setFrame:CGRectMake(view.center.x - QZHSIZE_WIDTH_ALARMAREA * self.oldFrame.size.width/self.oldFrame.size.height/2, view.center.y - QZHSIZE_WIDTH_ALARMAREA/2, QZHSIZE_WIDTH_ALARMAREA * self.oldFrame.size.width/self.oldFrame.size.height, QZHSIZE_WIDTH_ALARMAREA)];
        }else{
            CGFloat x = view.center.x - view.frame.size.width/2 * pinchGestureRecognizer.scale;
            CGFloat y = view.center.y - view.frame.size.height/2 * pinchGestureRecognizer.scale;
            CGFloat xlen = view.center.x + view.frame.size.width * pinchGestureRecognizer.scale/2;
            CGFloat ylen = view.center.y + view.frame.size.height * pinchGestureRecognizer.scale/2;
            
            if (x < QZH_VIDEO_LEFTMARGIN) {
                view.frame = CGRectMake(QZH_VIDEO_LEFTMARGIN, view.center.y - view.center.x * self.oldFrame.size.height/self.oldFrame.size.width, view.center.x * 2, view.center.x * 2 * self.oldFrame.size.height/self.oldFrame.size.width);
            }else
            if (y < 0) {
                view.frame = CGRectMake(view.center.x - view.center.y * self.oldFrame.size.width/self.oldFrame.size.height, 0, view.center.y * 2 * self.oldFrame.size.width/self.oldFrame.size.height, view.center.y * 2);
            }else
            if (xlen > QZH_VIDEO_RIGHTMARGIN) {
                view.frame = CGRectMake(view.center.x * 2 - QZH_VIDEO_RIGHTMARGIN, view.center.y - (QZH_VIDEO_RIGHTMARGIN - view.center.x) * self.oldFrame.size.height/self.oldFrame.size.width, (QZH_VIDEO_RIGHTMARGIN - view.center.x) * 2, (QZH_VIDEO_RIGHTMARGIN - view.center.x) * 2 * self.oldFrame.size.height/self.oldFrame.size.width);
            }else
            if (ylen > QZHScreenWidth) {
                view.frame = CGRectMake(view.center.x - (QZHScreenWidth - view.center.y) * self.oldFrame.size.width/self.oldFrame.size.height,2 * view.center.y - QZHScreenWidth, (QZHScreenWidth - view.center.y) * 2 * self.oldFrame.size.width/self.oldFrame.size.height, (QZHScreenWidth - view.center.y) * 2);
            }else{

                view.frame = CGRectMake(view.center.x - view.frame.size.width/2 * pinchGestureRecognizer.scale, view.center.y - view.frame.size.height/2 * pinchGestureRecognizer.scale, view.frame.size.width * pinchGestureRecognizer.scale, view.frame.size.height * pinchGestureRecognizer.scale);
            }
        }
        pinchGestureRecognizer.scale = 1;
        self.leftBackBtn.hidden = YES;
        self.gestureBolok(self.selectView.frame, YES);
    }
    if (pinchGestureRecognizer.state == UIGestureRecognizerStateEnded || pinchGestureRecognizer.state == UIGestureRecognizerStateCancelled){
        self.gestureBolok(self.selectView.frame, NO);
        self.leftBackBtn.hidden = NO;
        
    };
    [self setNeedsDisplay];

}

// 处理拖拉手势

- (void) panView:(UIPanGestureRecognizer *)panGestureRecognizer{

    UIView *view = panGestureRecognizer.view;
    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan){
        CGPoint point = [panGestureRecognizer locationInView:panGestureRecognizer.view];
        NSLog(@"beginX =%f,begainY =%f , old x = %f, oidY = %f",point.x,point.y,self.oldTouchLocal.x,self.oldTouchLocal.y);
        self.oldTouchLocal = point;
    }
    if (panGestureRecognizer.state == UIGestureRecognizerStateChanged){

        CGPoint translation = [panGestureRecognizer translationInView:view.superview];
        CGPoint locationPoint = self.oldTouchLocal;
        CGFloat x = view.frame.origin.x;
        CGFloat y = view.frame.origin.y;
        CGFloat xLen = view.frame.origin.x + view.frame.size.width;
        CGFloat yLen = view.frame.origin.y + view.frame.size.height;
        NSLog(@"lx = %f, ly = %f, tx = %f, ty = %f, w = %f, h = %f, x = %f, y = %f",locationPoint.x, locationPoint.y, translation.x, translation.y, view.frame.size.width, view.frame.size.height,x,y);
        CGFloat scalWidth = 30.0;
        if (locationPoint.x < scalWidth || locationPoint.y < scalWidth || locationPoint.x > view.frame.size.width - scalWidth || locationPoint.y > view.frame.size.height - scalWidth) {
            
            if (locationPoint.x < scalWidth) {
                if (view.frame.size.width < QZHSIZE_WIDTH_ALARMAREA) {
                    x = xLen - QZHSIZE_WIDTH_ALARMAREA;
                }else{
                    x = x + translation.x;
                }
            }
            if (locationPoint.y < scalWidth) {
                if (view.frame.size.height < QZHSIZE_WIDTH_ALARMAREA) {
                    y = yLen - QZHSIZE_WIDTH_ALARMAREA;
                }else{
                    y = y + translation.y;
                }
            }
            if (locationPoint.x > view.frame.size.width - scalWidth) {
                if (view.frame.size.width < QZHSIZE_WIDTH_ALARMAREA) {
                    xLen = x + QZHSIZE_WIDTH_ALARMAREA;
                }else{
                    xLen = xLen + translation.x;
                }
            }
            if (locationPoint.y > view.frame.size.height - scalWidth) {
                if (view.frame.size.height < QZHSIZE_WIDTH_ALARMAREA) {
                      yLen = y + QZHSIZE_WIDTH_ALARMAREA;
                }else{
                    yLen = yLen + translation.y;
                }
            }
            x = MAX(QZH_VIDEO_LEFTMARGIN, x);
            xLen = MIN(QZH_VIDEO_RIGHTMARGIN, xLen);
            y = MAX(0, y);
            yLen = MIN(QZHScreenWidth, yLen);

            [view setFrame:CGRectMake(x, y, xLen - x, yLen - y)];

        }else{
            CGPoint centerP = (CGPoint){view.center.x + translation.x, view.center.y + translation.y};
            centerP.x = MAX(view.frame.size.width/2 + QZH_VIDEO_LEFTMARGIN, centerP.x);
            centerP.x = MIN(QZH_VIDEO_RIGHTMARGIN - view.frame.size.width/2, centerP.x);
            centerP.y = MAX(view.frame.size.height/2, centerP.y);
            centerP.y = MIN(QZHScreenWidth - view.frame.size.height/2, centerP.y);
            [view setCenter:centerP];

        }
        self.oldTouchLocal = [panGestureRecognizer locationInView:panGestureRecognizer.view];

        [panGestureRecognizer setTranslation:CGPointZero inView:view.superview];
        self.gestureBolok(self.selectView.frame, YES);
        self.leftBackBtn.hidden = YES;
        
    }
    if (panGestureRecognizer.state == UIGestureRecognizerStateEnded || panGestureRecognizer.state == UIGestureRecognizerStateCancelled){
        self.gestureBolok(self.selectView.frame, NO);
        self.leftBackBtn.hidden = NO;
        self.oldTouchLocal = [panGestureRecognizer locationInView:view];
    }
    [self setNeedsDisplay];

}
- (void)backAction:(UIButton *)sender{
    self.popVCBlock();
}
@end
