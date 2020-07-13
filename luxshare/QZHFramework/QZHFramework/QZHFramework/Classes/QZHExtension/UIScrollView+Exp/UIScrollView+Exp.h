//
//  UIScrollView+Exp.h
//  exp
//
//  Created by 米翊米 on 2017/8/29.
//  Copyright © 2017年 🐨🐨🐨. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 刷新控件类型
 
 - RefreshTypeHeader: 下拉刷新
 - RefreshTypeFooter: 上拉加载
 - RefreshTypeAll: 下拉加载/上拉刷新
 */
typedef NS_ENUM(NSInteger, RefreshType) {
    RefreshTypeHeader,//默认从0开始
    RefreshTypeFooter,
    RefreshTypeAll,
};

@interface UIScrollView (Exp)

/**
 添加刷新控件
 
 @param type 刷新类型
 */
- (void)exp_addRefresh:(RefreshType)type target:(id)target;

/**
 结束刷新
 */
- (void)exp_closeRefresh;

/**
 下拉刷新
 */
- (void)exp_refreshHandler;

/**
 上拉加载
 */
- (void)exp_loadMoreHandler;


@end
