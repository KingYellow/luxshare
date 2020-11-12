//
//  TYMenuListDefaultCell.h
//  TYUIKit
//
//  Created by TuyaInc on 2019/12/5.
//

#import <UIKit/UIKit.h>

#import "TYMenuListViewController.h"

@interface TYMenuListDefaultCellData : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) UIImage *image;

+ (instancetype)dataWithTitle:(NSString *)title image:(UIImage *)image;

@end

@interface TYMenuListDefaultCell : UITableViewCell <TYMenuListCellProtocol>

@end
