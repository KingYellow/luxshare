//
//  TYCameraProtocol.h
//  Pods
//
//  Created by TuyaInc on 2018/5/12.
//

#ifndef TYRNCameraProtocol_h
#define TYRNCameraProtocol_h

#import <UIKit/UIKit.h>

@protocol TYRNCameraProtocol <NSObject>

/**
 获取摄像头RN面板
 @param devId 摄像头设备的devId
 */
- (UIViewController *)cameraRNPanelViewControllerWithDeviceId:(NSString *)devId;

@end

#endif /* TYRNCameraProtocol_h */
