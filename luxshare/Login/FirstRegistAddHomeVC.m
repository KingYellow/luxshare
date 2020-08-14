//
//  FirstRegistAddHomeVC.m
//  luxshare
//
//  Created by 黄振 on 2020/8/7.
//  Copyright © 2020 KingYellow. All rights reserved.
//

#import "FirstRegistAddHomeVC.h"
#import "AddHomeVC.h"

@interface FirstRegistAddHomeVC ()
@property (strong, nonatomic)UIButton *submitBtn;
@property (strong, nonatomic)UIButton *logoutBtn;
@property (strong, nonatomic)UIImageView *logoIMG;
@end

@implementation FirstRegistAddHomeVC
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self exp_navigationBarTrans];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = QZHKIT_COLOR_LEADBACK;
    [self setUIConfigus];
    
}
- (void)setUIConfigus{
    
    [self.view addSubview:self.logoIMG];
    [self.view addSubview:self.submitBtn];
    [self.view addSubview:self.logoutBtn];
    [self.logoIMG mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(50);
        make.width.height.mas_equalTo(100);
    }];
    [self.submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(self.logoIMG.mas_bottom).offset(50);
        make.width.mas_equalTo(300);
        make.height.mas_equalTo(50);

    }];
    [self.logoutBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(self.submitBtn.mas_bottom).offset(30);
        make.width.mas_equalTo(300);
        make.height.mas_equalTo(50);

    }];
    
}
-(UIImageView *)logoIMG{
    if (!_logoIMG) {
        _logoIMG = [[UIImageView alloc] init];
        _logoIMG.image = QZHLoadIcon(@"icon-83.5");
    }
    return _logoIMG;
}
-(UIButton *)submitBtn{
    if (!_submitBtn) {
        _submitBtn = [[UIButton alloc] init];
        [_submitBtn setTitle:QZHLoaclString(@"home_addHome") forState:UIControlStateNormal];
        [_submitBtn setTitleColor:QZHColorWhite forState:UIControlStateNormal];
        _submitBtn.titleLabel.font = QZHTEXT_FONT(18);
        [self.submitBtn exp_buttonState:QZHButtonStateEnable];
        QZHViewRadius(_submitBtn, 25);
        [_submitBtn addTarget:self action:@selector(submitAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _submitBtn;
}
-(UIButton *)logoutBtn{
    if (!_logoutBtn) {
        _logoutBtn = [[UIButton alloc] init];
        [_logoutBtn setTitle:QZHLoaclString(@"logout") forState:UIControlStateNormal];
        [_logoutBtn setTitleColor:QZHColorWhite forState:UIControlStateNormal];
        _logoutBtn.titleLabel.font = QZHTEXT_FONT(18);
        QZHViewRadius(_logoutBtn, 25);
        [self.logoutBtn exp_buttonState:QZHButtonStateEnable];

        [_logoutBtn addTarget:self action:@selector(logoutAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _logoutBtn;
}
- (void)submitAction{
    AddHomeVC *vc = [[AddHomeVC alloc] init];
    vc.isFirst = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)logoutAction{
    [QZHDataHelper removeForKey:QZHKEY_TOKEN];
    [QZHROOT_DELEGATE setVC];
    
}
@end
