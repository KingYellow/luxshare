//
//  UpdateDeviceVC.m
//  luxshare
//
//  Created by 黄振 on 2020/7/22.
//  Copyright © 2020 KingYellow. All rights reserved.
//

#import "UpdateDeviceVC.h"

@interface UpdateDeviceVC ()<TuyaSmartDeviceDelegate>
@property (strong, nonatomic)UIView *bigView;
@property (strong, nonatomic)UILabel *titleLab;
@property (strong, nonatomic)UILabel *sizeLab;
@property (strong, nonatomic)UIButton *updateBtn;
@property (strong, nonatomic)UILabel *progressLab;
@property (strong, nonatomic)UIProgressView *progress;
@property (strong, nonatomic)UIView *line;
@property (strong, nonatomic)UILabel *tipLab;
@property (strong, nonatomic)UILabel *contentLab;
@property (strong, nonatomic)TuyaSmartDevice *device;
@end

@implementation UpdateDeviceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initConfig];

}
- (void)initConfig{
    self.view.backgroundColor = QZHKIT_COLOR_LEADBACK;
    self.navigationItem.title = QZHLoaclString(@"device_deviceInfo");
    [self exp_navigationBarTextWithColor:QZHKIT_COLOR_NAVIBAR_TITLE font:QZHKIT_FONT_TABBAR_TITLE];
    [self exp_navigationBarColor:QZHKIT_COLOR_NAVIBAR_BACK hiddenShadow:NO];
    [self UIConfig];
    self.titleLab.text = [NSString stringWithFormat:@"发现可更新版本%@",self.upModel.version];
    float size = [self.upModel.fileSize integerValue]/1024.0;
    if (size > 102.4) {
        size = size/1024.0;
        self.sizeLab.text = [NSString stringWithFormat:@"%.2f M",size];

    }else{
        self.sizeLab.text = [NSString stringWithFormat:@"%.2f K",size];
    }
    self.contentLab.text = self.upModel.desc;
    self.updateBtn.hidden = NO;

}
- (void)UIConfig{
    [self.view addSubview:self.bigView];
    [self.bigView addSubview:self.titleLab];
    [self.bigView addSubview:self.sizeLab];
    [self.bigView addSubview:self.updateBtn];
    [self.bigView addSubview:self.progressLab];
    [self.bigView addSubview:self.progress];
    [self.bigView addSubview:self.tipLab];
    [self.bigView addSubview:self.contentLab];

    [self.bigView addSubview:self.line];
    
    [self.bigView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(15);
        make.right.mas_equalTo(-15);
    }];
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.bigView.mas_top).offset(15);
        make.left.mas_equalTo(18);
        make.height.mas_equalTo(15);
    }];
    [self.sizeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(self.titleLab.mas_bottom).offset(10);
        make.height.mas_equalTo(18);
    }];
    
    [self.progressLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(18);
        make.top.mas_equalTo(self.sizeLab.mas_bottom).offset(10);
        make.height.mas_equalTo(0);
    }];
    [self.progress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(self.progressLab.mas_bottom).offset(10);
        make.height.mas_equalTo(0);
    }];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(self.progress.mas_bottom).offset(10);
        make.height.mas_equalTo(1);
    }];
    [self.tipLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(self.line.mas_bottom).offset(10);
        make.height.mas_equalTo(15);
    }];
    [self.contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(self.tipLab.mas_bottom).offset(10);
        make.height.mas_equalTo(15);
        make.bottom.mas_equalTo(self.bigView.mas_bottom).offset(-15);
    }];
    [self.updateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(15);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(60);
    }];

}
-(UIView *)bigView{
    if (!_bigView) {
        _bigView = [[UIView alloc] init];
        _bigView.backgroundColor = QZH_KIT_Color_WHITE_70;
        QZHViewRadius(_bigView, 5);
    }
    return _bigView;
}
-(UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.textColor = QZHKIT_Color_BLACK_87;
        _titleLab.font = QZHKIT_FONT_LISTCELL_SUB_TITLE;
        _titleLab.text = @"发现可更新版本--";
    }
    return _titleLab;
}
-(UILabel *)sizeLab{
    if (!_sizeLab) {
        _sizeLab = [[UILabel alloc] init];
        _sizeLab.textColor = QZHKIT_Color_BLACK_87;
        _sizeLab.font = QZHKIT_FONT_LISTCELL_SUB_TITLE;
        _sizeLab.text = @"0.00M";

    }
    return _sizeLab;
}
-(UILabel *)progressLab{
    if (!_progressLab) {
        _progressLab = [[UILabel alloc] init];
        _progressLab.textColor = QZHKIT_Color_BLACK_87;
        _progressLab.font = QZHKIT_FONT_LISTCELL_SUB_TITLE;
        _progressLab.text = @"固件升级";

    }
    return _progressLab;
}

-(UILabel *)tipLab{
    if (!_tipLab) {
        _tipLab = [[UILabel alloc] init];
        _tipLab.textColor = QZHKIT_Color_BLACK_54;
        _tipLab.font = QZHKIT_FONT_LISTCELL_DESCRIBE_TITLE;
        _tipLab.text = @"更新新版本";

    }
    return _tipLab;
}

-(UILabel *)contentLab{
    if (!_contentLab) {
        _contentLab = [[UILabel alloc] init];
        _contentLab.textColor = QZHKIT_Color_BLACK_54;
        _contentLab.font = QZHKIT_FONT_LISTCELL_DESCRIBE_TITLE;
        _contentLab.text = @"...";
    }
    return _contentLab;
}
-(UIProgressView *)progress{
    if (!_progress) {
        _progress = [[UIProgressView alloc] init];
        _progress.progress = 0;
        _progress.progressTintColor = QZHKIT_COLOR_SKIN;
        _progress.trackTintColor = QZHKIT_Color_BLACK_26;
        QZHViewRadius(_progress, 3);
    }
    return _progress;
}
-(UIButton *)updateBtn{
    if (!_updateBtn) {
        _updateBtn = [[UIButton alloc] init];
        [_updateBtn setTitle:@"更新" forState:UIControlStateNormal];
        [_updateBtn setTitleColor:QZHKIT_COLOR_SKIN forState:UIControlStateNormal];
        _updateBtn.titleLabel.font = QZHKIT_FONT_LISTCELL_DESCRIBE_TITLE;
        [_updateBtn addTarget:self action:@selector(updateAction:) forControlEvents:UIControlEventTouchUpInside];
        _updateBtn.backgroundColor = QZHKIT_Color_BLACK_26;
        QZHViewRadius(_updateBtn, 15)
    }
    return _updateBtn;
}
-(UIView *)line{
    if (!_line) {
        _line = [[UIView alloc] init];
        _line.backgroundColor = QZHKIT_Color_BLACK_12;
    }
    return _line;
}
- (void)updateAction:(UIButton *)sender{
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"更新注意事项" message:@"升级可能持续较长时间,请确保设备处于电量充足状态.更新时设备不可使用" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelaction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.titleLab.text = [NSString stringWithFormat:@"%@%@",@"正在更新至",self.upModel.version];
        [self.sizeLab mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];
        [self.progressLab mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(15);
            make.top.mas_equalTo(self.sizeLab.mas_bottom).offset(20);

        }];
        [self.progress mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(6);

        }];
        [self.line mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.progress.mas_bottom).offset(20);

        }];
        self.updateBtn.hidden = YES;
        [self upgradeFirmware];
        
    }];
    [alertC addAction:cancelaction];
    [alertC addAction:action];
    [self presentViewController:alertC animated:NO completion:nil];
}

- (void)upgradeFirmware {
     
    self.device = [TuyaSmartDevice deviceWithDeviceId:self.deviceModel.devId];
    self.device.delegate = self;
    // type: 从获取设备升级信息接口 getFirmwareUpgradeInfo 返回的固件类型
    // TuyaSmartFirmwareUpgradeModel - type
    [self.device upgradeFirmware:self.upModel.type success:^{
        NSLog(@"success");

    } failure:^(NSError *error) {
           [[QZHHUD HUD] textHUDWithMessage:error.userInfo[@"NSLocalizedDescription"] afterDelay:0.5];
    }];
}


- (void)device:(TuyaSmartDevice *)device firmwareUpgradeProgress:(NSInteger)type progress:(double)progress {
    //固件升级的进度
    [self.progress setProgress:progress/100.0];

}
- (void)device:(TuyaSmartDevice *)device firmwareUpgradeStatusModel:(TuyaSmartFirmwareUpgradeStatusModel *)upgradeStatusModel{
    if (upgradeStatusModel.upgradeStatus == TuyaSmartDeviceUpgradeStatusSuccess) {
        QZHWS(weakSelf)
        [[QZHHUD HUD] textHUDWithMessage:@"更新成功" afterDelay:0.5];
        self.refresh();
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.navigationController popViewControllerAnimated:YES];
            
        });
    }
    if (upgradeStatusModel.upgradeStatus == TuyaSmartDeviceUpgradeStatusTimeout || upgradeStatusModel.upgradeStatus == TuyaSmartDeviceUpgradeStatusFailure) {
        [self viewDidLoad];
    }
    
}


@end
