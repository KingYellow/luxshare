//
//  WeekSelectVC.h
//  luxshare
//
//  Created by 黄振 on 2020/7/28.
//  Copyright © 2020 KingYellow. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^selectBlock)(NSArray *listArr);
@interface WeekSelectVC : UIViewController
@property (copy, nonatomic)selectBlock selectWeek;
@property (strong, nonatomic)NSMutableArray *listArr;

@end

NS_ASSUME_NONNULL_END
