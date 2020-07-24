//
//  TalkTypeCell.h
//  luxshare
//
//  Created by 黄振 on 2020/7/17.
//  Copyright © 2020 KingYellow. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TalkTypeCell : UITableViewCell
@property (strong, nonatomic)UIButton *selectBtn;
@property (copy, nonatomic)UILabel *nameLab;
@property (strong, nonatomic)UILabel *tipLab;
@end

NS_ASSUME_NONNULL_END
