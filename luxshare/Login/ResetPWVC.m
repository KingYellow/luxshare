//
//  ResetPWVC.m
//  luxshare
//
//  Created by 黄振 on 2020/6/24.
//  Copyright © 2020 KingYellow. All rights reserved.
//

#import "ResetPWVC.h"
#import "CodeButton.h"
#import "QZHHUD.h"

@interface ResetPWVC ()
@property (strong, nonatomic)UITextField *countryCodeText;
@property (strong, nonatomic)UITextField *phoneText;
@property (strong, nonatomic)UITextField *passwordText;
@property (strong, nonatomic)UITextField *codeText;
@property (strong, nonatomic)CodeButton *sendBtn;
@property (strong, nonatomic)UIButton *submitBtn;
@end

@implementation ResetPWVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = QZHLoaclString(@"reset_password");
    [self setUI];
    
}
- (void)setUI{
    UILabel *label1 = [self leftNameLabelText:QZHLoaclString(@"login_countryCode")];
    [self.view addSubview:label1];
    UILabel *label2 = [self leftNameLabelText:QZHLoaclString(@"login_account")];
    [self.view addSubview:label2];
    UILabel *label3 = [self leftNameLabelText:QZHLoaclString(@"reset_newPassword")];
    [self.view addSubview:label3];
    UILabel *label4 = [self leftNameLabelText:QZHLoaclString(@"login_verifyCode")];
    [self.view addSubview:label4];
    
    UIView *view1 = [[UIView alloc] init];
    view1.backgroundColor = QZHColorWhite;
    QZHViewRadius(view1, 10);
    QZHViewBorder(view1, 1.0, QZHKIT_COLOR_SHADOW);
    
    [self.view addSubview:view1];
    [view1 addSubview:self.countryCodeText];
    
    UIView *view2 = [[UIView alloc] init];
    view2.backgroundColor = QZHColorWhite;
    QZHViewRadius(view2, 10);
    QZHViewBorder(view2, 1.0, QZHKIT_COLOR_SHADOW);
    
    [self.view addSubview:view2];
    [view2 addSubview:self.phoneText];
    
    UIView *view3 = [[UIView alloc] init];
    view3.backgroundColor = QZHColorWhite;
    QZHViewRadius(view3, 10);
    QZHViewBorder(view3, 1.0, QZHKIT_COLOR_SHADOW);
    
    [self.view addSubview:view3];
    [view3 addSubview:self.passwordText];
    
    UIView *view4 = [[UIView alloc] init];
    view4.backgroundColor = QZHColorWhite;
    QZHViewRadius(view4, 10);
    QZHViewBorder(view4, 1.0, QZHKIT_COLOR_SHADOW);
    
    [self.view addSubview:view4];
    [view4 addSubview:self.codeText];
    
    [self.view addSubview:self.sendBtn];
    [self.view addSubview:self.submitBtn];
   
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(26*QZHScaleWidth);
        make.left.mas_equalTo(20);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(50);
    }];
    [view1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(26*QZHScaleWidth);
        make.left.mas_equalTo(130);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(50);
    }];
    [self.countryCodeText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 20, 0, 20));
    }];
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(view1.mas_bottom).offset(19*QZHScaleWidth);
        make.left.mas_equalTo(20);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(50);
    }];
    [view2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(view1.mas_bottom).offset(19*QZHScaleWidth);
        make.left.mas_equalTo(130);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(50);
    }];
    [self.phoneText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 20, 0, 20));
    }];
    
    [label3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(view2.mas_bottom).offset(19*QZHScaleWidth);
        make.left.mas_equalTo(20);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(50);
    }];
    [view3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(view2.mas_bottom).offset(19*QZHScaleWidth);
        make.left.mas_equalTo(130);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(50);
    }];
    [self.passwordText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 20, 0, 20));
    }];
    [label4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(view3.mas_bottom).offset(19*QZHScaleWidth);
        make.left.mas_equalTo(20);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(50);
    }];
    [view4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(view3.mas_bottom).offset(19*QZHScaleWidth);
        make.left.mas_equalTo(130);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(50);
    }];
    [self.codeText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 20, 0, 20));
    }];
    
    [self.sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(view4.mas_bottom).offset(25*QZHScaleWidth);
        make.left.mas_equalTo(20);
        make.width.mas_equalTo(QZHScreenWidth/2 - 30);
        make.height.mas_equalTo(50);
    }];
    [self.submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(view4.mas_bottom).offset(25*QZHScaleWidth);
        make.right.mas_equalTo(-20);
        make.width.mas_equalTo(QZHScreenWidth/2 - 30);
        make.height.mas_equalTo(50);
    }];
  
}

#pragma mark  -- getter
- (UITextField *)phoneText{
    if (!_phoneText) {
        UITextField *text= [[UITextField alloc] init];
        text.placeholder = QZHLoaclString(@"login_account");
        text.textColor = QZHKIT_Color_BLACK_87;
        text.font = QZHTEXT_FONT(17);
        text.keyboardType = UIKeyboardTypeNumberPad;
        text.clearButtonMode =  UITextFieldViewModeWhileEditing;
        text.tag = 1;

        [text addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventEditingChanged];
        _phoneText = text;
    }
    return _phoneText;
}
- (UITextField *)passwordText{
    if (!_passwordText) {
        UITextField *text= [[UITextField alloc] init];
        text.placeholder = QZHLoaclString(@"reset_newPassword");
        text.textColor = QZHKIT_Color_BLACK_87;
        text.font = QZHTEXT_FONT(17);
        text.clearButtonMode =  UITextFieldViewModeWhileEditing;
        text.tag = 2;
        text.secureTextEntry = YES;
        [text addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventEditingChanged];
        _passwordText = text;
    }
    return _passwordText;
}
- (UIButton *)sendBtn{
    if (!_sendBtn) {
        _sendBtn = [[CodeButton alloc] init];
        
        [_sendBtn setTitle:QZHLoaclString(@"login_sendCode") forState:UIControlStateNormal];
        [_sendBtn setTitleColor:QZHKIT_Color_BLACK_54 forState:UIControlStateNormal];
        _sendBtn.titleLabel.font = QZHTEXT_FONT(18);
        _sendBtn.backgroundColor = QZHKIT_COLOR_SKIN;
        QZHViewRadius(_sendBtn, 10);
        [_sendBtn addTarget:self action:@selector(getCodeWord:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendBtn;
}
- (UIButton *)submitBtn{
    if (!_submitBtn) {
        _submitBtn = [[UIButton alloc] init];
        [_submitBtn setTitle:QZHLoaclString(@"reset_password") forState:UIControlStateNormal];
        _submitBtn.backgroundColor = QZHKIT_COLOR_SKIN;
        [_submitBtn setTitleColor:QZHColorWhite forState:UIControlStateNormal];
        _submitBtn.titleLabel.font = QZHTEXT_FONT(18);
        QZHViewRadius(_submitBtn, 10);
        [_submitBtn addTarget:self action:@selector(submitAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _submitBtn;
}
- (UITextField *)codeText{
    if (!_codeText) {
        UITextField *text= [[UITextField alloc] init];
        text.placeholder = QZHLoaclString(@"login_verifyCode");
        text.textColor = QZHKIT_Color_BLACK_54;
        text.font = QZHTEXT_FONT(17);
        text.keyboardType = UIKeyboardTypeNumberPad;
        text.clearButtonMode =  UITextFieldViewModeWhileEditing;
        text.tag = 3;
        [text addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventEditingChanged];
        _codeText = text;
    }
    return _codeText;
}
- (UITextField *)countryCodeText{
    if (!_countryCodeText) {
        UITextField *text= [[UITextField alloc] init];
        text.placeholder = QZHLoaclString(@"login_countryCode");
        text.textColor = QZHKIT_Color_BLACK_54;
        text.font = QZHTEXT_FONT(17);
        QZHWS(weakSelf)
        [text jk_addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
            [weakSelf selectValue];
        }];
        _countryCodeText = text;
    }
    return _countryCodeText;
}

#pragma mark - action
- (void)getCodeWord:(CodeButton *)jcBtn{
    if (self.phoneText.text.length == 0) {
        [[QZHHUD HUD] textHUDWithMessage:QZHLoaclString(@"iphoneCantSpace") afterDelay:1.0];
        return;
    }
//    if ([self.phoneText.text length] != 11) {
//        [[QZHHUD HUD] textHUDWithMessage:@"请输入格式正确的手机号" afterDelay:1.0];
//        return;
//    }
    // 获取验证码
    [self loadCodeData:1];
    
    jcBtn.enabled = NO;
    [jcBtn startWithSecond:60];
    [jcBtn didChangBlock:^NSString *(CodeButton *countDownButton,int second) {
        NSString *title = [NSString stringWithFormat:@"剩余%d秒",second];
        
        return title;
        
    }];
    
    [jcBtn didFinshBlock:^NSString *(CodeButton *countDownBtn, int second) {
        countDownBtn.enabled = YES;
        // 获取验证码
        return @"重新获取";
    }];
}
- (void)valueChanged:(UITextField *)textField{
    if (textField.tag == 0) {
//        if (textField.text.length > 11) {
//            textField.text = [textField.text substringToIndex:11];
//        }
    }
    if (textField.tag == 1) {
//        if (textField.text.length > 11) {
//            textField.text = [textField.text substringToIndex:6];
//        }
    }
}
- (void)submitAction{
    
    if ([self.phoneText.text length] == 0) {
        [[QZHHUD HUD] textHUDWithMessage:QZHLoaclString(@"iphoneCantSpace") afterDelay:1.0];
        return;
    }
//    if ([self.phoneText.text length] != 11) {
//        [[QZHHUD HUD] textHUDWithMessage:@"请输入正确手机号" afterDelay:1.0];
//        return;
//    }
    if ([self.codeText.text length] == 0) {
        [[QZHHUD HUD] textHUDWithMessage:QZHLoaclString(@"codeCantSpace") afterDelay:1.0];
        return;
    }
    [self checkCode];

}

// 获取验证码
//发送验证码的类型，0:登录验证码，1:注册验证码，2:重置密码验证码
- (void)loadCodeData:(NSInteger)type{
    
   [[TuyaSmartUser sharedInstance] sendVerifyCode:self.countryCodeText.text phoneNumber:self.phoneText.text type:2 success:^{
       NSLog(@"sendVerifyCode success");
   } failure:^(NSError *error) {
       [[QZHHUD HUD] textHUDWithMessage:error.userInfo[@"NSLocalizedDescription"] afterDelay:0.5];
   }];
}

- (UILabel *)leftNameLabelText:(NSString *)title{
    UILabel *label = [[UILabel alloc] init];
    label.textColor = QZHKIT_Color_BLACK_87;
    label.font = QZHKIT_FONT_LISTCELL_MAIN_TITLE;
    label.text = title;
    label.textAlignment = NSTextAlignmentLeft;
    return label;
}
//验证码验证
- (void)checkCode{
    [[TuyaSmartUser sharedInstance] checkCodeWithUserName:self.phoneText.text region:nil countryCode:self.countryCodeText.text code:self.codeText.text type:2 success:^(BOOL result) {
        
        if (result) {
            [[TuyaSmartUser sharedInstance] resetPasswordByPhone:self.countryCodeText.text phoneNumber:self.phoneText.text newPassword:self.passwordText.text code:self.codeText.text success:^{
                [[QZHHUD HUD] textHUDWithMessage:@"重置成功" afterDelay:1.0];
                NSLog(@"resetPasswordByPhone success");
            } failure:^(NSError *error) {
                [[QZHHUD HUD] textHUDWithMessage:error.userInfo[@"NSLocalizedDescription"] afterDelay:0.5];
            }];
                NSLog(@"valid code!");
        } else {
            NSLog(@"invalid code!");
        }
    } failure:^(NSError *error) {
            [[QZHHUD HUD] textHUDWithMessage:error.userInfo[@"NSLocalizedDescription"] afterDelay:0.5];
    }];
}
- (void)selectValue{
    AddressBookTVC *vc = [[AddressBookTVC alloc] init];
    QZHWS(weakSelf)

    [self.navigationController pushViewController:vc animated:YES];
}
@end
