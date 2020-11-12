//
//  TYNavigationCallbackProtocol.h
//  TYNavigationController
//
//  Created by TuyaInc on 2018/11/1.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class TYNavigationBarItem;

@protocol TYNavigationCallbackProtocol <NSObject>

@optional

#pragma mark - Action
// 仅回调给当前页面, 使用customView则会自动添加 UITapGesture
- (void)ty_naviBackItemAction:(TYNavigationBarItem *)item;
- (void)ty_naviLeftItemAction:(TYNavigationBarItem *)item;
- (void)ty_naviCenterItemAction:(TYNavigationBarItem *)item;
- (void)ty_naviRightItemAction:(TYNavigationBarItem *)item;

#pragma mark - Transition
- (void)ty_naviTransitionPrepare:(id<UIViewControllerTransitionCoordinator>)coordinator;
- (void)ty_naviTransitioning:(id<UIViewControllerTransitionCoordinatorContext>)context;
- (void)ty_navitransitionFinish:(id<UIViewControllerTransitionCoordinatorContext>)context;

#pragma mark - PopGesture
- (BOOL)ty_naviPopGestureShouldBegin;

@end



@interface UIViewController () <TYNavigationCallbackProtocol>
@end
