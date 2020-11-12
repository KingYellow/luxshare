//
//  UIViewController+TYVisible.h
//  TYActivatorModule
//
//  Created by TuyaInc on 2020/8/4.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (TYVisible)

/// 是否在顶层可见的状态
@property (nonatomic, assign, readonly, getter=isTy_visible) BOOL ty_visible;

@end

NS_ASSUME_NONNULL_END
