//
//  LoginCodeVC.m
//  luxshare
//
//  Created by 黄振 on 2020/6/26.
//  Copyright © 2020 KingYellow. All rights reserved.
//

#import "LoginCodeVC.h"
#import "CodeButton.h"
#import "QZHHUD.h"
#import "RegisterVC.h"

@interface LoginCodeVC ()
@property (strong, nonatomic)UITextField *countryCodeText;
@property (strong, nonatomic)UITextField *phoneText;
@property (strong, nonatomic)UITextField *passwordText;
@property (strong, nonatomic)UIButton *submitBtn;
@property (strong, nonatomic)UIButton *openBtn;
@property (strong, nonatomic)UIButton *sendBtn;
@property (strong, nonatomic)CountrySelectView *countryView;
@property (strong, nonatomic)ContactModel *countryModel;
@property (strong, nonatomic)TuyaSmartHomeManager *magager;
@end

@implementation LoginCodeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = QZHKIT_COLOR_LEADBACK;
   [self exp_navigationBarTextWithColor:QZHKIT_COLOR_NAVIBAR_TITLE font:QZHKIT_FONT_TABBAR_TITLE];
   [self exp_navigationBarColor:QZHKIT_COLOR_NAVIBAR_BACK hiddenShadow:NO];
    self.navigationItem.title = QZHLoaclString(@"login_messageLogin");
    [self setUI];
    self.countryModel = [ContactModel new];
    self.countryModel.code = @"86";
    self.countryModel.chinese = @"中国";
    
}

- (void)setUI{
    QZHWS(weakSelf)
    self.countryView = [CountrySelectView creatSelectView];
    self.countryView.backgroundColor = QZHColorWhite;
    QZHViewRadius(self.countryView, 10);
    QZHViewBorder(self.countryView, 1.0, QZHKIT_COLOR_SHADOW);
    [self.countryView jk_addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
        [weakSelf selectValue];
    }];
    [self.view addSubview:self.countryView];

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

    [self.view addSubview:self.submitBtn];
    [self.view addSubview:self.sendBtn];


    [self.countryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(26*QZHScaleWidth);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(50);
    }];

    [view2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.countryView.mas_bottom).offset(19*QZHScaleWidth);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(50);
    }];
    [self.phoneText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 20, 0, 20));
    }];

    [view3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(view2.mas_bottom).offset(19*QZHScaleWidth);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-120);
        make.height.mas_equalTo(50);
    }];
    [self.passwordText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 20, 0, 20));
    }];

    [self.sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(view3);
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
-(UITextField *)phoneText{
    if (!_phoneText) {
        UITextField *text= [[UITextField alloc] init];
        text.placeholder = QZHLoaclString(@"login_phone");
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
-(UITextField *)passwordText{
    if (!_passwordText) {
        UITextField *text= [[UITextField alloc] init];
        text.placeholder = QZHLoaclString(@"login_verifyCode");
        text.textColor = QZHKIT_Color_BLACK_87;
        text.font = QZHTEXT_FONT(17);
        text.clearButtonMode =  UITextFieldViewModeWhileEditing;
        text.tag = 2;
        text.keyboardType = UIKeyboardTypeNumberPad;
        [text addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventEditingChanged];
        _passwordText = text;
    }
    return _passwordText;
}
-(UIButton *)sendBtn{
    if (!_sendBtn) {
        _sendBtn = [[CodeButton alloc] init];
        
        [_sendBtn setTitle:QZHLoaclString(@"login_getCode") forState:UIControlStateNormal];
        [_sendBtn setTitleColor:QZHKIT_Color_BLACK_54 forState:UIControlStateNormal];
        _sendBtn.titleLabel.font = QZHTEXT_FONT(18);
        _sendBtn.backgroundColor = QZHKIT_COLOR_SKIN;
        [_sendBtn exp_buttonState:QZHButtonStateDisEnable];
        QZHViewRadius(_sendBtn, 25);
        [_sendBtn addTarget:self action:@selector(getCodeWord:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendBtn;
}
-(UIButton *)submitBtn{
    if (!_submitBtn) {
        _submitBtn = [[UIButton alloc] init];
        [_submitBtn setTitle:QZHLoaclString(@"login") forState:UIControlStateNormal];
        _submitBtn.backgroundColor = QZHKIT_COLOR_SKIN;
        [_submitBtn setTitleColor:QZHColorWhite forState:UIControlStateNormal];
        _submitBtn.titleLabel.font = QZHTEXT_FONT(18);
        [self.submitBtn exp_buttonState:QZHButtonStateDisEnable];

        QZHViewRadius(_submitBtn, 25);
        [_submitBtn addTarget:self action:@selector(submitAction) forControlEvents:UIControlEventTouchUpInside];
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

#pragma mark - action

- (void)valueChanged:(UITextField *)textField{
    if (textField.tag == 1) {
        if (self.phoneText.text.length == 11) {
            [self.sendBtn exp_buttonState:QZHButtonStateEnable];
        }else{
            [self.sendBtn exp_buttonState:QZHButtonStateDisEnable];
        }
    }
    
    if (self.phoneText.text.length == 11 && self.passwordText.text.length == 6) {
        [self.submitBtn exp_buttonState:QZHButtonStateEnable];
    }else{
        [self.submitBtn exp_buttonState:QZHButtonStateDisEnable];
    }

}
- (void)submitAction{
    [self checkVertifyCode];

}

// 获取验证码
//发送验证码的类型，0:登录验证码，1:注册验证码，2:重置密码验证码
- (void)loadCodeData:(NSInteger)type{
    
   [[TuyaSmartUser sharedInstance] sendVerifyCode:self.countryModel.code phoneNumber:self.phoneText.text type:type success:^{
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
- (void)selectValue{
    AddressBookTVC *vc = [[AddressBookTVC alloc] init];
    QZHWS(weakSelf)
    vc.countryBlock = ^(ContactModel * _Nonnull countryCode) {
        weakSelf.countryModel = countryCode;
        weakSelf.countryView.describeLab.text = [NSString stringWithFormat:@"%@ +%@",self.countryModel.chinese,self.countryModel.code];
    };

    [self.navigationController pushViewController:vc animated:YES];
}
- (void)passAction:(UIButton *)sender{
    self.openBtn.selected = !self.openBtn.selected;
    self.passwordText.secureTextEntry = !self.openBtn.selected;
}
- (void)getCodeWord:(CodeButton *)jcBtn{
    if (self.phoneText.text.length == 0) {
        [[QZHHUD HUD] textHUDWithMessage:@"请输入手机号" afterDelay:1.0];
        return;
    }
    if ([self.phoneText.text length] != 11) {
        [[QZHHUD HUD] textHUDWithMessage:@"请输入格式正确的手机号" afterDelay:1.0];
        return;
    }
    // 获取验证码
    [self loadCodeData:0];
    
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
    [[TuyaSmartUser sharedInstance] checkCodeWithUserName:self.phoneText.text region:nil countryCode:self.countryModel.code code:self.passwordText.text type:2 success:^(BOOL result) {
            if (result) {
                  [[TuyaSmartUser sharedInstance] loginWithMobile:self.phoneText.text countryCode:self.countryModel.code code:self.passwordText.text success:^{

                    [[QZHHUD HUD] textHUDWithMessage:QZHLoaclString(@"login_success") afterDelay:0.5];
                      [self getHomeList];
                      
                  } failure:^(NSError *error) {
                       [[QZHHUD HUD] textHUDWithMessage:error.userInfo[@"NSLocalizedDescription"] afterDelay:0.5];
                   }];
                
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
