//
//  RegisterVC.m
//  luxshare
//
//  Created by 黄振 on 2020/6/24.
//  Copyright © 2020 KingYellow. All rights reserved.
//

#import "RegisterVC.h"
#import "QZHHUD.h"
#import "RegisterSecondVC.h"

@interface RegisterVC ()
@property (strong, nonatomic)UITextField *countryCodeText;
@property (strong, nonatomic)UITextField *phoneText;
@property (strong, nonatomic)UIButton *submitBtn;

@property (strong, nonatomic)CountrySelectView *countryView;
@property (strong, nonatomic)ContactModel *countryModel;
@end

@implementation RegisterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = QZHKIT_COLOR_LEADBACK;
   [self exp_navigationBarTextWithColor:QZHKIT_COLOR_NAVIBAR_TITLE font:QZHKIT_FONT_TABBAR_TITLE];
   [self exp_navigationBarColor:QZHKIT_COLOR_NAVIBAR_BACK hiddenShadow:NO];
    self.navigationItem.title = self.titleText;
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
    [view2 addSubview:self.phoneText];;
    [self.view addSubview:self.submitBtn];

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


    
    [self.submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(view2.mas_bottom).offset(25*QZHScaleWidth);
        make.right.mas_equalTo(-20);
        make.left.mas_equalTo(20);
        make.height.mas_equalTo(50);
    }];

}

#pragma mark  -- getter
-(UITextField *)phoneText{
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

-(UIButton *)submitBtn{
    if (!_submitBtn) {
        _submitBtn = [[UIButton alloc] init];
        [_submitBtn setTitle:QZHLoaclString(@"nextstep") forState:UIControlStateNormal];
        _submitBtn.backgroundColor = QZHKIT_COLOR_SKIN;
        [_submitBtn setTitleColor:QZHColorWhite forState:UIControlStateNormal];
        _submitBtn.titleLabel.font = QZHTEXT_FONT(18);
        [self.submitBtn exp_buttonState:QZHButtonStateDisEnable];
        QZHViewRadius(_submitBtn, 25);
        [_submitBtn addTarget:self action:@selector(submitAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _submitBtn;
}


#pragma mark - action

- (void)valueChanged:(UITextField *)textField{
    if (self.phoneText.text.length > 0 ) {
        [self.submitBtn exp_buttonState:QZHButtonStateEnable];
    }else{
        [self.submitBtn exp_buttonState:QZHButtonStateDisEnable];
    }
}
- (void)submitAction{
    if ([self.phoneText.text exp_isPureInt]) {
        if (self.phoneText.text.length != 11) {
            [[QZHHUD HUD] textHUDWithMessage:@"手机号不正确" afterDelay:0.5];
            return;
        }
    }else if(![self.phoneText.text containsString:@"@."]){
        [[QZHHUD HUD] textHUDWithMessage:@"邮箱不正确" afterDelay:0.5];
        return;
    }
    RegisterSecondVC *vc = [[RegisterSecondVC alloc] init];
    vc.conutry = self.countryModel.code;
    vc.account = self.phoneText.text;
    vc.titleText = self.titleText;
    [self.navigationController pushViewController:vc animated:YES];

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

@end
