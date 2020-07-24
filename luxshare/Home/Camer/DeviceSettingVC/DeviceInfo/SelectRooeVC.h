//
//  SelectRooeVC.h
//  luxshare
//
//  Created by 黄振 on 2020/7/15.
//  Copyright © 2020 KingYellow. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^select)(TuyaSmartRoomModel *model);
@interface SelectRooeVC : UIViewController
@property (strong, nonatomic)TuyaSmartHomeModel *homeModel;
@property (strong, nonatomic)TuyaSmartDeviceModel *deviceModel;
@property (copy, nonatomic)select selectBlack;
@end

NS_ASSUME_NONNULL_END
