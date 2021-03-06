//
//  UpdateDeviceVC.h
//  luxshare
//
//  Created by 黄振 on 2020/7/22.
//  Copyright © 2020 KingYellow. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UpdateDeviceVC : UIViewController
@property (strong, nonatomic)TuyaSmartDeviceModel *deviceModel;
@property (strong, nonatomic)TuyaSmartHomeModel *homeModel;
@property (strong, nonatomic)TuyaSmartFirmwareUpgradeModel *upModel;
@property (copy, nonatomic)dispatch_block_t refresh;
@end

NS_ASSUME_NONNULL_END
