//
//  TYRippleView.h
//  TYUIKit
//
//  Created by TuyaInc on 2018/11/6.
//

#import <UIKit/UIKit.h>

@class TYRippleView;

@protocol TYRippleLayerProtocol <NSObject>

@required
+ (instancetype)layer;
- (CAAnimation *)lifeAnimationForLayer:(CGFloat)lifeTime withRippleView:(TYRippleView *)rippleView;

@end

@protocol TYRippleViewDelegateProtocol <NSObject>

- (void)rippleView:(TYRippleView *)rippleView willLaunchLayer:(CALayer<TYRippleLayerProtocol> *)layer;

@end

@interface TYRippleView : UIView

@property (nonatomic, weak) id<TYRippleViewDelegateProtocol> delegate;

/**
 [^zh]
 波纹的类
 需要遵循 TYRippleLayerProtocol
 当没有可用的波纹时，会调用该类 +layer 方法创建
 [$zh]
 [^en]
 class of the ripple layer, need to confirm protocol TYRippleLayerProtocol
 +layer will be call when no more ripple instance
 [$en]
 */
@property (nonatomic, strong) Class<TYRippleLayerProtocol> rippleLayerClass;

/**
 [^zh]
 发射器的位置，默认(0.5, 0.5)
 [$zh]
 [^en]
 location of the emitter, default is (0.5, 0.5)
 [$en]
 */
@property (nonatomic) CGPoint emitterLocation;

/**
 [^zh]发射器视图，用于设置发射器样式[$zh]
 [^en]view of the emitter[$en]
 */
@property (nonatomic, strong) UIView *emitterView;

/**
 [^zh]波纹的展示时间, 单位秒，默认5.0秒[$zh]
 [^en]ripple display time in seconds, default is 5.0s[$en]
 */
@property (nonatomic) CGFloat lifeTime;

/**
 [^zh]多长时间发射一个波纹，单位秒，默认 lifeTime * 0.7[$zh]
 [^en]ripple emission interval in seconds, default is  lifeTime * 0.7[$en]
 */
@property (nonatomic) CGFloat birthRate;

/**
 [^zh]
 一组当中包含的波纹数量，默认0
 当 groupCount > 0时，以组为单位发射
 第一组第一个与第二组第一个的时间间隔为groupDuration
 组内波纹间隔仍为birthRate
 当groupCount == 0，即 以birthRate为间隔连续发射
 当groupCount == 1，即 以groupDuration为间隔连续发射
 [$zh]
 [^en]
 count of ripples in a group, default is 0
 emission in groups when groupCount > 0
 time interval between the first one of group 1 and the first one of group 2 is groupDuration
 the single ripple interval in the group is still birthRate
 groupCount == 0, means one by one, and single ripple interval is birthRate
 groupCount == 1, means one by one, but single ripple interval is groupDuration
 [$en]
 */
@property (nonatomic) NSInteger groupCount;
/**
 [^zh]
 第一组第一个与第二组第一个的时间间隔，即每一组的总时间
 需满足 groupDuration >= birthRate * groupCount
 [$zh]
 [^en]
 time interval between the first one of group 1 and the first one of group 2
 requires groupDuration >= birthRate * groupCount
 [$en]
 */
@property (nonatomic) CGFloat groupDuration;

@property (nonatomic, readonly) BOOL isWorking;

- (void)start;
- (void)stop;

@end
