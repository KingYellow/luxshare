//
//  UIView+TYEmptyView.h
//  TYUIKit
//
//  Created by TuyaInc on 2019/5/21.
//

#import <UIKit/UIKit.h>

@class TYEmptyBaseView;

NS_ASSUME_NONNULL_BEGIN

@interface UIView (TYEmptyView)

@property (nonatomic, strong) __kindof TYEmptyBaseView *ty_emptyView;

- (void)ty_showEmptyView:(BOOL)animate;
- (void)ty_hideEmptyView:(BOOL)animate;

@end

NS_ASSUME_NONNULL_END
