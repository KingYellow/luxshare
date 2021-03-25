//
//  TYMallProtocol.h
//  TYModuleServices
//
//  Created by TuyaInc on 2018/6/7.
//

#ifndef TYMallProtocol_h
#define TYMallProtocol_h

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, TYMallPageType) {
    TYMallPageTypeHome,      // Mall home page
    TYMallPageTypeOrders,    // Mall orders page
};

@protocol TYMallProtocol <NSObject>

/**
 * Check if mall enable for current logged user.
 * You should check this every time after logged user changed.
 */
- (void)checkIfMallEnableForCurrentUser:(void(^)(BOOL enable, NSError *error))callback;

/**
 * Request special mall page with `TYMallPageType`
 * You should replace mall page every time after logged user changed.
 * @param pageType Mall page type
 */
- (void)requestMallPage:(TYMallPageType)pageType completionBlock:(void(^)(__kindof UIViewController *page, NSError *error))callback;

@end

#endif /* TYMallProtocol_h */
