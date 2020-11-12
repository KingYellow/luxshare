//
//  TYEmptyViewProtocol.h
//  TYUIKit
//
//  Created by TuyaInc on 2019/5/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol TYEmptyViewProtocol <NSObject>

@optional
- (void)ty_emptyViewDidAddToSuperView;
- (void)ty_emptyViewShouldLayout;
- (void)ty_emptyViewWillShow;
- (void)ty_emptyViewDidShow;
- (void)ty_emptyViewWillHide;
- (void)ty_emptyViewDidHide;

- (void)ty_emptyViewShowAnimation:(void (^ __nullable)(BOOL finished))completion;
- (void)ty_emptyViewHideAnimation:(void (^ __nullable)(BOOL finished))completion;

@end


NS_ASSUME_NONNULL_END
