//
//  CameraThreeBtnCell.h
//  luxshare
//
//  Created by 黄振 on 2020/7/7.
//  Copyright © 2020 KingYellow. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^buttontag)(UIButton *sender, BOOL select);
@interface CameraThreeBtnCell : UITableViewCell
@property (strong, nonatomic)UIButton *leftBtn;
@property (strong, nonatomic)UIButton *midBtn;
@property (strong, nonatomic)UIButton *rightBtn;
@property (strong, nonatomic)UIView *bigView;
@property (copy, nonatomic)buttontag btnBlock;
@end

NS_ASSUME_NONNULL_END
