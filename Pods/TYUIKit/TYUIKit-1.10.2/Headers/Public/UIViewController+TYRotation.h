//
//  UIViewController+TYRotation.h
//  TYUIKit
//
//  Created by TuyaInc on 2019/12/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (TYRotation)

/**
 [^zh]
 如果当前页面不支持当前window的方向，并且-shouldAutorotate返回YES，校正window至受支持的方向
 [$zh]
 [^en]
 rotate window when window orientation is not supported and -shouldAutorotate return YES
 [$en]
 */
- (void)ty_rotateWindowIfNeed;


/**
 [^zh]
 当窗口因校正而发生转动时产生回调
 默认情况下自动根据-supportedInterfaceOrientations匹配
 [$zh]
 [^en]
 callback when window rotates because the view controller does not support it's orientation
 automatically matches -supportedInterfaceOrientations by default
 [$en]
 
 @return [^zh]返回你想要校正的方向[$zh]  [^en]the orientation you want[$en]
 */
- (UIInterfaceOrientation)ty_preferredOrientationForWindowRotation;

@end

NS_ASSUME_NONNULL_END
