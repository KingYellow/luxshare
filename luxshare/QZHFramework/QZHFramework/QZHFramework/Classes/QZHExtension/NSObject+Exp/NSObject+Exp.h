//
//  NSObject+Exp.h
//  MYM
//
//  Created by 米翊米 on 2018/6/8.
//  Copyright © 2018年 米翊米. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSObject (Exp)

/// 获取当前vc
- (UIViewController *)exp_getCurrentVC;

///时间戳转时间字符串, time:时间戳 formart:时间字符串格式 replace:time为空时返回的字符串
- (NSString *)exp_timeCoverString:(id)time formart:(NSString *)formart replace:(NSString *)string;

///获取指定位置VC,count为数量，end-YES标示从末尾,NO标示从开头
- (UIViewController *)exp_viewControllerCount:(NSInteger)count end:(BOOL)end;

@end
