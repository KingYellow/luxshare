//
//  CruiseTimerSelectView.h
//  luxshare
//
//  Created by 黄振 on 2021/1/11.
//  Copyright © 2021 KingYellow. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^selectTime) (NSString *starttime,NSString *endTime);
@interface CruiseTimerSelectView : UIView
@property (strong, nonatomic)UIPickerView *leftPicker;
@property (strong, nonatomic)UIPickerView *rightPicker;
@property (copy, nonatomic)selectTime selectBlock;
@property (strong, nonatomic)NSString *selectTime;
- (void)creatSelectTimerViewConfig;
@end

NS_ASSUME_NONNULL_END
