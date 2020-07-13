//
//  DDListCell.h
//  DDSample
//
//  Created by 黄振 on 2020/3/25.
//  Copyright © 2020 KingYellow. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DDListCell : UITableViewCell
@property (copy, nonatomic)UIImageView *IMGView;
@property (copy, nonatomic)UILabel *priceLab;
@property (copy, nonatomic)UILabel *weightLab;
@property (copy, nonatomic)UILabel *timeLab;

@property (copy, nonatomic)NSDictionary *dic;
@end

NS_ASSUME_NONNULL_END
