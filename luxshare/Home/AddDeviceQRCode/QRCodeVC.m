//
//  QRCodeVC.m
//  luxshare
//
//  Created by 黄振 on 2020/7/6.
//  Copyright © 2020 KingYellow. All rights reserved.
//

#import "QRCodeVC.h"
#import "SGQRCode.h"
#import "ProgressVC.h"

@interface QRCodeVC ()<TuyaSmartActivatorDelegate>
@property (strong, nonatomic)UILabel *titleLab;
@property (strong, nonatomic)UILabel *subLab;
@property (strong, nonatomic)UIImageView *indicatorIMG;
@property (strong, nonatomic)TuyaSmartActivator *activator;
@property (strong, nonatomic)UIButton *submitBtn;

@end

@implementation QRCodeVC


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

}
- (void)UIConfig{
    [self.view addSubview:self.submitBtn];
    [self.view addSubview:self.titleLab];
    [self.view addSubview:self.subLab];
    [self.view addSubview:self.indicatorIMG];
    self.indicatorIMG.image = [SGQRCodeObtain generateQRCodeWithData:self.codeStr size:QZHScreenWidth - 60];
    
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(20);
    }];
    [self.subLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30);
        make.right.mas_equalTo(-30);
        make.top.mas_equalTo(self.titleLab.mas_bottom).offset(10);
    }];
    
    [self.indicatorIMG mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(self.subLab.mas_bottom).offset(20);
        make.width.height.mas_equalTo(QZHScreenWidth - 60);
    }];

  
    [self.submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);

        make.height.mas_equalTo(50); make.bottom.mas_equalTo(self.view).offset(-QZHHeightBottom -30);
    }];
    QZHViewRadius(self.submitBtn,25);
    
}

-(UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.font = QZHKIT_FONT_LISTCELL_BIG_TITLE;
        _titleLab.textColor = QZHKIT_Color_BLACK_87;
        _titleLab.textAlignment = NSTextAlignmentCenter;
        _titleLab.text = QZHLoaclString(@"qrcode_title");

    }
    return _titleLab;
}

-(UILabel *)subLab{
    if (!_subLab) {
        _subLab = [[UILabel alloc] init];
        _subLab.font = QZHKIT_FONT_LISTCELL_SUB_TITLE;
        _subLab.textColor = QZHKIT_Color_BLACK_87;
        _subLab.textAlignment = NSTextAlignmentCenter;
        _subLab.numberOfLines = 0;
        _subLab.text = QZHLoaclString(@"qrcode_subtitle");
    }
    return _subLab;
}

-(UIButton *)submitBtn{
    if (!_submitBtn) {
        _submitBtn = [[UIButton alloc] init];
        [_submitBtn setTitle:QZHLoaclString(@"qrcode_submit") forState:UIControlStateNormal];
        [_submitBtn addTarget:self action:@selector(submitAction:) forControlEvents:UIControlEventTouchUpInside];
        [_submitBtn exp_buttonState:QZHButtonStateEnable];
    }
    return _submitBtn;
}
- (UIImageView *)indicatorIMG{
    if (!_indicatorIMG) {
        _indicatorIMG = [[UIImageView alloc] init];
        _indicatorIMG.backgroundColor = QZHColorRed;
    }
    return _indicatorIMG;
}
-(TuyaSmartActivator *)activator{
    if (!_activator) {
        _activator = [TuyaSmartActivator sharedInstance];
        _activator.delegate = self;
    }
    return _activator;
}
#pragma mark -- wifi

- (void)submitAction:(UIButton *)sender{
//    [[TuyaSmartActivator sharedInstance] startConfigWiFi:TYActivatorModeQRCode ssid:self.ssid password:self.pwd token:self.token timeout:100];
//    [self.activator startConfigWiFi:TYActivatorModeQRCode ssid:self.wifi password:self.pw token:self.token timeout:100];

    ProgressVC *vc = [[ProgressVC alloc] init];
    vc.wifi = self.wifi;
    vc.pw = self.pw;
    vc.token = self.token;
    [self.navigationController pushViewController:vc animated:YES];
}




@end
