//
//  UIAlertController+Textfield.m
//  luxshare
//
//  Created by 黄振 on 2020/6/23.
//  Copyright © 2020 KingYellow. All rights reserved.
//

#import "UIAlertController+Textfield.h"

@implementation UIAlertController (Textfield)
+ (UIAlertController *)alertWithTextfieldTitle:(NSString *)title  originaltext:(NSString *)originaltext textblock:(textfieldblock)textblock;{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:@"" preferredStyle:UIAlertControllerStyleAlert];

    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];

    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

        UITextField *userNameTextField = alertController.textFields.firstObject;
        textblock(userNameTextField.text);

    }]];

    [alertController addTextFieldWithConfigurationHandler:^(UITextField*_Nonnull textField) {
        if (originaltext) {
            textField.text = originaltext;
        }
        textField.placeholder=@"请输入";

    }];
    return alertController;

}
@end
