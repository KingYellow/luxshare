//
//  TYNavigationControllerProtocol.h
//  TYNavigationController
//
//  Created by TuyaInc on 2018/11/13.
//

#import <Foundation/Foundation.h>

#import "TYNavigationRefreshProtocol.h"

@protocol TYNavigationControllerProtocol <TYNavigationRefreshProtocol>

#pragma mark - Refresh
- (void)ty_refreshBlurAlpha;
- (void)ty_refreshHitThrough;

@end
