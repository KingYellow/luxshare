//
//  AlarmTimeListCell.h
//  luxshare
//
//  Created by 黄振 on 2020/8/6.
//  Copyright © 2020 KingYellow. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AlarmTimeListCell : UITableViewCell
@property (strong, nonatomic)UILabel *timeLab;
@property (strong, nonatomic)UILabel *weekLab;
@property (strong, nonatomic)UILabel *itemLab;
@property (strong, nonatomic)UISwitch *statusSwitch;
@end

NS_ASSUME_NONNULL_END
