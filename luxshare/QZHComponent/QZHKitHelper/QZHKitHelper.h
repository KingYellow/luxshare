//
//  QZHKitHelper.h
//  DDSample
//
//  Created by 黄振 on 2020/3/30.
//  Copyright © 2020 KingYellow. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QZHKitHelper : NSObject

//全局实例
+(instancetype)kitHelper;

///UITabBarController 子控制器
@property (nonatomic, strong) NSArray <UIViewController *>*tabbarElements;
///UITabBarController 标题
@property (nonatomic, strong) NSArray <NSString *>*tabbarTitles;
///UITabBarController 未选中图标
@property (nonatomic, strong) NSArray <NSString *>*tabbarNomarlIcons;
///UITabBarController 未选中图标
@property (nonatomic, strong) NSArray <NSString *>*tabbarSelectedIcons;

///改变状态栏样式
@property (nonatomic, assign) UIBarStyle statusBarStyle;

///ui相关配置
- (void)configKit;

///网络服务配置
- (void)configNetwork;

///创建底部导航标签
- (UITabBarController *)buildTabbarVC;
@end

NS_ASSUME_NONNULL_END
