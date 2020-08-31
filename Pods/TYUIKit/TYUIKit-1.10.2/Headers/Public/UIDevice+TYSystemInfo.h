//
//  UIDevice+TYSystemInfo.h
//  TYUIKit
//
//  Created by TuyaInc on 2018/12/20.
//

#import <UIKit/UIKit.h>


UIKIT_EXTERN NSString *const kTYSystemName_iOS;

/**
 @return [[[UIDevice currentDevice] systemVersion] floatValue]
 */
UIKIT_EXTERN CGFloat TY_SystemVersion(void);
/**
 @return [[UIDevice currentDevice] systemName]
 */
UIKIT_EXTERN NSString * TY_SystemName(void);

/**
 @return [TY_SystemName isEqualToString:@"iOS"] && TY_SystemVersion >= version
 */
UIKIT_EXTERN BOOL TY_IsIOS(CGFloat version);

