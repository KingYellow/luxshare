//
//  TYImpactEngine.h
//  TYUIKit
//
//  Created by TuyaInc on 2019/1/7.
//

#import <Foundation/Foundation.h>

typedef enum : NSInteger {
    TYImpactStyleLight = UIImpactFeedbackStyleLight,
    TYImpactStyleMedium = UIImpactFeedbackStyleMedium,
    TYImpactStyleHeavy = UIImpactFeedbackStyleHeavy,
    
    TYImpactStyleSelection,
    
    TYImpactStyleNotificationSucc,
    TYImpactStyleNotificationFail,
    TYImpactStyleNotificationError,
} TYImpactStyle;

@interface TYImpactEngine : NSObject

+ (void)impactWithStyle:(TYImpactStyle)style NS_AVAILABLE_IOS(10_0);

@end

