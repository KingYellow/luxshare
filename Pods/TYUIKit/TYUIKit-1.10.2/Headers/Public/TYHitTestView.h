//
//  TYHitTestView.h
//  TYUIKit
//
//  Created by TuyaInc on 2019/12/5.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TYHitTestView : UIView

/// [^zh]当hitTest:withEvent:触发时产生回调[$zh] [^en]callback when hitTest:withEvent: is called[$en]
@property (nonatomic, copy) UIView *(^ty_hitTestBlock)(CGPoint point, UIEvent *event, UIView *defaultResult);

/// [^zh]当pointInside:withEvent:触发时产生回调[$zh] [^en]callback when pointInside:withEvent: is called[$en]
@property (nonatomic, copy) BOOL(^ty_pointInsideBlock)(CGPoint point, UIEvent *event, BOOL defaultResult);

@end

NS_ASSUME_NONNULL_END
