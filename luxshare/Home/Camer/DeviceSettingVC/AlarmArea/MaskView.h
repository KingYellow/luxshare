//
//  MaskView.h
//  luxshare
//
//  Created by 黄振 on 2020/8/11.
//  Copyright © 2020 KingYellow. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^gesture)(CGRect rect, BOOL begain);
@interface MaskView : UIView
@property (assign, nonatomic)CGRect centerRect;
@property (strong, nonatomic)UIView *selectView;
@property (assign, nonatomic)CGRect oldFrame;
@property (assign, nonatomic)CGPoint oldTouchLocal;

@property (strong, nonatomic)UIButton *leftBackBtn;
@property (copy, nonatomic)dispatch_block_t popVCBlock;
@property (copy, nonatomic)gesture gestureBolok;

@end

NS_ASSUME_NONNULL_END
