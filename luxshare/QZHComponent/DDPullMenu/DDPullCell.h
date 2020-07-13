//
//  DDPullCell.h
//  DDSample
//
//  Created by 黄振 on 2020/3/25.
//  Copyright © 2020 KingYellow. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DDPullCell : UITableViewCell

@property (nonatomic,strong) UIImageView *markView;

+ (instancetype)filterCell;

@end

NS_ASSUME_NONNULL_END
