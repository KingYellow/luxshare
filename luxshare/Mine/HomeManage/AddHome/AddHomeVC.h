//
//  AddHomeVC.h
//  luxshare
//
//  Created by 黄振 on 2020/7/1.
//  Copyright © 2020 KingYellow. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AddHomeVC : UIViewController
@property (copy, nonatomic)dispatch_block_t refresh;
@property (assign, nonatomic)BOOL isFirst;
@end

NS_ASSUME_NONNULL_END
