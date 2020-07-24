//
//  SettingSwitchCell.h
//  luxshare
//
//  Created by 黄振 on 2020/7/10.
//  Copyright © 2020 KingYellow. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SettingSwitchCell : UITableViewCell
@property (strong, nonatomic)UIView *bigView;
@property (copy, nonatomic)UISwitch *switchBtn;
@property (copy, nonatomic)UILabel *nameLab;
@property (assign, nonatomic)NSInteger radioPosition;
@end

NS_ASSUME_NONNULL_END
