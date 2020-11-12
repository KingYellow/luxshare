//
//  TYEmptyView.h
//  TYUIKit
//
//  Created by TuyaInc on 2019/5/22.
//

#import <UIKit/UIKit.h>

#import "TYEmptyBaseView.h"

NS_ASSUME_NONNULL_BEGIN


@interface TYEmptyView : TYEmptyBaseView

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, strong) NSArray<UIButton *> *actionArr;

#pragma mark - Style
@property (nonatomic) CGPoint centerLocation;  ///< x,y ∈ [0, 1]  default:(0.5, 0.444) 

@property (nonatomic) CGSize imageViewSize;
@property (nonatomic, strong) UIColor *titleColor;
@property (nonatomic, strong) UIFont *titleFont;
@property (nonatomic, strong) UIColor *subtitleColor;
@property (nonatomic, strong) UIFont *subtitleFont;

@property (nonatomic) CGPoint imageOffset;
@property (nonatomic) CGPoint titleOffset;
@property (nonatomic) CGPoint subtitleOffset;
@property (nonatomic) CGPoint actionButtonOffset;

@property (nonatomic) CGFloat actionButtonSpace;    // 间隔

@end

NS_ASSUME_NONNULL_END
