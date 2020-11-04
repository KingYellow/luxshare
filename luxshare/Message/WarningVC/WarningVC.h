//
//  WarningVC.h
//  luxshare
//
//  Created by 黄振 on 2020/6/30.
//  Copyright © 2020 KingYellow. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^btnblock)(BOOL isselected);
@interface WarningVC : UIViewController

@property (copy, nonatomic)btnblock btnAction;
- (void)rightAction;
@end


NS_ASSUME_NONNULL_END
