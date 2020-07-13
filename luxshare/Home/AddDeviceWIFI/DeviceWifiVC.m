//
//  DeviceWifiVC.m
//  luxshare
//
//  Created by 黄振 on 2020/7/10.
//  Copyright © 2020 KingYellow. All rights reserved.
//

#import "DeviceWifiVC.h"
#import "ProgressVC.h"

@interface DeviceWifiVC ()
@property (strong, nonatomic)UIImageView *indicatorIMG;
@property (strong, nonatomic)UILabel *titleLab;
@property (strong, nonatomic)UIButton *selectBtn;
@property (strong, nonatomic)UIButton *submitBtn;
@end

@implementation DeviceWifiVC

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
    [self.view addSubview:self.selectBtn];
    [self.view addSubview:self.indicatorIMG];
    [self.view addSubview:self.titleLab];
    
    [self.indicatorIMG mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(20);
        make.width.height.mas_equalTo(QZHScreenWidth - 60);
    }];
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(40);
        make.right.mas_equalTo(-40);
        make.top.mas_equalTo(self.indicatorIMG.mas_bottom).offset(10);
    }];

  
    [self.submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);

        make.height.mas_equalTo(50); make.bottom.mas_equalTo(self.view).offset(-QZHHeightBottom -30);
    }];
    
    [self.selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(self.titleLab.mas_bottom).offset(30);
        make.width.mas_equalTo(180);
        make.height.mas_equalTo(40);
    }];

    QZHViewRadius(self.submitBtn,25);
    
}
- (UIImageView *)indicatorIMG{
    if (!_indicatorIMG) {
        _indicatorIMG = [[UIImageView alloc] init];
        _indicatorIMG.backgroundColor = QZHColorRed;
    }
    return _indicatorIMG;
}
-(UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.font = QZHKIT_FONT_LISTCELL_SUB_TITLE;
        _titleLab.textColor = QZHKIT_Color_BLACK_87;
        _titleLab.numberOfLines = 0;
        _titleLab.textAlignment = NSTextAlignmentCenter;
        _titleLab.text = QZHLoaclString(@"device_deviceWifiTip");

    }
    return _titleLab;
}

-(UIButton *)selectBtn{
    if (!_selectBtn) {
        _selectBtn = [[UIButton alloc] init];
        [_selectBtn setTitle:QZHLoaclString(@"device_connectHelp") forState:UIControlStateNormal];
        [_selectBtn setTitleColor:UIColor.orangeColor forState:UIControlStateNormal];
        _selectBtn.titleLabel.font = QZHKIT_FONT_LISTCELL_SUB_TITLE;
        [_selectBtn addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectBtn;
}


-(UIButton *)submitBtn{
    if (!_submitBtn) {
        _submitBtn = [[UIButton alloc] init];
        [_submitBtn setTitle:QZHLoaclString(@"device_goToConnect") forState:UIControlStateNormal];
        [_submitBtn addTarget:self action:@selector(submitAction:) forControlEvents:UIControlEventTouchUpInside];
        [_submitBtn exp_buttonState:QZHButtonStateEnable];
    }
    return _submitBtn;
}
- (void)selectAction:(UIButton *)sender{

}
- (void)submitAction:(UIButton *)sender{
    ProgressVC *Vc = [[ProgressVC alloc] init];
    Vc.wifi = self.wifi;
    Vc.pw = self.pw;
    Vc.token = self.token;
    [self.navigationController pushViewController:[Vc exp_hiddenTabBar] animated:YES];
}

@end
