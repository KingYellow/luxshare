//
//  AddDeviceWifiVC.m
//  luxshare
//
//  Created by 黄振 on 2020/7/9.
//  Copyright © 2020 KingYellow. All rights reserved.
//

#import "AddDeviceWifiVC.h"
#import "SetWIFIVC.h"
#import "TOTAWebVC.h"
#import "UIImageView+Gif.h"

@interface AddDeviceWifiVC ()
@property (strong, nonatomic)UIImageView *indicatorIMG;
@property (strong, nonatomic)UILabel *titleLab;
@property (strong, nonatomic)UIButton *selectBtn;
@property (strong, nonatomic)UIButton *submitBtn;

@end

@implementation AddDeviceWifiVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initConfig];
    [self.indicatorIMG startPlayGifWithImages:@[@"ty_adddevice_lighting",@"ty_adddevice_light"]];
    
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
        make.top.mas_equalTo(60);
        make.width.height.mas_equalTo(220);
    }];
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(30);
    }];

  
    [self.submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);

        make.height.mas_equalTo(50); make.bottom.mas_equalTo(self.selectBtn.mas_top).offset(-20);
    }];
    
    [self.selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);

        make.height.mas_equalTo(50); make.bottom.mas_equalTo(self.view).offset(-QZHHeightBottom -30);
    }];

    QZHViewRadius( self.indicatorIMG,110);
    QZHViewRadius(self.submitBtn,25);
    QZHViewRadius(self.selectBtn,25);

    
}
- (UIImageView *)indicatorIMG{
    if (!_indicatorIMG) {
        _indicatorIMG = [[UIImageView alloc] init];
    }
    return _indicatorIMG;
}
-(UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.font = QZHKIT_FONT_LISTCELL_DESCRIBE_TITLE;
        _titleLab.textColor = UIColor.orangeColor;
        _titleLab.textAlignment = NSTextAlignmentCenter;
        _titleLab.backgroundColor = UIColor.yellowColor;
        _titleLab.text = QZHLoaclString(@"device_lightTip");

    }
    return _titleLab;
}


-(UIButton *)selectBtn{
    if (!_selectBtn) {
        _selectBtn = [[UIButton alloc] init];
        [_selectBtn setTitle:QZHLoaclString(@"device_lightUnnormal") forState:UIControlStateNormal];
        [_selectBtn addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];
        [_selectBtn exp_buttonState:QZHButtonStateEnable];

    }
    return _selectBtn;
}

-(UIButton *)submitBtn{
    if (!_submitBtn) {
        _submitBtn = [[UIButton alloc] init];
        [_submitBtn setTitle:QZHLoaclString(@"device_lightNormal") forState:UIControlStateNormal];
        [_submitBtn addTarget:self action:@selector(submitAction:) forControlEvents:UIControlEventTouchUpInside];
        [_submitBtn exp_buttonState:QZHButtonStateEnable];
    }
    return _submitBtn;
}
- (void)selectAction:(UIButton *)sender{
    TOTAWebVC *vc = [[TOTAWebVC alloc] init];
    vc.urlString = @"https://smartapp.tuya.com/tuyasmart/help";
    [self.navigationController pushViewController:[vc exp_hiddenTabBar] animated:YES];

}
- (void)submitAction:(UIButton *)sender{
    SetWIFIVC *vc = [[SetWIFIVC alloc] init];
    vc.homemodel = self.homemodel;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
