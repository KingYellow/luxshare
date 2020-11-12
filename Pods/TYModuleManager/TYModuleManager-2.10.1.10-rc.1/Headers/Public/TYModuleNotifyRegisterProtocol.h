//
//  TYModuleNotifyRegisterProtocol.h
//  TYModuleManager
//
//  Created by TuyaInc on 2018/9/3.
//

#import <Foundation/Foundation.h>

#define TYNotifyName(sel) NSStringFromSelector(@selector(sel))

@protocol TYModuleNotifyRegisterProtocol <NSObject>

@optional
/**
 返回本模块能响应的通知方法名
 
 @return @[NSStringFromSelector(@selector(xxx))] / @[TYNotifyName(xxx)]
 */
- (NSArray<NSString *> *)registRespondsNotifies;

@end
