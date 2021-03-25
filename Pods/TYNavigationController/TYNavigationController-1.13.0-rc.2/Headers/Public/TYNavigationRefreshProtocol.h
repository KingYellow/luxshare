//
//  TYNavigationRefreshProtocol.h
//  TYNavigationController
//
//  Created by TuyaInc on 2019/9/12.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol TYNavigationRefreshProtocol <NSObject>

- (void)ty_refreshBackAndLeftItems;
- (void)ty_refreshCenterItem;
- (void)ty_refreshRightItem;

- (void)ty_refreshBarAlpha;
- (void)ty_refreshHidden;
- (void)ty_refreshTransform;
- (void)ty_refreshBackground;
- (void)ty_refreshSeparator;
- (void)ty_refreshPopGesture;

@end

NS_ASSUME_NONNULL_END
