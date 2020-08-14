//
//  AlarmTimerVC.h
//  luxshare
//
//  Created by 黄振 on 2020/8/5.
//  Copyright © 2020 KingYellow. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AlarmTimerVC : UIViewController
@property (strong, nonatomic)TuyaSmartDeviceModel *deviceModel;
@property (strong, nonatomic)TuyaSmartHomeModel *homeModel;
@property (copy, nonatomic)dispatch_block_t refresh;
@property (strong, nonatomic)TYTimerModel *timerModel;
@end

NS_ASSUME_NONNULL_END
