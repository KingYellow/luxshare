//
//  SetWIFIVC.m
//  luxshare
//
//  Created by 黄振 on 2020/7/4.
//  Copyright © 2020 KingYellow. All rights reserved.
//

#import "SetWIFIVC.h"
#import "QRCodeVC.h"
#import "ProgressVC.h"
#import "DeviceWifiVC.h"
#import <SystemConfiguration/CaptiveNetwork.h>
#import <CoreLocation/CoreLocation.h>

@interface SetWIFIVC ()<CLLocationManagerDelegate>
@property (strong, nonatomic)UILabel *titleLab;
@property (strong, nonatomic)UILabel *subLab;
@property (strong, nonatomic)UITextField *passwordText;
@property (strong, nonatomic)UITextField *phoneText;
@property (strong, nonatomic)UIButton *openBtn;
@property (strong, nonatomic)UIButton *submitBtn;
@property (nonatomic, strong) CLLocationManager *locationMagager;

@end

@implementation SetWIFIVC

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
    [self.view addSubview:self.titleLab];
    [self.view addSubview:self.subLab];
    [self.submitBtn exp_buttonState:QZHButtonStateEnable];

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
    
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(10);
    }];
    [self.subLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(self.titleLab.mas_bottom).offset(10);
    }];
    
    [view2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.subLab.mas_bottom).offset(30);
        make.height.mas_equalTo(50);
        make.left.equalTo(@20);
        make.right.equalTo(@-20);
    }];
    [view3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(view2.mas_bottom).offset(15);
        make.height.mas_equalTo(50);
        make.left.equalTo(@20);
        make.right.equalTo(@-20);
    }];
    [self.phoneText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(5, 60, 5, 15));
    }];
    [self.passwordText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(5, 60, 5, 15));
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
        _titleLab.text = QZHLoaclString(@"wifi_setWifi");
    }
    return _titleLab;
}

-(UILabel *)subLab{
    if (!_subLab) {
        _subLab = [[UILabel alloc] init];
        _subLab.font = QZHKIT_FONT_LISTCELL_SUB_TITLE;
        _subLab.textColor = QZHKIT_Color_BLACK_87;
        _subLab.textAlignment = NSTextAlignmentCenter;
        _subLab.text = QZHLoaclString(@"wifi_setWifiTip");
    }
    return _subLab;
}

-(UIButton *)submitBtn{
    if (!_submitBtn) {
        _submitBtn = [[UIButton alloc] init];
        [_submitBtn setTitle:QZHLoaclString(@"nextstep") forState:UIControlStateNormal];
        [_submitBtn addTarget:self action:@selector(submitAction:) forControlEvents:UIControlEventTouchUpInside];
        [_submitBtn exp_buttonState:QZHButtonStateDisEnable];
    }
    return _submitBtn;
}


-(UITextField *)passwordText{
    if (!_passwordText) {
        UITextField *text= [[UITextField alloc] init];
        text.placeholder = QZHLoaclString(@"wifi_password");
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

-(UITextField *)phoneText{
    if (!_phoneText) {
        UITextField *text= [[UITextField alloc] init];
        text.placeholder = QZHLoaclString(@"wifi_name");
        text.textColor = QZHKIT_Color_BLACK_87;
        text.font = QZHTEXT_FONT(17);
        text.clearButtonMode =  UITextFieldViewModeWhileEditing;
        text.tag = 1;
        UITapGestureRecognizer *t = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectWifiAction)];
        [text addGestureRecognizer:t];
       _phoneText = text;
    }
    return _phoneText;
}

- (void)passAction:(UIButton *)sender{
    self.openBtn.selected = !self.openBtn.selected;
    self.passwordText.secureTextEntry = !self.openBtn.selected;
}

- (void)submitAction:(UIButton *)sender{
    [QZHDataHelper saveValue:self.passwordText.text forKey:self.phoneText.text];
    [self getTokenFromTY];
}
- (void)selectAction:(UIButton *)sender{
    sender.selected = !sender.selected;
    if (sender.selected) {
        [self.submitBtn exp_buttonState:QZHButtonStateEnable];
    }else{
        [self.submitBtn exp_buttonState:QZHButtonStateDisEnable];
    }
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
- (void)valueChanged:(UITextField *)sender{
    if (sender.text.length > 0) {
        [self.submitBtn exp_buttonState:QZHButtonStateEnable];
    }else{
        [self.submitBtn exp_buttonState:QZHButtonStateDisEnable];
    }
}
#pragma mark -- wifi
-(NSDictionary *)getWifiInfo{

    NSArray *ifs = (__bridge_transfer id)(CNCopySupportedInterfaces());

    //NSLog(@"interface %@", ifs);

    NSDictionary *info = nil;

    for (NSString *ifname in ifs) {

        info = (__bridge_transfer NSDictionary *)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifname);

    }
    self.phoneText.text = info[@"SSID"];
    if (self.phoneText.text) {
        self.passwordText.text = [QZHDataHelper readValueForKey:self.phoneText.text];
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
            
            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"您未开启定位权限,无法获取Wifi信息" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
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
- (void)getTokenFromTY{
    MBProgressHUD  *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    hud.labelText = @"请求中";
    [hud show:YES];
    [[TuyaSmartActivator sharedInstance] getTokenWithHomeId:self.homemodel.homeId success:^(NSString *token) {
        NSLog(@"getToken success: %@", token);
        [hud hide:YES];
        NSDictionary *dictionary = @{
        @"s": self.phoneText.text,
        @"p": self.passwordText.text,
        @"t": token
        };
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:nil];
       NSString *wifiJsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        if (self.isQRCode) {
            QRCodeVC *Vc = [[QRCodeVC alloc] init];
            Vc.codeStr = wifiJsonStr;
            Vc.wifi = self.phoneText.text;
            Vc.pw = self.passwordText.text;
            Vc.token = token;
            [self.navigationController pushViewController:[Vc exp_hiddenTabBar] animated:YES];
        }else{
            DeviceWifiVC *Vc = [[DeviceWifiVC alloc] init];
            Vc.wifi = self.phoneText.text;
            Vc.pw = self.passwordText.text;
            Vc.token = token;
            [self.navigationController pushViewController:[Vc exp_hiddenTabBar] animated:YES];
        }
        

        // TODO: startConfigWiFi
    } failure:^(NSError *error) {
        [[QZHHUD HUD] textHUDWithMessage:error.userInfo[@"NSLocalizedDescription"] afterDelay:0.5];
        [hud hide:YES];
    }];
  
}
- (void)applicationWillEnterForeground{
    [self upDateWifiInfo];
}

@end
