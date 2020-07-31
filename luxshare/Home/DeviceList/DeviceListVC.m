//
//  DeviceListVC.m
//  luxshare
//
//  Created by 黄振 on 2020/7/6.
//  Copyright © 2020 KingYellow. All rights reserved.
//

#import "DeviceListVC.h"
#import "DeviceListCell.h"
#import "QZHDefaultButtonCell.h"
#import "CameraOnLiveVC.h"


@interface DeviceListVC ()<UITableViewDelegate,UITableViewDataSource,TuyaSmartDeviceDelegate>

@property (strong, nonatomic)UITableView *qzTableView;
@property (strong, nonatomic)UILabel *tipLab;
@property (strong, nonatomic)UIButton *addBtn;
@end

@implementation DeviceListVC
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.listArr.count == 0) {
        self.qzTableView.hidden = YES;
        self.tipLab.hidden = !self.qzTableView.hidden;
        self.addBtn.hidden = self.tipLab.hidden;
    }else{
        self.qzTableView.hidden = NO;
        self.tipLab.hidden = !self.qzTableView.hidden;
        self.addBtn.hidden = self.tipLab.hidden;
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initConfig];
    
}
- (void)initConfig{
    self.view.backgroundColor = QZHKIT_COLOR_LEADBACK;
    self.navigationItem.title = QZHLoaclString(@"home_manage");
    [self exp_navigationBarTextWithColor:QZHKIT_COLOR_NAVIBAR_TITLE font:QZHKIT_FONT_TABBAR_TITLE];
    [self exp_navigationBarColor:QZHKIT_COLOR_NAVIBAR_BACK hiddenShadow:NO];
    [self UIConfig];

}
- (void)UIConfig{
    
    [self.view addSubview:self.tipLab];
    [self.view addSubview:self.addBtn];
    [self.view addSubview:self.qzTableView];

    [self.tipLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.addBtn.mas_top).offset(-15);
    }];
    [self.addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.centerY.mas_equalTo(self.view.mas_centerY).offset(-50);

        make.width.mas_equalTo(100);
        make.height.mas_equalTo(50);
    }];
    
    [self.qzTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];

}

#pragma mark -tableView
-(UITableView *)qzTableView{
    if (!_qzTableView) {
        _qzTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [_qzTableView exp_tableViewDefault];
        _qzTableView.bounces = NO;
        self.qzTableView.backgroundColor = QZHKIT_COLOR_LEADBACK;
        self.qzTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _qzTableView.delegate = self;
        _qzTableView.dataSource = self;
        [self.qzTableView registerClass:[DeviceListCell class] forCellReuseIdentifier:QZHCELL_REUSE_TEXT];

    }
    return _qzTableView;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = indexPath.row;
        
    DeviceListCell *cell = [tableView dequeueReusableCellWithIdentifier:QZHCELL_REUSE_TEXT];
    TuyaSmartDeviceModel *model = self.listArr[row];
    if (model.isShare) {
        cell.nameLab.text = [model.name stringByAppendingString:@"(共享设备)"];
        [cell.selectBtn setImage:QZHLoadIcon(@"ty_devicelist_share_gray") forState:UIControlStateNormal];
        [cell.selectBtn setImage:QZHLoadIcon(@"ty_devicelist_share_green") forState:UIControlStateSelected];
    }else{
        cell.nameLab.text = model.name;
        [cell.selectBtn setImage:QZHLoadIcon(@"ty_devicelist_dot_gray") forState:UIControlStateNormal];
        [cell.selectBtn setImage:QZHLoadIcon(@"ty_devicelist_dot_green") forState:UIControlStateSelected];

    }
    cell.selectBtn.selected = model.isOnline;

    if ([model.productId isEqualToString:BATTERY_PRODUCT_ID]) {
        cell.poloIMG.image = QZHLoadIcon(@"ic_ipc_battery");
    }else{
        cell.poloIMG.image = QZHLoadIcon(@"ic_ipc_ac");
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UILongPressGestureRecognizer *press = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
    [cell addGestureRecognizer:press];
        return cell;

}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.listArr.count;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.00001;
}
-(void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section{
    view.tintColor = QZHKIT_COLOR_LEADBACK;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    TuyaSmartDeviceModel *model = self.listArr[row];
    if (![model.category isEqualToString:@"sp"]) {
        return;
    };

    CameraOnLiveVC *vc = [[CameraOnLiveVC alloc] init];
    vc.deviceModel = model;
    vc.homeModel = self.homeModel;
    [self.navigationController pushViewController:[vc exp_hiddenTabBar] animated:YES];
    TuyaSmartDevice *device = [TuyaSmartDevice deviceWithDeviceId:model.devId];
    device.delegate = self;
}

- (void)longPressAction:(UITableViewCell *)cell{
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"确认要删除设备吗?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        NSIndexPath *path = [self.qzTableView indexPathForCell:cell];
        TuyaSmartDeviceModel *model = self.listArr[path.row];
             TuyaSmartDevice *device = [TuyaSmartDevice deviceWithDeviceId:model.devId];
QZHWS(weakSelf)
            [device remove:^{
                NSLog(@"remove success");
                [[QZHHUD HUD] textHUDWithMessage:QZHLoaclString(@"handleSuccess") afterDelay:0.5];
                weakSelf.updateDevice();
 
            } failure:^(NSError *error) {
                NSLog(@"remove failure: %@", error);
                   [[QZHHUD HUD] textHUDWithMessage:error.userInfo[@"NSLocalizedDescription"] afterDelay:0.5];
            }];
  
    }];
    [alertC addAction:action];
    [alertC addAction:action1];
    [self presentViewController:alertC animated:NO completion:nil];
}
#pragma mark --lazy
-(UILabel *)tipLab{
    if (!_tipLab) {
        _tipLab = [[UILabel alloc] init];
        _tipLab.text = @"暂无数据";
        _tipLab.textColor = QZHKIT_Color_BLACK_54;
    }
    return _tipLab;
}
-(UIButton *)addBtn{
    if (!_addBtn) {
        _addBtn = [[UIButton alloc] init];
        _addBtn.backgroundColor = QZH_KIT_Color_WHITE_100;
        [_addBtn setTitle:@"添加设备" forState:UIControlStateNormal];
        [_addBtn setTitleColor:QZHKIT_Color_BLACK_54 forState:UIControlStateNormal];
        [_addBtn addTarget:self action:@selector(addDeviceAction:) forControlEvents:UIControlEventTouchUpInside];
        QZHViewRadius(_addBtn, 5);
    }
    return _addBtn;
}

- (void)addDeviceAction:(UIButton *)sender{
    self.addDevice();
}
#pragma mark - TuyaSmartDeviceDelegate

- (void)device:(TuyaSmartDevice *)device dpsUpdate:(NSDictionary *)dps {
    // 设备的 dps 状态发生变化，刷新界面 UI
}

- (void)deviceInfoUpdate:(TuyaSmartDevice *)device {
    //当前设备信息更新 比如 设备名称修改、设备在线离线状态等
}

- (void)deviceRemoved:(TuyaSmartDevice *)device {
    //当前设备被移除
}

- (void)device:(TuyaSmartDevice *)device signal:(NSString *)signal {
    // Wifi信号强度
}

- (void)device:(TuyaSmartDevice *)device firmwareUpgradeProgress:(NSInteger)type progress:(double)progress {
    // 固件升级进度
}
//
//- (void)device:(TuyaSmartDevice *)device firmwareUpgradeStatusModel:(TuyaSmartFirmwareUpgradeStatusModel *)upgradeStatusModel {
//    // 设备升级状态的回调
//}
@end
