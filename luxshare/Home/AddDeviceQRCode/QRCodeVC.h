//
//  QRCodeVC.h
//  luxshare
//
//  Created by 黄振 on 2020/7/6.
//  Copyright © 2020 KingYellow. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QRCodeVC : UIViewController
@property (strong, nonatomic)NSString *codeStr;
@property (strong, nonatomic)NSString *wifi;
@property (strong, nonatomic)NSString *pw;
@property (strong, nonatomic)NSString *token;
@end

NS_ASSUME_NONNULL_END
