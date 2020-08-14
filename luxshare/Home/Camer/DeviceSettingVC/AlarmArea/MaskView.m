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
        self.selectView.frame = CGRectMake(self.center.y -80, self.center.x - 45, 192, 108);
            
        self.oldFrame = self.selectView.frame;
        self.largeFrame = CGRectMake(0 - QZHScreenWidth, 0 - QZHScreenHeight, 3 * self.oldFrame.size.width, 3 * self.oldFrame.size.height);
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
    _centerRect = centerRect;
    [self drawRect:self.frame];
}
-(UIView *)selectView{
    if (!_selectView) {
        _selectView = [[UIView alloc] init];
        _selectView.backgroundColor = QZHColorClear;
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

    if (pinchGestureRecognizer.state == UIGestureRecognizerStateBegan || pinchGestureRecognizer.state == UIGestureRecognizerStateChanged){
        self.gestureBolok(self.selectView.frame, YES);
        self.leftBackBtn.hidden = YES;
        view.transform = CGAffineTransformScale(view.transform, pinchGestureRecognizer.scale, pinchGestureRecognizer.scale);
        pinchGestureRecognizer.scale = 1;
        
    }
    if (pinchGestureRecognizer.state == UIGestureRecognizerStateEnded || pinchGestureRecognizer.state == UIGestureRecognizerStateCancelled){
        self.gestureBolok(self.selectView.frame, NO);
        self.leftBackBtn.hidden = NO;
    }
    [self setNeedsDisplay];

}

// 处理拖拉手势

- (void) panView:(UIPanGestureRecognizer *)panGestureRecognizer{

    UIView *view = panGestureRecognizer.view;
    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan || panGestureRecognizer.state == UIGestureRecognizerStateChanged){
        self.gestureBolok(self.selectView.frame, YES);
        self.leftBackBtn.hidden = YES;

        CGPoint translation = [panGestureRecognizer translationInView:view.superview];

        CGPoint locationPoint = [panGestureRecognizer locationInView:panGestureRecognizer.view];
        CGFloat x = view.frame.origin.x;
        CGFloat y = view.frame.origin.y;
        CGFloat xLen = view.frame.origin.x + view.frame.size.width;
        CGFloat yLen = view.frame.origin.y + view.frame.size.height;

        CGFloat scalWidth = 20.0;
        if (locationPoint.x < scalWidth || locationPoint.y < scalWidth || locationPoint.x > view.frame.size.width - scalWidth || locationPoint.y > view.frame.size.height - scalWidth) {
            
            if (locationPoint.x < scalWidth) {
               x = x + translation.x;
            }
            if (locationPoint.y < scalWidth) {
               y = y + translation.y;
            }
            if (locationPoint.x > view.frame.size.width - scalWidth) {
               xLen = xLen + translation.x;
            }
            if (locationPoint.y > view.frame.size.height - scalWidth) {
               yLen = yLen + translation.y;
            }
            [view setFrame:CGRectMake(x, y, xLen - x, yLen - y)];
        }else{

            [view setCenter:(CGPoint){view.center.x + translation.x, view.center.y + translation.y}];

            [panGestureRecognizer setTranslation:CGPointZero inView:view.superview];
        }


    }
    if (panGestureRecognizer.state == UIGestureRecognizerStateEnded || panGestureRecognizer.state == UIGestureRecognizerStateCancelled){
        self.gestureBolok(self.selectView.frame, NO);
        self.leftBackBtn.hidden = NO;
    }
    [self setNeedsDisplay];

}
- (void)backAction:(UIButton *)sender{
    self.popVCBlock();
}
@end
