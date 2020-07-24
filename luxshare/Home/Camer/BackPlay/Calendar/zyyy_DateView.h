//
//  zyyy_DateView.h
//  日历
//
//  Created by yurong on 2017/7/26.
//  Copyright © 2017年 1. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol zyyy_DateViewDelegate <NSObject>


-(void)selectedDic:(NSDictionary *)dic;

@end
@interface zyyy_DateView : UIView
@property (strong, nonatomic)id<TuyaSmartCameraType> camera;
@property (assign, nonatomic)NSInteger freeMonth;
@property(nonatomic,weak)id<zyyy_DateViewDelegate>delegate;
@property(nonatomic,assign)NSInteger selectedMonth;//选中月
@property(nonatomic,assign)NSInteger selectedYear;//选中年
@property(nonatomic,assign)BOOL isSelected;
-(void)setUIchange;
@end
