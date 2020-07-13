//
//  AddressBookTVC.h
//  DDSample
//
//  Created by 黄振 on 2020/4/7.
//  Copyright © 2020 KingYellow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContactModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^countryCodeBlock)(ContactModel *countryCode);

@interface AddressBookTVC : UITableViewController
@property (copy, nonatomic)countryCodeBlock countryBlock;
@end

NS_ASSUME_NONNULL_END
