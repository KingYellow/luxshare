//
//  UITableView+Exp.h
//  exp
//
//  Created by 米翊米 on 2017/8/29.
//  Copyright © 2017年 🐨🐨🐨. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UITableView (Exp)

/**
 tableview default
 */
- (void)exp_tableViewDefault;

/**
 footerView//适配iPhone X用
 */
- (void)exp_tableViewFooterView;

/**
 左边距为0
 */
- (void)exp_separatorZero;

/**
 隐藏分割线
 */
- (void)exp_separatorHidden;

/**
 初始化从xib
 
 @param nibName xib名称
 @param identifier 重用标识符
 */
- (void)exp_initCellFromNib:(NSString *)nibName identifier:(NSString *)identifier;

/**
 初始化从class
 
 @param className class名称
 @param identifier 重用标识符
 */
- (void)exp_initCellFromClass:(NSString *)className identifier:(NSString *)identifier;

///注册表头表尾class
- (void)exp_initHeaderFooterViewFromClass:(NSString *)className identifier:(NSString *)identifier;

///注册表头表尾xib
- (void)exp_initHeaderFooterViewFromXib:(NSString *)nibName identifier:(NSString *)identifier;

///按照section圆角 radius:圆角大小 space:左右间距 backColor:cell背景色 shadowColor:阴影 selectColor:选中时背景色 cell:当前cell indexPath:当前位置
- (void)exp_groupRadius:(CGFloat)radius space:(CGFloat)space backColor:(UIColor *)backColor shadowColor:(UIColor *)shadowColor selectedBackColor:(UIColor *)selectColor willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;
///section局部滚动
- (void)exp_refreshAtIndexSection:(NSInteger)section;
///某个cell刷新
- (void)exp_refreshAtIndexSection:(NSInteger)section Row:(NSInteger)row;
@end
