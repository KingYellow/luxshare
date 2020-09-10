//
//  RegisterSecondVC.m
//  luxshare
//
//  Created by 黄振 on 2020/6/26.
//  Copyright © 2020 KingYellow. All rights reserved.
//

#import "RegisterSecondVC.h"
#import "CodeButton.h"
#import "QZHHUD.h"

@interface RegisterSecondVC ()
@property (strong, nonatomic)UITextField *passwordText;
@property (strong, nonatomic)UITextField *codeText;
@property (strong, nonatomic)CodeButton *sendBtn;
@property (strong, nonatomic)UIButton *submitBtn;
@property (strong, nonatomic)UIButton *openBtn;
@property (strong, nonatomic)TuyaSmartHomeManager *magager;
@property (strong, nonatomic)NSString *phone;
@end

@implementation RegisterSecondVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = QZHKIT_COLOR_LEADBACK;
   [self exp_navigationBarTextWithColor:QZHKIT_COLOR_NAVIBAR_TITLE font:QZHKIT_FONT_TABBAR_TITLE];
   [self exp_navigationBarColor:QZHKIT_COLOR_NAVIBAR_BACK hiddenShadow:NO];
    self.navigationItem.title = self.titleText;
    [self setUI];
   
}

- (void)setUI{
    UILabel *label1 = [[UILabel alloc] init];
    label1.textColor = QZHKIT_Color_BLACK_87;
    label1.textAlignment = NSTextAlignmentCenter;
    label1.font = QZHKIT_FONT_LISTCELL_SUB_TITLE;
    
    UILabel *label2 = [[UILabel alloc] init];
    label2.textColor = QZHColorRed;
    label2.textAlignment = NSTextAlignmentCenter;
    label2.font = QZHKIT_FONT_LISTCELL_SUB_TITLE;
    
    [self.view addSubview:label1];
    [self.view addSubview:label2];
    
    if ([self.account exp_isPureInt]){
        label1.text = @"验证码将发到你手机:";
        
    }else {
        label1.text = @"验证码将发到你邮箱:";
    }
    label2.text = self.account;
    
    UIView *view2 = [[UIView alloc] init];
    view2.backgroundColor = QZHColorWhite;
    QZHViewRadius(view2, 10);
    QZHViewBorder(view2, 1.0, QZHKIT_COLOR_SHADOW);
    
    [self.view addSubview:view2];
    [view2 addSubview:self.codeText];
    
    UIView *view3 = [[UIView alloc] init];
    view3.backgroundColor = QZHColorWhite;
    QZHViewRadius(view3, 10);
    QZHViewBorder(view3, 1.0, QZHKIT_COLOR_SHADOW);
    
    [self.view addSubview:view3];
    [view3 addSubview:self.passwordText];

    [self.view addSubview:self.submitBtn];
    [self.view addSubview:self.sendBtn];
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(30*QZHScaleWidth);
        make.left.right.mas_equalTo(0);
    }];
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(label1.mas_bottom).offset(5);
        make.left.right.mas_equalTo(0);
    }];

    [view2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(label2.mas_bottom).offset(19*QZHScaleWidth);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-120);
        make.height.mas_equalTo(50);
    }];
    [self.codeText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 20, 0, 20));
    }];

    [view3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(view2.mas_bottom).offset(19*QZHScaleWidth);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(50);
    }];
    [self.passwordText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 20, 0, 20));
    }];
    [self.sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(view2);
        make.right.mas_equalTo(-20);
        make.width.mas_equalTo(90);
        make.height.mas_equalTo(50);
    }];
    [self.submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(view3.mas_bottom).offset(25*QZHScaleWidth);
        make.right.mas_equalTo(-20);
        make.left.mas_equalTo(20);
        make.height.mas_equalTo(50);
    }];

}

#pragma mark  -- getter

-(UITextField *)passwordText{
    if (!_passwordText) {
        UITextField *text= [[UITextField alloc] init];
        text.placeholder = QZHLoaclString(@"login_password");
        text.textColor = QZHKIT_Color_BLACK_87;
        text.font = QZHTEXT_FONT(17);
        text.clearButtonMode =  UITextFieldViewModeWhileEditing;
        text.tag = 2;
        text.rightView = self.openBtn;
        text.rightViewMode = UITextFieldViewModeAlways;
        text.secureTextEntry = YES;
        [text addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventEditingChanged];
        _passwordText = text;
    }
    return _passwordText;
}

-(UIButton *)submitBtn{
    if (!_submitBtn) {
        _submitBtn = [[UIButton alloc] init];
        [_submitBtn setTitle:QZHLoaclString(@"submit") forState:UIControlStateNormal];
        _submitBtn.backgroundColor = QZHKIT_COLOR_SKIN;
        [_submitBtn setTitleColor:QZHColorWhite forState:UIControlStateNormal];
        _submitBtn.titleLabel.font = QZHTEXT_FONT(18);
        [self.submitBtn exp_buttonState:QZHButtonStateDisEnable];

        QZHViewRadius(_submitBtn, 25);
        [_submitBtn addTarget:self action:@selector(checkVertifyCode) forControlEvents:UIControlEventTouchUpInside];
    }
    return _submitBtn;
}


//显示密码
-(UIButton *)openBtn{
    if (!_openBtn) {
        UIButton *button = [[UIButton alloc] init];
        button.frame = CGRectMake(0, 0, 24, 24);
        [button setImage:QZHLoadIcon(@"login_invisible_icon") forState:UIControlStateNormal];
        [button setImage:QZHLoadIcon(@"login_visible_icon") forState:UIControlStateSelected];
        [button addTarget:self action:@selector(passAction:) forControlEvents:UIControlEventTouchUpInside];
        _openBtn = button;
    }
    return _openBtn;
}
-(CodeButton *)sendBtn{
    if (!_sendBtn) {
        _sendBtn = [[CodeButton alloc] init];
        
        [_sendBtn setTitle:QZHLoaclString(@"login_getCode") forState:UIControlStateNormal];
        [_sendBtn setTitleColor:QZHKIT_Color_BLACK_54 forState:UIControlStateNormal];
        _sendBtn.titleLabel.font = QZHTEXT_FONT(18);
        _sendBtn.backgroundColor = QZHKIT_COLOR_SKIN;
        QZHViewRadius(_sendBtn, 25);
        [_sendBtn addTarget:self action:@selector(getCodeWord:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendBtn;
}
-(UITextField *)codeText{
    if (!_codeText) {
        UITextField *text= [[UITextField alloc] init];
        text.placeholder = QZHLoaclString(@"login_verifyCode");
        text.textColor = QZHKIT_Color_BLACK_87;
        text.font = QZHTEXT_FONT(17);
        text.clearButtonMode =  UITextFieldViewModeWhileEditing;
        text.tag = 2;
        text.keyboardType = UIKeyboardTypeNumberPad;
        [text addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventEditingChanged];
        _codeText = text;
    }
    return _codeText;
}
#pragma mark - action

- (void)valueChanged:(UITextField *)textField{
    if (self.codeText.text.length == 6 && self.passwordText.text.length > 0) {
        [self.submitBtn exp_buttonState:QZHButtonStateEnable];
    }else{
        [self.submitBtn exp_buttonState:QZHButtonStateDisEnable];
    }
}
- (void)submitAction{
    //忘记 重置密码
    if ([self.titleText isEqualToString:QZHLoaclString(@"login_getPassword")]||[self.titleText isEqualToString:QZHLoaclString(@"login_resetPassword")]){
        //重置密码

        if ([self.account exp_isPureInt]){
            //手机
            [[TuyaSmartUser sharedInstance] resetPasswordByPhone:self.conutry phoneNumber:self.account newPassword:self.passwordText.text code:self.codeText.text success:^{
                [[QZHHUD HUD] textHUDWithMessage:QZHLoaclString(@"resetPasswordByPhonesuccess") afterDelay:0.5];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [QZHDataHelper removeForKey:QZHKEY_TOKEN];
                    [QZHROOT_DELEGATE setVC];
                });

            } failure:^(NSError *error) {
               [[QZHHUD HUD] textHUDWithMessage:error.userInfo[@"NSLocalizedDescription"] afterDelay:0.5];
            }];
        }else{
            //邮箱
            [[TuyaSmartUser sharedInstance] resetPasswordByEmail:self.conutry email:self.account newPassword:self.passwordText.text code:self.codeText.text success:^{
                [[QZHHUD HUD] textHUDWithMessage:QZHLoaclString(@"resetPasswordByPhonesuccess") afterDelay:0.5];
                [QZHDataHelper removeForKey:QZHKEY_TOKEN];
                [QZHROOT_DELEGATE setVC];

            } failure:^(NSError *error) {
                [[QZHHUD HUD] textHUDWithMessage:error.userInfo[@"NSLocalizedDescription"] afterDelay:0.5];
                
            }];
        }

    }else{
        //注册
         if ([self.account exp_isPureInt]) {
            [[TuyaSmartUser sharedInstance] registerByPhone:self.conutry phoneNumber:self.account password:self.passwordText.text code:self.codeText.text success:^{
                   
                //登录接口请求成功后
               [[QZHHUD HUD] textHUDWithMessage:QZHLoaclString(@"regist_success") afterDelay:0.5];
                [self getHomeList];
            } failure:^(NSError *error) {
               [[QZHHUD HUD] textHUDWithMessage:error.userInfo[@"NSLocalizedDescription"] afterDelay:0.5];
            }];
            
        }else{
            [[TuyaSmartUser sharedInstance] registerByEmail:self.conutry email:self.account password:self.passwordText.text code:self.codeText.text success:^{
                    //登录接口请求成功后
                   [[QZHHUD HUD] textHUDWithMessage:QZHLoaclString(@"regist_success") afterDelay:0.5];
                    [self getHomeList];

            } failure:^(NSError *error) {
                [[QZHHUD HUD] textHUDWithMessage:error.userInfo[@"NSLocalizedDescription"] afterDelay:0.5];
            }];
        }
    }

}

// 获取验证码
//发送验证码的类型，0:登录验证码，1:注册验证码，2:重置密码验证码
- (void)loadCodeData:(NSInteger)type{

    
    if ([self.account exp_isPureInt]) {
        [[TuyaSmartUser sharedInstance] sendVerifyCode:self.conutry phoneNumber:self.account type:type success:^{
            [[QZHHUD HUD] textHUDWithMessage:QZHLoaclString(@"verify_code_success") afterDelay:0.5];

        } failure:^(NSError *error) {
            [[QZHHUD HUD] textHUDWithMessage:error.userInfo[@"NSLocalizedDescription"] afterDelay:0.5];
            [self.sendBtn stop];
        }];
    }else{
        if (type == 2) {
            [[TuyaSmartUser sharedInstance] sendVerifyCodeByEmail:self.conutry email:self.account success:^{
                [[QZHHUD HUD] textHUDWithMessage:QZHLoaclString(@"verify_code_success") afterDelay:0.5];

            } failure:^(NSError *error) {
                [[QZHHUD HUD] textHUDWithMessage:error.userInfo[@"NSLocalizedDescription"] afterDelay:0.5];
                [self.sendBtn stop];
                
            }];
            
        }else{
            [[TuyaSmartUser sharedInstance] sendVerifyCodeByRegisterEmail:self.conutry email:self.account success:^{
                [[QZHHUD HUD] textHUDWithMessage:QZHLoaclString(@"verify_code_success") afterDelay:0.5];
            } failure:^(NSError *error) {
                [[QZHHUD HUD] textHUDWithMessage:error.userInfo[@"NSLocalizedDescription"] afterDelay:0.5];
                [self.sendBtn stop];
                
            }];
        }

  
    }

}

- (UILabel *)leftNameLabelText:(NSString *)title{
    UILabel *label = [[UILabel alloc] init];
    label.textColor = QZHKIT_Color_BLACK_87;
    label.font = QZHKIT_FONT_LISTCELL_MAIN_TITLE;
    label.text = title;
    label.textAlignment = NSTextAlignmentLeft;
    return label;
}


- (void)passAction:(UIButton *)sender{
    self.openBtn.selected = !self.openBtn.selected;
    self.passwordText.secureTextEntry = !self.openBtn.selected;
}
- (void)getCodeWord:(CodeButton *)jcBtn{
    
    //忘记 重置密码
    if ([self.titleText isEqualToString:QZHLoaclString(@"login_getPassword")]||[self.titleText isEqualToString:QZHLoaclString(@"login_resetPassword")]){
        // 获取验证码

        [self loadCodeData:2];

    }else{
        [self loadCodeData:1];

    }
    
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
-(void)checkVertifyCode{
    NSInteger type = 1;
    if ([self.titleText isEqualToString:QZHLoaclString(@"login_getPassword")]||[self.titleText isEqualToString:QZHLoaclString(@"login_resetPassword")]){
        //重置密码
        type = 3;
    }else{
        type = 1;
    }
    [[TuyaSmartUser sharedInstance] checkCodeWithUserName:self.account region:nil countryCode:self.conutry code:self.codeText.text type:type success:^(BOOL result) {
            if (result) {
                [self submitAction];
            } else {
        [[QZHHUD HUD] textHUDWithMessage:QZHLoaclString(@"verify_code_invalid") afterDelay:0.5];
        }
    } failure:^(NSError *error) {
            [[QZHHUD HUD] textHUDWithMessage:error.userInfo[@"NSLocalizedDescription"] afterDelay:0.5];
    }];
}

#pragma mark -- 获取家庭
- (void)getHomeList {
   self.magager = [TuyaSmartHomeManager new];
    [self.magager getHomeListWithSuccess:^(NSArray<TuyaSmartHomeModel *> *homes) {
        if (homes.count == 0) {
            [QZHROOT_DELEGATE showFamilyVC];
        }else{
            [QZHDataHelper saveValue:QZHKEY_TOKEN forKey:QZHKEY_TOKEN];
            [[QZHHUD HUD] textHUDWithMessage:QZHLoaclString(@"login_success") afterDelay:0.5];
            [QZHROOT_DELEGATE setVC];
        }

    } failure:^(NSError *error) {
        [[QZHHUD HUD] textHUDWithMessage:error.userInfo[@"NSLocalizedDescription"] afterDelay:0.5];
        
    }];
}
@end
