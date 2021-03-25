//
//  TYCameraProtocol.h
//  Pods
//
//  Created by TuyaInc on 2018/5/12.
//

#ifndef TYCameraProtocol_h
#define TYCameraProtocol_h

#import <UIKit/UIKit.h>

@class TuyaSmartDeviceModel;

@protocol TYCameraProtocol <NSObject>

/**
 获取摄像头Native面板
 @param devId 摄像头设备的devId
 @param uiName 摄像头设备的uiName，不同的uiName对应不同版本的面板
 */
- (UIViewController *)viewControllerWithDeviceId:(NSString *)devId uiName:(NSString *)uiName;

@optional

- (void)deviceGotoCameraNewPlayBackPanel:(TuyaSmartDeviceModel *)deviceModel;

- (void)deviceGotoCameraCloudStoragePanel:(TuyaSmartDeviceModel *)deviceModel;

- (void)deviceGotoCameraMessageCenterPanel:(TuyaSmartDeviceModel *)deviceModel;

- (void)deviceGotoPhotoLibrary:(TuyaSmartDeviceModel *)deviceModel;

@end

#endif /* TYCameraProtocol_h */
