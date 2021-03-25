//
//  CamerGestureView.h
//  luxshare
//
//  Created by 黄振 on 2021/3/16.
//  Copyright © 2021 KingYellow. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^gesture)(CGRect rect, BOOL begain);
typedef void(^scaleGesture)(CGFloat sca);
typedef void(^panGesture)(CGFloat gestureX, CGFloat gestureY, CGFloat scale,BOOL end);

@interface CamerGestureView : UIView
@property (assign, nonatomic)CGRect centerRect;
@property (strong, nonatomic)UIView *selectView;
@property (assign, nonatomic)CGRect oldFrame;
@property (assign, nonatomic)CGPoint oldTouchLocal;

@property (strong, nonatomic)UIButton *leftBackBtn;
@property (copy, nonatomic)dispatch_block_t popVCBlock;
@property (copy, nonatomic)gesture gestureBolok;
@property (copy, nonatomic)scaleGesture scaGestureBolok;
@property (copy, nonatomic)panGesture panGestureBolok;

@property (assign, nonatomic)CGFloat gestureScale;
@property (assign, nonatomic)CGFloat gestureX;
@property (assign, nonatomic)CGFloat gestureY;
//手势起始点
@property (assign, nonatomic)CGFloat orginalX;
@property (assign, nonatomic)CGFloat orginalY;

@end

NS_ASSUME_NONNULL_END
