//
//  DDLoginVC.m
//  DDSample
//
//  Created by 黄振 on 2020/3/24.
//  Copyright © 2020 KingYellow. All rights reserved.
//

#import "DDLoginVC.h"
#import "CodeButton.h"
#import "QZHHUD.h"
#import "RegisterVC.h"
#import "LoginCodeVC.h"

@interface DDLoginVC ()
@property (strong, nonatomic)UITextField *countryCodeText;
@property (strong, nonatomic)UITextField *phoneText;
@property (strong, nonatomic)UITextField *passwordText;
@property (strong, nonatomic)UIButton *submitBtn;
@property (strong, nonatomic)UIButton *openBtn;
@property (strong, nonatomic)UIButton *messageBtn;
@property (strong, nonatomic)UIButton *forgetBtn;
@property (strong, nonatomic)CountrySelectView *countryView;
@property (strong, nonatomic)ContactModel *countryModel;
@property (strong, nonatomic)TuyaSmartHomeManager *magager;
@end

@implementation DDLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = QZHKIT_COLOR_LEADBACK;
   [self exp_navigationBarTextWithColor:QZHKIT_COLOR_NAVIBAR_TITLE font:QZHKIT_FONT_TABBAR_TITLE];
   [self exp_navigationBarColor:QZHKIT_COLOR_NAVIBAR_BACK hiddenShadow:NO];
    self.navigationItem.title = QZHLoaclString(@"login");
    [self exp_addRightItemTitle:QZHLoaclString(@"register") itemIcon:@""];
    [self setUI];
    self.countryModel = [ContactModel new];
    self.countryModel.code = @"86";
    self.countryModel.chinese = @"中国";
    self.countryModel.english = @"China";

    [self.navigationItem.titleView sizeThatFits:CGSizeMake(100, 44)];
}
- (void)exp_rightAction{
    RegisterVC *vc = [[RegisterVC alloc] init];
    vc.titleText = QZHLoaclString(@"register");
    [self.navigationController pushViewController:vc animated:YES];
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
    [self.view addSubview:self.messageBtn];
    [self.view addSubview:self.forgetBtn];
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
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(50);
    }];
    [self.passwordText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 20, 0, 20));
    }];
    
    [self.submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(view3.mas_bottom).offset(25*QZHScaleWidth);
        make.right.mas_equalTo(-20);
        make.left.mas_equalTo(20);
        make.height.mas_equalTo(50);
    }];
    [self.messageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.submitBtn.mas_bottom).offset(25*QZHScaleWidth);
        make.right.mas_equalTo(self.forgetBtn.mas_left);
        make.left.mas_equalTo(20);
        make.height.mas_equalTo(30);
    }];
    [self.forgetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.submitBtn.mas_bottom).offset(25*QZHScaleWidth);
        make.right.mas_equalTo(-20);
        make.left.mas_equalTo(self.messageBtn.mas_right);
        make.height.mas_equalTo(30);
    }];
  
}

#pragma mark  -- getter
- (UITextField *)phoneText{
    if (!_phoneText) {
        UITextField *text= [[UITextField alloc] init];
        text.placeholder = QZHLoaclString(@"login_account");
        text.textColor = QZHKIT_Color_BLACK_87;
        text.font = QZHTEXT_FONT(17);
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

- (UIButton *)submitBtn{
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

- (UIButton *)messageBtn{
    if (!_messageBtn) {
        _messageBtn = [[UIButton alloc] init];
        [_messageBtn setTitle:QZHLoaclString(@"login_loginWithMessage") forState:UIControlStateNormal];
        [_messageBtn setTitleColor:QZHKIT_Color_BLACK_54 forState:UIControlStateNormal];
        _messageBtn.titleLabel.font = QZHTEXT_FONT(13);
        _messageBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;

        [_messageBtn addTarget:self action:@selector(messageLoginAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _messageBtn;
}
- (UIButton *)forgetBtn{
    if (!_forgetBtn) {
        _forgetBtn = [[UIButton alloc] init];
        [_forgetBtn setTitle:QZHLoaclString(@"login_forgetPassword") forState:UIControlStateNormal];
        [_forgetBtn setTitleColor:QZHKIT_Color_BLACK_54 forState:UIControlStateNormal];
        _forgetBtn.titleLabel.font = QZHTEXT_FONT(14);
        _forgetBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_forgetBtn addTarget:self action:@selector(forgetPWAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _forgetBtn;
}
//显示密码
- (UIButton *)openBtn{
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
    
    if ([self.phoneText.text length] > 0 && [self.phoneText.text exp_isPureInt] && self.passwordText.text.length > 0) {
       [self.submitBtn exp_buttonState:QZHButtonStateEnable];

    }else if (QZHEMAILRIGHT(self.phoneText.text) && self.passwordText.text.length > 0){
        
        [self.submitBtn exp_buttonState:QZHButtonStateEnable];

    }else{
        
        [self.submitBtn exp_buttonState:QZHButtonStateDisEnable];
    }

}
- (void)submitAction{
    
    if ([self.phoneText.text exp_isPureInt]) {
       [self.submitBtn exp_buttonState:QZHButtonStateEnable];
        
        [[TuyaSmartUser sharedInstance] loginByPhone:self.countryModel.code phoneNumber:self.phoneText.text password:self.passwordText.text success:^{
            //登录接口请求成功后
            [self getHomeList];

        } failure:^(NSError *error) {
            
            [[QZHHUD HUD] textHUDWithMessage:error.userInfo[@"NSLocalizedDescription"] afterDelay:0.5];
        }];
        
    }else{
        
        [[TuyaSmartUser sharedInstance] loginByEmail:self.countryModel.code email:self.phoneText.text password:self.passwordText.text success:^{
            //登录接口请求成功后
               [self getHomeList];

        } failure:^(NSError *error) {
               [[QZHHUD HUD] textHUDWithMessage:error.userInfo[@"NSLocalizedDescription"] afterDelay:0.5];
        }];
    }

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
        weakSelf.countryView.describeLab.text = [NSString stringWithFormat:@"%@ +%@",[QZHCommons languageOfTheDeviceSystem] == LanguageChinese?self.countryModel.chinese:self.countryModel.english,self.countryModel.code];
    };

    [self.navigationController pushViewController:vc animated:YES];
}
- (void)passAction:(UIButton *)sender{
    self.openBtn.selected = !self.openBtn.selected;
    self.passwordText.secureTextEntry = !self.openBtn.selected;
}
- (void)messageLoginAction{
    LoginCodeVC *vc = [[LoginCodeVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)forgetPWAction{
    RegisterVC *vc = [[RegisterVC alloc] init];
    vc.titleText = QZHLoaclString(@"login_getPassword");
    [self.navigationController pushViewController:vc animated:YES];
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
