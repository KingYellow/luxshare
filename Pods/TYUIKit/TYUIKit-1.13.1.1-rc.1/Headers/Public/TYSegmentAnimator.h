//
//  TYSegmentAnimator.h
//  TYUIKit
//
//  Created by TuyaInc on 2019/2/28.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^TYSegmentSelectedAnimationBlock)(CGFloat percent);

@interface TYSegmentAnimator : NSObject

@property (nonatomic, assign) NSTimeInterval duration;
@property (nonatomic, copy) void(^progressCallback)(CGFloat percent);
@property (nonatomic, copy) void(^completeCallback)(void);

- (void)start;
- (void)stop;

#pragma mark - util

+ (CGFloat)interpolationFrom:(CGFloat)from to:(CGFloat)to percent:(CGFloat)percent;
+ (UIColor *)interpolationColorFrom:(UIColor *)fromColor to:(UIColor *)toColor percent:(CGFloat)percent;




@end

