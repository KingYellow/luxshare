//
//  AlarmTimeListVC.h
//  luxshare
//
//  Created by 黄振 on 2020/8/6.
//  Copyright © 2020 KingYellow. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AlarmTimeListVC : UIViewController
@property (strong, nonatomic)TuyaSmartDeviceModel *deviceModel;
@property (strong, nonatomic)TuyaSmartHomeModel *homeModel;
@end

NS_ASSUME_NONNULL_END