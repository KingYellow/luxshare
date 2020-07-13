//
//  UIAlertController+Textfield.h
//  luxshare
//
//  Created by 黄振 on 2020/6/23.
//  Copyright © 2020 KingYellow. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void (^textfieldblock) (NSString *fieldtext);

@interface UIAlertController (Textfield)
+ (UIAlertController *)alertWithTextfieldTitle:(NSString *)title originaltext:(NSString *)originaltext textblock:(textfieldblock)textblock;
@end

NS_ASSUME_NONNULL_END
