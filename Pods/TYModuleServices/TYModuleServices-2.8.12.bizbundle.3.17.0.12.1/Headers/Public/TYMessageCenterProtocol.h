//
//  TYMessageCenterProtocol.h
//  TYModuleServices
//
//  Created by Hemin Won on 2020/6/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol TYMessageCenterProtocol <NSObject>

/// push消息中心页面 push message center vc
/// @param animated 动画 animated
- (void)gotoMessageCenterViewControllerWithAnimated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
