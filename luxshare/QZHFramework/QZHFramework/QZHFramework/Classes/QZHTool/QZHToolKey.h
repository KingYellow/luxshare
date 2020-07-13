//
//  QZHToolKey.h
//  MYM
//
//  这里存放项目中标识常量
//
//  Created by 米翊米 on 2018/6/5.
//  Copyright © 2018年 米翊米. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef QZHToolKey_h
#define QZHToolKey_h

// --------------------------Notification 监听标示----------------------
/** 使用时输入QZHNotification表示与通知相关 */

//通知实例
#define QZHNotification         [NSNotificationCenter defaultCenter]

//通知keyname, 默认定义5个，当在同一级别多个示例注册了监听没有释放时不要调用相同的key
//VC使用
static NSString * const QZHNotificationKeyVC1 = @"QZHNotificationKeyVC1";
static NSString * const QZHNotificationKeyVC2 = @"QZHNotificationKeyVC2";
static NSString * const QZHNotificationKeyVC3 = @"QZHNotificationKeyVC3";
static NSString * const QQZHNotificationKeyVC4 = @"QZHNotificationKeyVC4";
static NSString * const QZHNotificationKeyVC5 = @"QZHNotificationKeyVC5";
//View使用
static NSString * const QZHNotificationKeyVW1 = @"QZHNotificationKeyVW1";
static NSString * const QZHNotificationKeyVW2 = @"QZHNotificationKeyVW2";
static NSString * const QZHNotificationKeyVW3 = @"QZHNotificationKeyVW3";
static NSString * const QZHNotificationKeyVW4 = @"QZHNotificationKeyVW4";
static NSString * const QZHNotificationKeyVW5 = @"QZHNotificationKeyVW5";

//其他地方使用
static NSString * const QZHNotificationKeyK1 = @"QZHNotificationKeyK1";
static NSString * const QZHNotificationKeyK2 = @"QZHNotificationKeyK2";
static NSString * const QZHNotificationKeyK3 = @"QZHNotificationKeyK3";
static NSString * const QZHNotificationKeyK4 = @"QZHNotificationKeyK4";
static NSString * const QZHNotificationKeyK5 = @"QZHNotificationKeyK5";
// --------------------------Notification 监听标示-------------------------


// --------------------------uitableview identifier 常用标识符----------------------
/** 使用时输入QZHIdentifier表示与重用标识符相关 */

static NSString * const QZHIdentifierDefault = @"IdentifierDefault";
static NSString * const QZHIdentifierHeader = @"IdentifierHeader";
static NSString * const QZHIdentifierFooter = @"IdentifierFooter";
static NSString * const QZHIdentifierText = @"IdentifierText";
static NSString * const QZHIdentifierImage = @"IdentifierImage";
static NSString * const QZHIdentifierTool = @"IdentifierTool";
static NSString * const QZHIdentifierOther = @"IdentifierOther";
// --------------------------uitableview identifier  常用标识符--------------------------

#endif /* QZHToolKey_h */
