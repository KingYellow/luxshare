//
//  NSLocale+TYLanguage.h
//  TYFoundationKit
//
//  Created by TuyaInc on 2019/3/30.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXTERN NSString * TY_SystemLanguage(void);
FOUNDATION_EXTERN NSString * TY_SystemLanguageCode(void);
FOUNDATION_EXTERN BOOL TY_IsChineseLanguage(void);

@interface NSLocale (TYLanguage)

/**
 Implemented with [[NSBundle mainBundle] preferredLocalizations]
 */
+ (NSString *)ty_systemLanguage;

/**
 Separated ty_systemLanguate by "-" and return the first object
 */
+ (NSString *)ty_systemLanguageCode;

+ (BOOL)ty_isChineseLanguate;

@end

NS_ASSUME_NONNULL_END
