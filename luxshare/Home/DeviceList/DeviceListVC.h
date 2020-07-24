//
//  DeviceListVC.h
//  luxshare
//
//  Created by 黄振 on 2020/7/6.
//  Copyright © 2020 KingYellow. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DeviceListVC : UIViewController

@property (strong, nonatomic)NSArray *listArr;
@property (copy, nonatomic)dispatch_block_t updateDevice;
@property (copy, nonatomic)dispatch_block_t addDevice;

@property (strong, nonatomic)TuyaSmartHomeModel *homeModel;


@end

NS_ASSUME_NONNULL_END
