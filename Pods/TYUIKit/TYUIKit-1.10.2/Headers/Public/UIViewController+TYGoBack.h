//
//  UIViewController+TYGoBack.h
//  TYUIKit
//
//  Created by TuyaInc on 2019/10/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (TYGoBack)

/*
 [^zh]返回到上一个页面，包含present的页面[$zh]
 [^en]go back to previous page，including present page[$en]
 */
- (void)ty_goBackToPreviousPage:(BOOL)animated;

- (void)ty_goBackToFirstPage:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
