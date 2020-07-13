//
//  QZHCodeButton.h
//  MQMedical
//
//  Created by 米翊米 on 2017/12/14.
//  Copyright © 2017年 🐨🐨🐨. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^codeAction)(void);

@interface QZHCodeButton : UIButton

/// 验证码按钮点击事件 stop=NO为用户点击开始 stop=YES为倒计时结束
@property (nonatomic, strong) void(^codeAction)(BOOL stop);

/// 开始验证码倒计时
- (QZHCodeButton *)codeActionWithTimeVal:(NSInteger)timeVal;

/// 停止验证码倒计时
 - (void)stopAction;

@end
