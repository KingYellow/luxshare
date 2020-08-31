//
//  TYPanelProtocol.h
//  TYModuleServices
//
//  Created by TuyaInc on 2018/4/13.
//

#ifndef TYPanelProtocol_h
#define TYPanelProtocol_h

@class TuyaSmartDeviceModel;
@class TuyaSmartGroupModel;

@protocol TYPanelProtocol <NSObject>
NS_ASSUME_NONNULL_BEGIN

// 清除面板缓存
- (void)cleanPanelCache;

/**
 * 跳转面板，push 的方式
 *
 * @param device        设备模型
 * @param group         群组模型
 * @param initialProps  自定义初始化参数，会以 'extraInfo' 为 key 设置进 RN 应用的 initialProps 中
 * @param contextProps  自定义面板上下文，会以 'extraInfo' 为 key 设置进 Panel Context 中
 * @param completion 完成跳转后的结果回调
 */
- (void)gotoPanelViewControllerWithDevice:(TuyaSmartDeviceModel *)device
                                    group:(nullable TuyaSmartGroupModel *)group
                             initialProps:(nullable NSDictionary *)initialProps
                             contextProps:(nullable NSDictionary *)contextProps
                               completion:(void(^ _Nullable)(NSError * _Nullable error))completion;

/**
 * 跳转面板，present 的方式
 *
 * @param device 设备模型
 * @param group 群组模型
 * @param initialProps  自定义初始化参数，会以 'extraInfo' 为 key 设置进 RN 应用的 initialProps 中
 * @param contextProps  自定义面板上下文，会以 'extraInfo' 为 key 设置进 Panel Context 中
 * @param completion 完成跳转后的结果回调
 */
- (void)presentPanelViewControllerWithDevice:(TuyaSmartDeviceModel *)device
                                       group:(nullable TuyaSmartGroupModel *)group
                                initialProps:(nullable NSDictionary *)initialProps
                                contextProps:(nullable NSDictionary *)contextProps
                                  completion:(void (^ _Nullable)(NSError * _Nullable error))completion;

// RN版本号
- (NSString *_Nonnull)rnVersionForApp;

NS_ASSUME_NONNULL_END
@end

#endif /* TYPanelProtocol_h */
