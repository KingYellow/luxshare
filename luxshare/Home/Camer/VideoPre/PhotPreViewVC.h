//
//  PhotPreViewVC.h
//  luxshare
//
//  Created by 黄振 on 2020/7/15.
//  Copyright © 2020 KingYellow. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PhotPreViewVC : UIViewController
@property (strong, nonatomic)HXPhotoModel *model;
@property (strong, nonatomic)NSString *imgUrl;
@end

NS_ASSUME_NONNULL_END
