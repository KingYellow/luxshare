//
//  QZHFramework.h
//  Framework
//
//  Created by 米翊米 on 2018/6/28.
//  Copyright © 2018年 米翊米. All rights reserved.
//

#import <Foundation/Foundation.h>

//#import <YYModel/YYModel.h>
#if __has_include(<QZHFramework/QZHFramework.h>)

FOUNDATION_EXPORT double QZHFrameworkVersionNumber;
FOUNDATION_EXPORT const unsigned char QZHFrameworkVersionString[];

#import <QZHFramework/QZHNetworking.h>
#import <QZHFramework/QZHTool.h>
#import <QZHFramework/QZHKit.h>
#import <QZHFramework/QZHExtension.h>


#else

#import "QZHNetworking.h"
#import "QZHTool.h"
#import "QZHKit.h"
#import "QZHExtension.h"

#endif
