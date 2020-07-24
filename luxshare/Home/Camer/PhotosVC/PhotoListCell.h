//
//  PhotoListCell.h
//  luxshare
//
//  Created by 黄振 on 2020/7/13.
//  Copyright © 2020 KingYellow. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PhotoListCell : UITableViewCell
@property (copy, nonatomic)UIImageView *IMGView;
@property (strong, nonatomic)UIImageView *logoIMG;
@property (strong, nonatomic)UIButton *selectBtn;
@property (copy, nonatomic)UILabel *nameLab;
@property (copy, nonatomic)UILabel *describeLab;
@end

NS_ASSUME_NONNULL_END
