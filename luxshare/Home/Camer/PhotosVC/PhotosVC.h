//
//  PhotosVC.h
//  luxshare
//
//  Created by 黄振 on 2020/7/11.
//  Copyright © 2020 KingYellow. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^btnblock)(BOOL isselected);
@interface PhotosVC : UIViewController

@property (copy, nonatomic)btnblock btnAction;
@end

NS_ASSUME_NONNULL_END
