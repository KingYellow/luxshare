//
//  TYCameraCloudServiceProtocol.h
//  Pods-TYCameraCloudServiceModule_Example
//
//  Created by 傅浪 on 2020/6/6.
//

#import <Foundation/Foundation.h>
@class TuyaSmartDeviceModel;
@protocol TYCameraCloudServiceProtocol <NSObject>

- (void)requestCloudServicePageWithDevice:(TuyaSmartDeviceModel *)deviceModel completionBlock:(void(^)(__kindof UIViewController *page, NSError *error))callback;

@end

