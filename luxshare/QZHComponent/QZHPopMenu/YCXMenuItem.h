//
//  YCXMenuItem.h
//  YCXMenuDemo_ObjC
//
//  Created by 黄振 on 16/5/6.
//  Copyright (c) 2016年 KingYellow. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface YCXMenuItem : NSObject

@property (readwrite, nonatomic, strong) UIImage      *image;
@property (readwrite, nonatomic, strong) NSString     *title;
@property (readwrite, nonatomic, assign) NSInteger     tag;
@property (readwrite, nonatomic, strong) NSDictionary *userInfo;

@property (readwrite, nonatomic, strong) UIFont  *titleFont;
@property (readwrite, nonatomic) NSTextAlignment  alignment;
@property (readwrite, nonatomic, strong) UIColor *foreColor;

@property (readwrite, nonatomic, weak) id target;
@property (readwrite, nonatomic) SEL      action;



/// 弹窗菜单条目内容
/// @param title 文字内容
/// @param icon  图片
+ (instancetype)menuTitle:(NSString *)title WithIcon:(UIImage *)icon;

/// 弹窗菜单栏条目
/// @param title 文字内容
/// @param image 图片
/// @param tag tag值
/// @param userInfo 传递数据信息
+ (instancetype)menuItem:(NSString *)title image:(UIImage *)image tag:(NSInteger)tag userInfo:(NSDictionary *)userInfo;

/// 弹窗菜单栏条目
/// @param title 文字内容
/// @param image 图片
/// @param target 代理对象
/// @param action 点击回调方法
+ (instancetype)menuItem:(NSString *)title image:(UIImage *)image target:(id)target action:(SEL)action;

- (void)performAction;

- (BOOL)enabled;

@end
