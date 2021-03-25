//
//  TYDeviceDetailProtocol.h
//  TYDeviceDetailModule
//
//  Created by 黄凯 on 2018/9/5.
//

#ifndef TYDeviceDetailProtocol_h
#define TYDeviceDetailProtocol_h

@class TuyaSmartDeviceModel;
@class TuyaSmartGroupModel;
@protocol TYDeviceDetailCustomMenuModel;

//@param type configList.json里自己添加的type
//@param device  设备模型
//@param group   群组模型。 根据group是否为nil，来判断设备还是群组
//@return 遵守TYDeviceDetailCustomMenuModel协议的对象。返回nil，该type的item则不会显示
typedef id<TYDeviceDetailCustomMenuModel> _Nullable (^InsertDevMenuItemBlock)(NSString*  _Nonnull type,
                                                                           TuyaSmartDeviceModel* _Nullable device,
                                                                           TuyaSmartGroupModel* _Nullable group);

//回调数据给设备详情
typedef void (^InsertDevMenuItemComplete)(id<TYDeviceDetailCustomMenuModel> _Nullable menuItem);

//异步处理item插入，当异步操作结束以后，调用complete(),回调数据给设备详情，并进行刷新列表。根据group是否为nil，来判断设备还是群组
typedef void (^InsertDevMenuItemAsyncBlock)(NSString* _Nonnull type,
                                            TuyaSmartDeviceModel* _Nullable device,
                                            TuyaSmartGroupModel* _Nullable group,
                                            InsertDevMenuItemComplete _Nonnull complete);

//插入item被点击时候回调。根据group是否为nil，来判断设备还是群组
typedef void (^ClickMenuItemBlock)(NSString* _Nonnull type,
                                   TuyaSmartDeviceModel* _Nullable device
                                   ,TuyaSmartGroupModel* _Nullable group);

@protocol TYDeviceDetailProtocol <NSObject>

/**
 跳转到网络检测页
 
 @param devId 设备 id
 */
- (void)gotoDeviceDetailNetworkViewControllerWithDeviceId:(NSString *)devId;

/**
 跳转到设备详情页，以 push 方式

 @param device 设备
 @param group 群组，若有就传
 */
- (void)gotoDeviceDetailDetailViewControllerWithDevice:(TuyaSmartDeviceModel *)device group:(TuyaSmartGroupModel *)group;

/// 设置-》同步处理item插入的回调
/// @param insertDevMenuItemBlock 同步处理item插入回调
-(void)insertDevMenuItem:(InsertDevMenuItemBlock) insertDevMenuItemBlock;

/// 设置-》异步处理item插入的回调
/// @param insertDevMenuItemAsyncBlock  异步处理item插入的回调
-(void)insertDevMenuItemAsync:(InsertDevMenuItemAsyncBlock) insertDevMenuItemAsyncBlock;

/// 设置-》插入item被点击时候回调
/// @param clickMenuItemBlock  clickMenuItemBlock
-(void)clickMenuItem:(ClickMenuItemBlock) clickMenuItemBlock;


@end

/// 设备详情自定义item的数据必须遵守的协议
@protocol TYDeviceDetailCustomMenuModel <NSObject>
///标题
@property (nonatomic,copy) NSString *title;

///子标题
@property (nonatomic,copy) NSString *detail;


@end

#endif /* TYDeviceDetailProtocol_h */
