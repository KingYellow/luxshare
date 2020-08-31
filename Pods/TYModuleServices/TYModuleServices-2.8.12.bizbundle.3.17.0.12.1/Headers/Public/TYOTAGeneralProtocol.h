//
//  TYOTAGeneralProtocol.h
//  TYModuleServices
//
//  Created by zhukw on 2019/8/5.
//

#import <Foundation/Foundation.h>

@class TuyaSmartDeviceModel;

typedef NS_ENUM(NSUInteger, TYOTAControllerTheme) {
    TYOTAControllerWhiteTheme,
    TYOTAControllerBlackTheme
};

@protocol TYOTAGeneralProtocol <NSObject>

/**
 检查设备固件更新，如果有更新会显示展示出固件更新提示
 
 @param deviceModel 需要检查固件升级的设备
 @param isManual 是否手动检测升级
  @param theme 主题色
 YES: 手动检测升级，检测时弹出loading框。当有固件新版本时(检测升级、强制升级、提醒升级)，显示OTA VC。
 NO: 自动检测升级, 检测时不弹出loading框。当有强制升级时、提醒升级时，弹出固件升级提示，点确定后显示OTA VC。
 */
- (void)checkFirmwareUpgrade:(TuyaSmartDeviceModel *)deviceModel isManual:(BOOL)isManual theme:(TYOTAControllerTheme)theme;

@end
