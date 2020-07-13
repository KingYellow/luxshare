//
//  CameraTBtnCell.h
//  luxshare
//
//  Created by 黄振 on 2020/7/7.
//  Copyright © 2020 KingYellow. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^btntag)(NSInteger tag);
@interface CameraTBtnCell : UITableViewCell
@property (strong, nonatomic)UIButton *leftBtn;
@property (strong, nonatomic)UIButton *rightBtn;
@property (copy, nonatomic)btntag btnBlock;
@end

NS_ASSUME_NONNULL_END
