//
//  NameEditVC.h
//  DDSample
//
//  Created by 黄振 on 2020/4/2.
//  Copyright © 2020 KingYellow. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef  void (^selectroomBlock)(NSString *name);

NS_ASSUME_NONNULL_BEGIN

@interface NameEditVC : UIViewController
@property (copy, nonatomic)UITextField *nameField;
@property (copy, nonatomic)NSString *titleName;
@property (strong, nonatomic)TuyaSmartHome *home;
@property (copy, nonatomic)dispatch_block_t refresh;
@property (copy, nonatomic)selectroomBlock selectBlock;
@end

NS_ASSUME_NONNULL_END
