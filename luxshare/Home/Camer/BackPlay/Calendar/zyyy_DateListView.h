//
//  zyyy_DateListView.h
//  日历
//
//  Created by yurong on 2017/7/26.
//  Copyright © 2017年 1. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^selectDate) (NSDictionary *date);

@interface zyyy_DateListView : UIView
@property(nonatomic,strong)UIScrollView *dateScroView;
@property (strong, nonatomic)id<TuyaSmartCameraType> camera;
@property (copy, nonatomic)selectDate selectDateBlock;
- (void)initConfigs;
@end
