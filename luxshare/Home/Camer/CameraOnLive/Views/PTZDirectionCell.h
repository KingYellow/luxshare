//
//  PTZDirectionCell.h
//  luxshare
//
//  Created by 黄振 on 2020/12/22.
//  Copyright © 2020 KingYellow. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^DirectionAction) (NSInteger directionTag);

NS_ASSUME_NONNULL_BEGIN

@interface PTZDirectionCell : UITableViewCell
@property (strong, nonatomic)UIButton *leftBtn;
@property (strong, nonatomic)UIButton *rightBtn;
@property (strong, nonatomic)UIButton *topBtn;
@property (strong, nonatomic)UIButton *bottomBtn;
@property (strong, nonatomic)UIButton *leftTopBtn;
@property (strong, nonatomic)UIButton *leftBottomBtn;
@property (strong, nonatomic)UIButton *rightTopBtn;
@property (strong, nonatomic)UIButton *rightBottomBtn;
@property (strong, nonatomic)UIButton *centerBtn;
@property (copy, nonatomic)DirectionAction direblock;
@end

NS_ASSUME_NONNULL_END
