//
//  TYEmptyBaseView.h
//  TYUIKit
//
//  Created by TuyaInc on 2019/5/22.
//

#import <UIKit/UIKit.h>

#import "TYEmptyViewProtocol.h"
#import "UIView+TYEmptyView.h"

NS_ASSUME_NONNULL_BEGIN

@interface TYEmptyBaseView : UIView<TYEmptyViewProtocol>

@property (nonatomic, readonly) BOOL isShowing;

@end

NS_ASSUME_NONNULL_END
