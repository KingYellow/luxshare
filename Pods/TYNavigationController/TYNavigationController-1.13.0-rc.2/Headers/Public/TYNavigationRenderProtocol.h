//
//  TYNavigationRenderProtocol.h
//  TYNavigationController
//
//  Created by TuyaInc on 2019/9/12.
//

#import <Foundation/Foundation.h>

#import "TYNavigationRefreshProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@protocol TYNavigationRenderProtocol <TYNavigationRefreshProtocol>

- (NSArray<UIBarButtonItem *> *)ty_leftUIBarItems;
- (NSArray<UIBarButtonItem *> *)ty_rightUIBarItems;
- (UIView *)ty_centerTitleView;

@end

NS_ASSUME_NONNULL_END
