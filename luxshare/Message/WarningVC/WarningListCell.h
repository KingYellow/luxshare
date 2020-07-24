//
//  WarningListCell.h
//  luxshare
//
//  Created by 黄振 on 2020/7/24.
//  Copyright © 2020 KingYellow. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WarningListCell : UITableViewCell
@property (strong, nonatomic)UIButton *selectBtn;
@property (copy, nonatomic)UILabel *nameLab;
@property (copy, nonatomic)UILabel *tagLab;
@property (strong, nonatomic)UILabel *contentLab;
@property (strong, nonatomic)UIView *bigView;

@property (strong, nonatomic)UIButton *checkBtn;
@property (strong, nonatomic)UIImageView *picIMG;
@end

NS_ASSUME_NONNULL_END
