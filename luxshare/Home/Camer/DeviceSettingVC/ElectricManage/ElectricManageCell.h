//
//  ElectricManageCell.h
//  luxshare
//
//  Created by 黄振 on 2020/7/20.
//  Copyright © 2020 KingYellow. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ElectricManageCell : UITableViewCell
@property (copy, nonatomic)UILabel *nameLab;
@property (copy, nonatomic)UILabel *describeLab;

@property (strong, nonatomic)UILabel *statusLab;
@end

NS_ASSUME_NONNULL_END
