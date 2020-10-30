//
//  CameraOnLiveVC.h
//  luxshare
//
//  Created by 黄振 on 2020/7/7.
//  Copyright © 2020 KingYellow. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CameraOnLiveVC : UIViewController
@property (strong, nonatomic)TuyaSmartDeviceModel *deviceModel;
@property (strong, nonatomic)TuyaSmartHomeModel *homeModel;
@property (assign, nonatomic)BOOL isDoorbellCall;
@end

NS_ASSUME_NONNULL_END
