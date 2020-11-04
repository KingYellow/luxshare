//
//  ProgressVC.m
//  luxshare
//
//  Created by 黄振 on 2020/7/6.
//  Copyright © 2020 KingYellow. All rights reserved.
//

#import "ProgressVC.h"
#import "CircleView.h"
#import "NETResultVC.h"

@interface ProgressVC ()<TuyaSmartActivatorDelegate>
@property (strong, nonatomic)UILabel *titleLab;
@property (strong, nonatomic)UILabel *subLab;
@property (strong, nonatomic)UIImageView *indicatorIMG;
@property (strong, nonatomic)CircleView *circleV;
@property (strong, nonatomic)UIButton *submitBtn;
@property (strong, nonatomic)UIButton *stepOneBtn;
@property (strong, nonatomic)UIButton *stepsecondBtn;
@property (strong, nonatomic)UIButton *stepthirdBtn;
@property (strong, nonatomic)TuyaSmartActivator *activator;

@end

@implementation ProgressVC


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initConfig];
    [self circleShow];
    [self startConfigWiFi:self.wifi password:self.pw token:self.token];

    
}
- (void)initConfig{
    self.view.backgroundColor = QZHKIT_COLOR_LEADBACK;
    self.navigationItem.title = QZHLoaclString(@"device_addNewDevice");
    [self exp_navigationBarTextWithColor:QZHKIT_COLOR_NAVIBAR_TITLE font:QZHKIT_FONT_TABBAR_TITLE];
    [self exp_navigationBarColor:QZHKIT_COLOR_NAVIBAR_BACK hiddenShadow:NO];
    [self UIConfig];
    QZHWS(weakSelf)
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf.circleV circleWithProgress:99 andIsAnimate:YES];

    });

}

- (void)UIConfig{
    [self.view addSubview:self.titleLab];
    [self.view addSubview:self.subLab];
    [self.view addSubview:self.circleV];
    [self.view addSubview:self.stepthirdBtn];
    [self.view addSubview:self.stepsecondBtn];
    [self.view addSubview:self.stepOneBtn];
    
    [self.stepthirdBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(120 * QZHScaleWidth);
        make.bottom.mas_equalTo(-QZHHeightBottom - 50);
        make.height.mas_equalTo(40);
        make.right.mas_equalTo(-20);
    }];
    [self.stepsecondBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(120 * QZHScaleWidth);
        make.bottom.mas_equalTo(self.stepthirdBtn.mas_top ).offset(-10);
        make.height.mas_equalTo(40);
        make.right.mas_equalTo(-20);
    }];
    [self.stepOneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(120 * QZHScaleWidth);
        make.bottom.mas_equalTo(self.stepsecondBtn.mas_top ).offset(-10);
        make.height.mas_equalTo(40);
        make.right.mas_equalTo(-20);
    }];
    

    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(20);
    }];
    [self.subLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30);
        make.right.mas_equalTo(-30);
        make.top.mas_equalTo(self.titleLab.mas_bottom).offset(10);
    }];
    
    [self.circleV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(self.subLab.mas_bottom).offset(20);
        make.width.height.mas_equalTo(300);
    }];
    
}

- (UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.font = QZHKIT_FONT_LISTCELL_BIG_TITLE;
        _titleLab.textColor = QZHKIT_Color_BLACK_87;
        _titleLab.textAlignment = NSTextAlignmentCenter;
        _titleLab.text = QZHLoaclString(@"device_connecting");

    }
    return _titleLab;
}

- (UILabel *)subLab{
    if (!_subLab) {
        _subLab = [[UILabel alloc] init];
        _subLab.font = QZHKIT_FONT_LISTCELL_SUB_TITLE;
        _subLab.textColor = QZHKIT_Color_BLACK_87;
        _subLab.textAlignment = NSTextAlignmentCenter;
        _subLab.numberOfLines = 0;
        _subLab.text = QZHLoaclString(@"device_connectTip");
    }
    return _subLab;
}

- (UIButton *)submitBtn{
    if (!_submitBtn) {
        _submitBtn = [[UIButton alloc] init];
        [_submitBtn setTitle:QZHLoaclString(@"qrcode_submit") forState:UIControlStateNormal];
        [_submitBtn exp_buttonState:QZHButtonStateEnable];
    }
    return _submitBtn;
}
- (UIImageView *)indicatorIMG{
    if (!_indicatorIMG) {
        _indicatorIMG = [[UIImageView alloc] init];
    }
    return _indicatorIMG;
}
- (UIButton *)stepOneBtn{
    if (!_stepOneBtn) {
        _stepOneBtn = [[UIButton alloc] init];
        [_stepOneBtn setTitle:QZHLoaclString(@"findDevice") forState:UIControlStateNormal];
        [_stepOneBtn setImage:QZHLoadIcon(@"") forState:UIControlStateNormal];
        [_stepOneBtn setImage:QZHLoadIcon(@"") forState:UIControlStateSelected];
        [_stepOneBtn setTitleColor:QZHKIT_Color_BLACK_54 forState:UIControlStateNormal];
        _stepOneBtn.titleLabel.font = QZHKIT_FONT_LISTCELL_DESCRIBE_TITLE;
        _stepOneBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    }
    return _stepOneBtn;
}
- (UIButton *)stepsecondBtn{
    if (!_stepsecondBtn) {
        _stepsecondBtn = [[UIButton alloc] init];
        [_stepsecondBtn setTitle:QZHLoaclString(@"deviceRegistClode") forState:UIControlStateNormal];
        [_stepsecondBtn setImage:QZHLoadIcon(@"") forState:UIControlStateNormal];
        [_stepsecondBtn setImage:QZHLoadIcon(@"") forState:UIControlStateSelected];
        [_stepsecondBtn setTitleColor:QZHKIT_Color_BLACK_54 forState:UIControlStateNormal];
        _stepsecondBtn.titleLabel.font = QZHKIT_FONT_LISTCELL_DESCRIBE_TITLE;
        _stepsecondBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;

    }
    return _stepsecondBtn;
}
- (UIButton *)stepthirdBtn{
    if (!_stepthirdBtn) {
        _stepthirdBtn = [[UIButton alloc] init];
        [_stepthirdBtn setTitle:QZHLoaclString(@"deviceFormat") forState:UIControlStateNormal];
        [_stepthirdBtn setImage:QZHLoadIcon(@"") forState:UIControlStateNormal];
        [_stepthirdBtn setImage:QZHLoadIcon(@"") forState:UIControlStateSelected];
        [_stepthirdBtn setTitleColor:QZHKIT_Color_BLACK_54 forState:UIControlStateNormal];
        _stepthirdBtn.titleLabel.font = QZHKIT_FONT_LISTCELL_DESCRIBE_TITLE;
        _stepthirdBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;

    }
    return _stepthirdBtn;
}

- (TuyaSmartActivator *)activator{
    if (!_activator) {
        _activator = [TuyaSmartActivator sharedInstance];
        _activator.delegate = self;
    }
    return _activator;
}
#pragma mark -- wifi
- (void)circleShow{
    if (_circleV) {
        [_circleV removeFromSuperview];
    }
    
    _circleV = [[CircleView alloc] init];
    [self.view addSubview:_circleV];

    [_circleV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(self.subLab.mas_bottom).offset(20);
        make.width.height.mas_equalTo(180 *QZHScaleWidth);
    }];
    //进度条宽度
    _circleV.strokelineWidth = 10;

}

- (void)activator:(TuyaSmartActivator *)activator didReceiveDevice:(TuyaSmartDeviceModel *)deviceModel error:(NSError *)error
{
    if (error) {
        [[QZHHUD HUD] textHUDWithMessage:error.userInfo[@"NSLocalizedDescription"] afterDelay:0.5];
        NETResultVC *vc = [[NETResultVC alloc] init];
        if([error.userInfo[@"NSLocalizedFailureReason"] isEqualToString:@"DEVICE_ALREADY_BIND"]){
            vc.isBind = YES;
            vc.deviceModel = deviceModel;
        }
        vc.isSuccess = NO;
        [self.navigationController pushViewController:vc animated:YES];

    }else{
        NETResultVC *vc = [[NETResultVC alloc] init];
        vc.isSuccess = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)startConfigWiFi:(NSString *)ssid password:(NSString *)password token:(NSString *)token {
    // 设置 TuyaSmartActivator 的 delegate，并实现 delegate 方法

    // 开始配网，二维码模式对应 mode 为 TYActivatorModeQRCode
    
    [self.activator startConfigWiFi:self.actModel ssid:ssid password:password token:token timeout:60];
}

@end
