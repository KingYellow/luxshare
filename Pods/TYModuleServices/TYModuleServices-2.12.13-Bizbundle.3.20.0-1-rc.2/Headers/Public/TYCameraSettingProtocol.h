//
//  TYCameraSettingProtocol.h
//  TYModuleServices
//
//  Created by lialong on 2020/5/7.
//

#ifndef TYCameraSettingProtocol_h
#define TYCameraSettingProtocol_h

#import <UIKit/UIKit.h>

@protocol TYCameraSettingProtocol <NSObject>

/**
 获取摄像头设置面板
 @param params 摄像头设备的相关参数
 */
- (UIViewController *)settingViewControllerWithDeviceParams:(NSDictionary *)params;

@end

#endif /* TYCameraSettingProtocol_h */
