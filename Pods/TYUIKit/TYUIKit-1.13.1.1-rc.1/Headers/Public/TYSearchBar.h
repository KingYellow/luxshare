//
//  TYSearchBar.h
//  TYUIKit
//
//  Created by TuyaInc on 2019/2/1.
//

#import <UIKit/UIKit.h>

#import "TYSearchBarAppearance.h"

NS_ASSUME_NONNULL_BEGIN

@protocol TYSearchBarDelegate <UISearchBarDelegate>

@optional
- (void)ty_searchBarCancelButtonInitial;

@end


/**
 Available After TuyaSmart 3.9.0+
 */
@interface TYSearchBar : UISearchBar

@property(nonatomic, weak) id<TYSearchBarDelegate> _Nullable delegate;

@property (nonatomic, getter = ty_isActive) BOOL ty_active;

@property (nonatomic, weak, readonly)  UITextField * ty_textField;
@property (nonatomic) UIEdgeInsets ty_textFieldInsets;

/**
 cancel button will not create until it show, so getter method may return nil
 you can use delegate method -ty_searchBarCancelButtonInitial to capture it
 */
@property (nonatomic, weak, readonly)  UIButton * _Nullable ty_cancelButton;
@property (nonatomic) UIEdgeInsets ty_cancelButtonInsets;

@property (nonatomic, strong) UIColor * _Nullable ty_seperatorColor __deprecated_msg("Use ty_separatorColor instead");
@property (nonatomic, strong) UIColor * _Nullable ty_separatorColor;

@end

NS_ASSUME_NONNULL_END
