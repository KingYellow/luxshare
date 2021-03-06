//
//  BackPlayVC.h
//  luxshare
//
//  Created by 黄振 on 2020/7/15.
//  Copyright © 2020 KingYellow. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BackPlayVC : UIViewController<TuyaSmartCameraDelegate>
@property (strong, nonatomic)TuyaSmartDeviceModel *deviceModel;
@property (strong, nonatomic)id<TuyaSmartCameraType> backCamera;

@end

NS_ASSUME_NONNULL_END
