//
//  TYModuleBaseBlueprint.h
//  TYModuleManager
//
//  Created by TuyaInc on 2018/8/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol TYModuleBaseBlueprint <NSObject>

@optional
/*
 返回一个实例， 未实现则自动调用 +new
 对于有单例需求的模块，有2种解决方案
 1、此方法直接返回单例
 2、注册的时候 TYModuleServiceInfo.singleton = YES， moduleService会保留住对象
 建议优先使用方案2 (因为单例在继承上有问题)
 基础组件均基于方案2实现
*/
+ (instancetype)oneInstance;

@end

NS_ASSUME_NONNULL_END
