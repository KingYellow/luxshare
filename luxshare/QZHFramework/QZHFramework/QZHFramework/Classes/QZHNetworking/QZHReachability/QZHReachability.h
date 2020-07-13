//
//  QZHReachability.h
//  Demo
//
//  Created by 米翊米 on 2018/5/25.
//  Copyright © 2018年 米翊米. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QZHNetEnum.h"

@interface QZHReachability : NSObject

+ (void)reachability:(NetworkStatusHandler)statusChange;

@end
