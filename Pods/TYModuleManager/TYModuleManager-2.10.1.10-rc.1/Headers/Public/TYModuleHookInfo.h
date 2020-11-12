//
//  TYModuleHookInfo.h
//  TYModuleManager
//
//  Created by TuyaInc on 2019/5/14.
//

#import <Foundation/Foundation.h>

@class TYModuleHookInfo;

#define TYModuleHookInfoMake(prot, sel) [TYModuleHookInfo hookInfoWith:@protocol(prot) selector:@selector(sel)]

NS_ASSUME_NONNULL_BEGIN

@interface TYModuleHookInfo : NSObject

@property (nonatomic, strong) Protocol *hookProtocol;
@property (nonatomic, strong) NSArray<NSString *> *hookSelectorArr;

+ (TYModuleHookInfo *)hookInfoWith:(Protocol *)prot selector:(SEL)sel;

@end

NS_ASSUME_NONNULL_END
