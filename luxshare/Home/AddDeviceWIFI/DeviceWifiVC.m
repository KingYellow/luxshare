//
//  DeviceWifiVC.m
//  luxshare
//
//  Created by 黄振 on 2020/7/10.
//  Copyright © 2020 KingYellow. All rights reserved.
//

#import "DeviceWifiVC.h"
#import "ProgressVC.h"
#import "TOTAWebVC.h"
#import <SystemConfiguration/CaptiveNetwork.h>
#import <CoreLocation/CoreLocation.h>

@interface DeviceWifiVC ()<CLLocationManagerDelegate>
@property (strong, nonatomic)UIImageView *indicatorIMG;
@property (strong, nonatomic)UILabel *titleLab;
@property (strong, nonatomic)UIButton *selectBtn;
@property (strong, nonatomic)UIButton *submitBtn;
@property (nonatomic, strong) CLLocationManager *locationMagager;

@end

@implementation DeviceWifiVC
- (CLLocationManager *)locationMagager {
    if (!_locationMagager) {
        _locationMagager = [[CLLocationManager alloc] init];
        _locationMagager.delegate = self;
    }
    return _locationMagager;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    UIApplication *app = [UIApplication sharedApplication];
    [[NSNotificationCenter defaultCenter] addObserver:self
    selector:@selector(applicationWillEnterForeground)
    name:UIApplicationWillEnterForegroundNotification
    object:app];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initConfig];
    [self upDateWifiInfo];

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
        _indicatorIMG.image = QZHLoadIcon(@"WifiSmart");
    }
    return _indicatorIMG;
}
- (UILabel *)titleLab{
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

- (UIButton *)selectBtn{
    if (!_selectBtn) {
        _selectBtn = [[UIButton alloc] init];
        [_selectBtn setTitle:QZHLoaclString(@"device_connectHelp") forState:UIControlStateNormal];
        [_selectBtn setTitleColor:UIColor.orangeColor forState:UIControlStateNormal];
        _selectBtn.titleLabel.font = QZHKIT_FONT_LISTCELL_SUB_TITLE;
        [_selectBtn addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectBtn;
}


- (UIButton *)submitBtn{
    if (!_submitBtn) {
        _submitBtn = [[UIButton alloc] init];
        [_submitBtn setTitle:QZHLoaclString(@"device_goToConnect") forState:UIControlStateNormal];
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
    
    [self selectWifiAction];
}
- (void)selectWifiAction{
    
   // App-Prefs:root
//    设置页面
//    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] ];
    
    NSURL *url = [NSURL URLWithString:@"App-Prefs:root=WIFI"];

     if ([[UIApplication sharedApplication] canOpenURL:url]) {
         
         if (@available(iOS 10.0, *)) {
             
             [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
         } else {
             [[UIApplication sharedApplication] openURL:url]; // iOS 9 的跳转

             // Fallback on earlier versions
         }


         
     }
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"App-Prefs:root"] ];

}

#pragma mark -- wifi
- (NSDictionary *)getWifiInfo{

    NSArray *ifs = (__bridge_transfer id)(CNCopySupportedInterfaces());

    //NSLog(@"interface %@", ifs);

    NSDictionary *info = nil;

    for (NSString *ifname in ifs) {

        info = (__bridge_transfer NSDictionary *)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifname);

    }
    
    if ([info[@"SSID"] containsString:@"SmartLife"]) {
        ProgressVC *Vc = [[ProgressVC alloc] init];
        Vc.wifi = self.wifi;
        Vc.pw = self.pw;
        Vc.token = self.token;
        Vc.actModel = TYActivatorModeAP;
        [self.navigationController pushViewController:[Vc exp_hiddenTabBar] animated:YES];
    }
    return info;

}
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        [self getWifiInfo];
    }
}
- (void)enterWiFISelectVC{
    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];

    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];

    }
}

- (void)upDateWifiInfo{
    if (@available(iOS 13, *)) {
        
        if (CLLocationManager.authorizationStatus == kCLAuthorizationStatusAuthorizedWhenInUse) {//开启了权限，直接搜索
            
            [self getWifiInfo];
            
        } else if (CLLocationManager.authorizationStatus == kCLAuthorizationStatusDenied) {//如果用户没给权限，则提示
            
            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:QZHLoaclString(@"tip") message:QZHLoaclString(@"noLocalPrivateNoWifiInfo") preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:QZHLoaclString(@"submit") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alertC addAction:action];
            [self presentViewController:alertC animated:NO completion:nil];
            
        } else {//请求权限
            
            [self.locationMagager requestWhenInUseAuthorization];
        }
        
    } else {
        
        [self getWifiInfo];
    }
}
- (void)applicationWillEnterForeground{
    [self upDateWifiInfo];
}
@end
