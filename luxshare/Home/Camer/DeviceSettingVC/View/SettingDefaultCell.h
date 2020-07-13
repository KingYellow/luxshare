//
//  SettingDefaultCell.h
//  luxshare
//
//  Created by 黄振 on 2020/7/10.
//  Copyright © 2020 KingYellow. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SettingDefaultCell : UITableViewCell
@property (strong, nonatomic)UIView *bigView;
@property (copy, nonatomic)UIImageView *IMGView;
@property (copy, nonatomic)UILabel *nameLab;
@property (copy, nonatomic)UILabel *tagLab;
@property (assign, nonatomic)NSInteger radioPosition;
@end

NS_ASSUME_NONNULL_END
