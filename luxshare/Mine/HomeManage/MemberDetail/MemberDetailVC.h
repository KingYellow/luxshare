//
//  MemberDetailVC.h
//  luxshare
//
//  Created by 黄振 on 2020/6/30.
//  Copyright © 2020 KingYellow. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MemberDetailVC : UIViewController
@property (strong, nonatomic)TuyaSmartHomeModel *homeModel;
@property (strong, nonatomic)TuyaSmartHomeMemberModel *memberModel;
@property (copy, nonatomic)dispatch_block_t disHomeBlock;
@end

NS_ASSUME_NONNULL_END
