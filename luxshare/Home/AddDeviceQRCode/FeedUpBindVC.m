//
//  FeedUpBindVC.m
//  luxshare
//
//  Created by 黄振 on 2020/8/20.
//  Copyright © 2020 KingYellow. All rights reserved.
//
#import <TuyaSmartFeedbackKit/TuyaSmartFeedbackKit.h>
#import "FeedUpBindVC.h"

@interface FeedUpBindVC ()<UITextViewDelegate>
@property (strong, nonatomic) UIView *backView;
@property (strong, nonatomic) UIView *subBackView;
@property (strong, nonatomic) UITextView *diyTextView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *tipsLabel;
@property (strong, nonatomic) UILabel *descLabel;
@property (nonatomic, strong) UIButton *righButton;
@property (strong, nonatomic) UILabel *subTitleLabel;
@property (strong, nonatomic) UITextField *accountText;
@property (strong, nonatomic)UIButton *submitBtn;

@end

@implementation FeedUpBindVC

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initConfig];
    
}
- (void)initConfig{
    self.view.backgroundColor = QZHKIT_COLOR_LEADBACK;
    self.navigationItem.title = QZHLoaclString(@"device_addNewDevice");
    [self exp_navigationBarTextWithColor:QZHKIT_COLOR_NAVIBAR_TITLE font:QZHKIT_FONT_TABBAR_TITLE];
    [self exp_navigationBarColor:QZHKIT_COLOR_NAVIBAR_BACK hiddenShadow:NO];
    [self UIConfig];
    self.navigationItem.title = @"撰写反馈";

}
- (void)UIConfig{
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.backView];
    [self.backView addSubview:self.diyTextView];
    [self.backView addSubview:self.tipsLabel];
    [self.backView addSubview:self.descLabel];
    [self.view addSubview:self.subTitleLabel];
    [self.view addSubview:self.subBackView];
    [self.subBackView addSubview:self.accountText];
    [self.view addSubview:self.submitBtn];
    [self.submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);

        make.height.mas_equalTo(50); make.bottom.mas_equalTo(self.view).offset(-QZHHeightBottom -30);
    }];
    QZHViewRadius(self.submitBtn,25);
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.height.mas_equalTo(20);
        make.top.mas_equalTo(10);
    }];
    [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(15);
    }];
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(10);
        make.height.mas_equalTo(260);
    }];
    [self.diyTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(240);
    }];
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.mas_equalTo(-10);
    }];
    [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(self.backView.mas_bottom).offset(10);
        make.height.mas_equalTo(20);
    }];
    [self.subBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.subTitleLabel.mas_bottom).offset(10);
        make.height.mas_equalTo(40);
    }];
    [self.accountText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(40);
    }];
}

#pragma mark - textviewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    if ([textView.text length] > 300) {
        textView.text = [textView.text substringToIndex:300];
        [self.view endEditing:YES];
        [[QZHHUD HUD] textHUDWithMessage:@"剩余可输入0字" afterDelay:1.0];
        [self.submitBtn exp_buttonState:QZHButtonStateEnable];
        self.righButton.userInteractionEnabled = YES;
        self.tipsLabel.hidden = YES;
        return;
    } else if(textView.text.length == 0) {
        self.tipsLabel.hidden = NO;
        [self.submitBtn exp_buttonState:QZHButtonStateDisEnable];
        self.righButton.userInteractionEnabled = NO;
    } else {
        self.tipsLabel.hidden = YES;
        self.righButton.alpha = 1;
        [self.submitBtn exp_buttonState:QZHButtonStateEnable];
        self.righButton.userInteractionEnabled = YES;
    }
    self.descLabel.text = [NSString stringWithFormat:@"%zi/300", textView.text.length];
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];//按回车取消第一相应者
    }
    if (textView.text.length > 299) {
        return NO;
    }
    return YES;
}
#pragma mark - action
- (void)rightAction {
    [self.view endEditing:YES];
    if ([self.diyTextView.text length] == 0) {
        [[QZHHUD HUD] textHUDWithMessage:@"请输入输入反馈内容" afterDelay:1.0];
        return;
    }
    if ([self.diyTextView.text length] > 300) {
        [[QZHHUD HUD] textHUDWithMessage:@"最多输入300字" afterDelay:1.0];
        return;
    }
}
#pragma mark lazy
-(UIView *)backView{
    if (!_backView) {
        _backView = [[UIView alloc] init];
        _backView.backgroundColor = QZH_KIT_Color_WHITE_100;
    }
    return _backView;
}
-(UIView *)subBackView{
    if (!_subBackView) {
        _subBackView = [[UIView alloc] init];
        _subBackView.backgroundColor = QZH_KIT_Color_WHITE_100;
    }
    return _subBackView;
}
-(UITextView *)diyTextView{
    if (!_diyTextView) {
        _diyTextView = [[UITextView alloc] init];
        _diyTextView.font = QZHKIT_FONT_LISTCELL_DESCRIBE_TITLE;
        _diyTextView.textColor = QZHKIT_Color_BLACK_87;
        _diyTextView.delegate = self;
    }
    return _diyTextView;
}
-(UILabel *)descLabel{
    if (!_descLabel) {
        _descLabel = [[UILabel alloc] init];
        _descLabel.textColor = QZHKIT_Color_BLACK_54;
        _descLabel.font = QZHKIT_FONT_LISTCELL_DESCRIBE_TITLE;
        _descLabel.text = @"0/300";
    }
    return _descLabel;
}
-(UILabel *)tipsLabel{
    if (!_tipsLabel) {
        _tipsLabel = [[UILabel alloc] init];
        _tipsLabel.text = @"请详细描述您的问题或不满,例如您在做了什么时遇到了问题、希望我们有什么功能等";
        _tipsLabel.textColor = QZHKIT_Color_BLACK_26;
        _tipsLabel.font = QZHKIT_FONT_LISTCELL_DESCRIBE_TITLE;
        _tipsLabel.numberOfLines = 0;
    }
    return _tipsLabel;
}
-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"问题描述";
        _titleLabel.textColor = QZHKIT_Color_BLACK_54;
        _titleLabel.font = QZHKIT_FONT_LISTCELL_DESCRIBE_TITLE;
    }
    return _titleLabel;
}
-(UILabel *)subTitleLabel{
    if (!_subTitleLabel) {
        _subTitleLabel = [[UILabel alloc] init];
        _subTitleLabel.text = @"联系方式";
        _subTitleLabel.textColor = QZHKIT_Color_BLACK_54;
        _subTitleLabel.font = QZHKIT_FONT_LISTCELL_DESCRIBE_TITLE;
    }
    return _subTitleLabel;
}
-(UITextField *)accountText{
    if (!_accountText) {
        _accountText = [[UITextField alloc] init];
        _accountText.placeholder = @"选填,手机号或者邮箱";
        _accountText.textColor = QZHKIT_Color_BLACK_87;
        _accountText.font = QZHKIT_FONT_LISTCELL_DESCRIBE_TITLE;
        [_accountText setJk_left:10];
    }
    return _accountText;
}
-(UIButton *)submitBtn{
    if (!_submitBtn) {
        _submitBtn = [[UIButton alloc] init];
        [_submitBtn setTitle:@"提交申请" forState:UIControlStateNormal];
        [_submitBtn addTarget:self action:@selector(submitAction:) forControlEvents:UIControlEventTouchUpInside];
        [_submitBtn exp_buttonState:QZHButtonStateDisEnable];
    }
    return _submitBtn;
}

- (void)submitAction:(UIButton *)sender{
    [self addFeedback];
}
- (void)addFeedback {
    
    TuyaSmartFeedback *feedBack = [[TuyaSmartFeedback alloc] init];

    [feedBack addFeedback:self.diyTextView.text hdId:@"OTHER_HDID" hdType:7 contact:self.accountText.text success:^{
        [[QZHHUD HUD] textHUDWithMessage:QZHLoaclString(@"handleSuccess") afterDelay:0.5];
        QZHWS(weakSelf)
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.navigationController popToRootViewControllerAnimated:YES];

        });
        
    } failure:^(NSError *error) {
           [[QZHHUD HUD] textHUDWithMessage:error.userInfo[@"NSLocalizedDescription"] afterDelay:0.5];
    }];
}
@end
