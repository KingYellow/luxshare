//
//  DeviceListCell.h
//  luxshare
//
//  Created by 黄振 on 2020/7/7.
//  Copyright © 2020 KingYellow. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DeviceListCell : UITableViewCell
@property (strong, nonatomic)UIButton *selectBtn;
@property (strong, nonatomic)UIImageView *poloIMG;
@property (copy, nonatomic)UILabel *nameLab;

@end

NS_ASSUME_NONNULL_END
