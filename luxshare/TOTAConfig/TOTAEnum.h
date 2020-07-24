//
//  QZHEnum.h
//  DDSample
//
//  Created by 黄振 on 2020/3/30.
//  Copyright © 2020 KingYellow. All rights reserved.
//

#ifndef QZHEnum_h
#define QZHEnum_h


// --------------------------枚举----------------------
/** 使用时输入QZHEnum表示与枚举相关 */

/// 响应数据状态
typedef NS_ENUM(NSInteger, QZHResponeCode) {
    ///请求失败
    QZHResponeCodeError = -1,
    ///请求成功
    QZHResponeCodeSucces = 200,
    ///未知
    QZHResponeCodeUnkown = -99999,
};

///刷新状态
typedef NS_ENUM(NSUInteger, QZHRefreshHeaderState){
    QZHRefreshHeaderStateIdle,         ///闲置状态
    QZHRefreshHeaderStatePulling,      ///松开就可以进行刷新的状态
    QZHRefreshHeaderStateRefreshing    ///正在刷新中的状态
};

///图片圆角剪切形状
typedef NS_ENUM(NSUInteger, QZHImageViewCornerStyle){
    QZHImageViewCornerNone,         ///不剪切
    QZHImageViewCornerRadio,        ///圆角  默认半径2
    QZHImageViewCornerCircle,       ///圆形图片
    QZHImageViewCornerTriangle      ///三角型
};
#endif /* QZHEnum_h */