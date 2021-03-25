//
//  TYSegmentIndicatorView.h
//  TYUIKit
//
//  Created by TuyaInc on 2019/2/28.
//

#import <UIKit/UIKit.h>
#import "TYSegmentCell.h"
#import "TYSegmentedControl.h"

@interface TYIndicatorModel : NSObject
@property (nonatomic, assign) NSInteger   selectedIndex;
@property (nonatomic, assign) CGRect      selectedCellFrame;
@property (nonatomic, assign) NSInteger   leftIndex;
@property (nonatomic, assign) CGRect      leftCellFrame;
@property (nonatomic, assign) NSInteger   rightIndex;
@property (nonatomic, assign) CGRect      rightCellFrame;
@property (nonatomic, assign) CGFloat     percent;
@property (nonatomic, assign) NSInteger   lastSelectedIndex;

@property (nonatomic, assign) TYSegmentItemSelectType    selectedType;

@end

@interface TYSegmentIndicatorView : UIView

@property (nonatomic, assign) BOOL scrollEnabled;

@property (nonatomic, assign) CGFloat veticalOffset;

@property (nonatomic, assign) TYSegmentIndicatorPosition segmentPosition;

@property (nonatomic, assign) TYSegmentIndicatorAnimation animation;

@property (nonatomic, assign) CGFloat indicatorLineViewHeight;

@property (nonatomic, assign) CGFloat scrollAnimationDuration;

@property (nonatomic, assign) CGFloat indicatorLineWidth;

@property (nonatomic, assign) CGFloat indicatorLineViewCornerRadius;

@property (nonatomic, strong) UIColor *indicatorLineViewColor;

- (void)refreshState:(TYIndicatorModel *)model;

- (void)contentScrollViewDidScroll:(TYIndicatorModel *)model;

- (void)selectedCell:(TYIndicatorModel *)model;

@end

