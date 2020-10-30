//
//  DeviceSettingVC.m
//  luxshare
//
//  Created by 黄振 on 2020/7/10.
//  Copyright © 2020 KingYellow. All rights reserved.
//

#import "DeviceSettingVC.h"
#import "SettingDefaultCell.h"
#import "SettingSwitchCell.h"
#import "DeviceInfoVC.h"
#import "BasicFunVC.h"
#import "DeceteAlarmVC.h"
#import "StorageVC.h"
#import "ElectricManageVC.h"
#import "ShareDeviceVC.h"
#import "UpdateDeviceVC.h"
#import "DeceteAlarmACVC.h"

@interface DeviceSettingVC ()<UITableViewDelegate,UITableViewDataSource,TuyaSmartCameraDPObserver>
@property (strong, nonatomic)UITableView *qzTableView;
@property (strong, nonatomic)NSMutableArray *listArr;
@property (strong, nonatomic)NSMutableArray *memberArr;
@property (strong, nonatomic)TuyaSmartCameraDPManager *dpManager;
@property (strong, nonatomic)TuyaSmartDevice *device;
@property (copy, nonatomic)NSArray *deviceUpdateArr;
@end

@implementation DeviceSettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initConfig];
}

- (void)initConfig{
    self.view.backgroundColor = QZHKIT_COLOR_LEADBACK;
    self.navigationItem.title = QZHLoaclString(@"setting_setting");
    [self exp_navigationBarTextWithColor:QZHKIT_COLOR_NAVIBAR_TITLE font:QZHKIT_FONT_TABBAR_TITLE];
    [self exp_navigationBarColor:QZHKIT_COLOR_NAVIBAR_BACK hiddenShadow:NO];
    [self UIConfig];
    self.dpManager = [[TuyaSmartCameraDPManager alloc] initWithDeviceId:self.deviceModel.devId];
    [self.dpManager addObserver:self];
    self.device = [TuyaSmartDevice deviceWithDeviceId:self.deviceModel.devId];
    self.deviceModel = self.device.deviceModel;
    if ([self isAdminOrOwner]) {
        [self getFirmwareUpgradeInfo];
    }
}
- (void)UIConfig{
    
    [self.view addSubview:self.qzTableView];
         [self.qzTableView mas_makeConstraints:^(MASConstraintMaker *make) {
         make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0 ));
     }];
}

#pragma mark -tableView
-(UITableView *)qzTableView{
    if (!_qzTableView) {
        _qzTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [_qzTableView exp_tableViewDefault];
        self.qzTableView.backgroundColor = QZHKIT_COLOR_LEADBACK;
        self.qzTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _qzTableView.delegate = self;
        _qzTableView.dataSource = self;
        [self.qzTableView registerClass:[SettingDefaultCell class] forCellReuseIdentifier:QZHCELL_REUSE_TEXT];
        [self.qzTableView registerClass:[SettingSwitchCell class] forCellReuseIdentifier:QZHCELL_REUSE_IMAGE];
    }
    return _qzTableView;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (self.deviceModel.isShare) {
        SettingDefaultCell *cell = [tableView dequeueReusableCellWithIdentifier:QZHCELL_REUSE_TEXT];
        cell.nameLab.text = QZHLoaclString(@"setting_basicFun");
        cell.radioPosition = 2;
        cell.tagLab.text = @"";
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    }
    if (section == 0) {
        if (row == 1) {
            SettingSwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:QZHCELL_REUSE_IMAGE];
            cell.nameLab.text = QZHLoaclString(@"privateModel");
            cell.radioPosition = 0;
            cell.switchBtn.tag = 1;
            cell.switchBtn.on =  [[self.dpManager valueForDP:TuyaSmartCameraBasicPrivateDPName] boolValue];
            [cell.switchBtn addTarget:self action:@selector(valueChange:) forControlEvents:UIControlEventValueChanged];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;

            return cell;
        }else{
            SettingDefaultCell *cell = [tableView dequeueReusableCellWithIdentifier:QZHCELL_REUSE_TEXT];
            cell.nameLab.text = self.listArr[row];
            if (row == 0) {
                cell.radioPosition = -1;
                cell.tagLab.text = @"";
            }else if (row == 3){
                cell.radioPosition = 1;
                int state = [[self.dpManager valueForDP:TuyaSmartCameraBasicNightvisionDPName] intValue];
                if (state == 1) {
                    cell.tagLab.text = QZHLoaclString(@"close");
                }
                if (state == 0) {
                    cell.tagLab.text = QZHLoaclString(@"auto");
                }
                if (state == 2) {
                    cell.tagLab.text = QZHLoaclString(@"open");
                }

            }else{
                cell.radioPosition = 0;
                cell.tagLab.text = @"";
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        
    }else if(section == 1){
        
        if (row == 5) {
            SettingSwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:QZHCELL_REUSE_IMAGE];
            cell.nameLab.text = QZHLoaclString(@"offlineNotice");
            cell.radioPosition = 1;
            cell.switchBtn.on = YES;
            cell.switchBtn.tag = 2;
            [cell.switchBtn addTarget:self action:@selector(valueChange:) forControlEvents:UIControlEventValueChanged];

            cell.selectionStyle = UITableViewCellSelectionStyleNone;
             return cell;
        }else{
            
             if ([self.deviceModel.productId isEqualToString:AC_PRODUCT_ID]) {
                 if (indexPath.section == 1 && indexPath.row == 3) {
                     return [UITableViewCell new];
                 }
             }
            SettingDefaultCell *cell = [tableView dequeueReusableCellWithIdentifier:QZHCELL_REUSE_TEXT];
             cell.nameLab.text = self.memberArr[row];
             if (row == 0) {
                 cell.radioPosition = -1;
             }else if (row == 2){
                 if ([QZHDeviceStatus deviceIsBattery:self.deviceModel]) {
                     cell.radioPosition = 0;
                 }else{
                     cell.radioPosition = 1;
                 }
             }else if (row == 3){
                 cell.radioPosition = 1;
             }else{
                 cell.radioPosition = 0;
             }
             cell.selectionStyle = UITableViewCellSelectionStyleNone;
             return cell;
        }
         
    }else{
        SettingDefaultCell *cell = [tableView dequeueReusableCellWithIdentifier:QZHCELL_REUSE_TEXT];
        cell.nameLab.text = QZHLoaclString(@"firmWareInfo");
        cell.radioPosition = 2;
        cell.tagLab.textColor = QZHColorWhite;
        cell.tagLab.textAlignment = NSTextAlignmentCenter;
        if (self.deviceUpdateArr.count > 0) {
            TuyaSmartFirmwareUpgradeModel *model = self.deviceUpdateArr.firstObject;
            if (model.upgradeStatus == 1) {
                cell.tagLab.backgroundColor = UIColor.redColor;
                [cell.tagLab mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.bottom.mas_equalTo(-15);
                    make.top.mas_equalTo(15);
                    make.width.mas_equalTo(20);

                }];
                QZHViewRadius(cell.tagLab, 10);
                cell.tagLab.text = @"1";
            }else{
                cell.tagLab.text = @"";
            }

        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
 
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 1) {
            UIView *view = [[UIView alloc] init];
        UILabel *lab = [[UILabel alloc] init];
        lab.text = QZHLoaclString(@"setting_moreSetting");
        lab.font = QZHKIT_FONT_LISTCELL_SUB_TITLE;
        lab.textColor = QZHKIT_Color_BLACK_54;
        lab.frame = CGRectMake(15, 30, QZHScreenWidth, 20);
        [view addSubview:lab];
        return view;
    }else{
        return [UIView new];
    }

}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    if ([self isAdminOrOwner]) {
    if (self.deviceModel.isShare) {
        return 1;
        
    }
    return 3;
//    }
   
//    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (self.deviceModel.isShare) {
        return 1;
        
    }
    if (section == 0 ) {
        return 4;
    }else if(section == 1){
       
        return self.memberArr.count - 2;
    }else{
        return 1;
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    if ([self.deviceModel.productId isEqualToString:AC_PRODUCT_ID]) {
        if (indexPath.section == 1 && indexPath.row == 3) {
            return 0;
        }
    }
    if (indexPath.section == 1 && indexPath.row == 4) {
        return 0;
    }
    
    return 50;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
   
    if (section == 1) {
        return 60;
    }
    
     return 30;
}

-(void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section{
    view.tintColor = QZHKIT_COLOR_LEADBACK;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    
    if (self.deviceModel.isShare) {
        BasicFunVC *vc = [[BasicFunVC alloc] init];
        vc.deviceModel = self.deviceModel;
        vc.homeModel = self.homeModel;
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    if (section == 0) {
        if (row == 0) {
            DeviceInfoVC *vc = [[DeviceInfoVC alloc] init];
            vc.deviceModel = self.deviceModel;
            vc.homeModel = self.homeModel;
            [self.navigationController pushViewController:vc animated:YES];
        }
        if (row == 2) {
            BasicFunVC *vc = [[BasicFunVC alloc] init];
            vc.deviceModel = self.deviceModel;
            vc.homeModel = self.homeModel;
            [self.navigationController pushViewController:vc animated:YES];
        }
        if (row == 3) {
            if (![QZHDeviceStatus deviceIsOnline:self.deviceModel]) {
                [[QZHHUD HUD] textHUDWithMessage:QZHLoaclString(@"deviceOfflineNoOperate") afterDelay:1.0];
                return;
            }
            [self creatActionSheet];
        }
    }
    if (section == 1) {
        if (row == 0) {
            
            if ([self.deviceModel.productId isEqualToString:AC_PRODUCT_ID]) {
                DeceteAlarmACVC *vc = [[DeceteAlarmACVC alloc] init];
                vc.deviceModel = self.deviceModel;
                vc.homeModel = self.homeModel;
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                DeceteAlarmVC *vc = [[DeceteAlarmVC alloc] init];
                vc.deviceModel = self.deviceModel;
                vc.homeModel = self.homeModel;
                [self.navigationController pushViewController:vc animated:YES];
            }

        }
        if (row == 1) {

            if ([[self.dpManager valueForDP:TuyaSmartCameraSDCardStatusDPName] intValue] == 5) {
                [[QZHHUD HUD] textHUDWithMessage:QZHLoaclString(@"noSDCardCantStorge") afterDelay:1.0];

            }else{
                
                StorageVC *vc = [[StorageVC alloc] init];
                vc.deviceModel = self.deviceModel;
                vc.homeModel = self.homeModel;
                [self.navigationController pushViewController:vc animated:YES];
            }

        }
        if (row == 3) {
            ElectricManageVC *vc = [[ElectricManageVC alloc] init];
            vc.deviceModel = self.deviceModel;
            vc.homeModel = self.homeModel;
            [self.navigationController pushViewController:vc animated:YES];
        }
        if (row == 2) {
            if (![QZHCommons isAdminOrOwner:self.homeModel]) {
                [[QZHHUD HUD] textHUDWithMessage:QZHLoaclString(@"notAdminCantShare") afterDelay:1.0];
                return;;
            }
            ShareDeviceVC *vc = [[ShareDeviceVC alloc] init];
            vc.deviceModel = self.deviceModel;
            vc.homeModel = self.homeModel;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    if (section == 2) {
        if ([self isAdminOrOwner]) {
            TuyaSmartFirmwareUpgradeModel *model = self.deviceUpdateArr.firstObject;
            if (model.upgradeStatus == 0) {
                UIAlertController *alertC = [UIAlertController alertControllerWithTitle:QZHLoaclString(@"lastVersion") message:[NSString stringWithFormat:@"%@: %@",QZHLoaclString(@"currentVersion"),model.currentVersion] preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *action = [UIAlertAction actionWithTitle:QZHLoaclString(@"submit") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                [alertC addAction:action];
                [self presentViewController:alertC animated:NO completion:nil];
            }else{
                //有新版本
                QZHWS(weakSelf)
                UpdateDeviceVC *vc = [[UpdateDeviceVC alloc] init];
                vc.deviceModel = self.deviceModel;
                vc.homeModel = self.homeModel;
                vc.upModel = self.deviceUpdateArr.firstObject;
                vc.refresh = ^{
                    [weakSelf getFirmwareUpgradeInfo];
                };
                [self.navigationController pushViewController:vc animated:YES];
            }
            
        }else{
            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:QZHLoaclString(@"versionInfo") message:[NSString stringWithFormat:@"%@: %@",QZHLoaclString(@"currentVersion"),self.deviceModel.verSw] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:QZHLoaclString(@"submit") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alertC addAction:action];
            [self presentViewController:alertC animated:NO completion:nil];
        }

   
    }
}

#pragma mark --lazy
- (NSMutableArray *)listArr{
    if (!_listArr) {
        _listArr = [NSMutableArray arrayWithArray:@[QZHLoaclString(@"deviceInfo"),QZHLoaclString(@"privateModel"),QZHLoaclString(@"setting_basicFun"),QZHLoaclString(@"infraredNight")]];
 
    }
    return _listArr;
}
- (NSMutableArray *)memberArr{
    if (!_memberArr) {
        _memberArr = [NSMutableArray arrayWithArray:@[QZHLoaclString(@"setting_deceteAlarm"),QZHLoaclString(@"setting_storage"),QZHLoaclString(@"mine_shareDevices"),QZHLoaclString(@"setting_electricManage"),QZHLoaclString(@"faceRecognition"),QZHLoaclString(@"offlineNotice")]];
 
    }
    return _memberArr;
}
#pragma mark -- action
- (void)valueChange:(UISwitch *) sender{
    if (![QZHDeviceStatus deviceIsOnline:self.deviceModel]) {
        sender.on = !sender.on;
        [[QZHHUD HUD] textHUDWithMessage:QZHLoaclString(@"deviceOfflineNoOperate") afterDelay:1.0];
        return;
    }
    QZHWS(weakSelf)
    if (sender.tag == 1) {
        //隐私
        if ([self.dpManager isSupportDP:TuyaSmartCameraBasicPrivateDPName]) {
            
            [self.dpManager setValue:@(sender.on) forDP:TuyaSmartCameraBasicPrivateDPName success:^(id result) {
                [[QZHHUD HUD] textHUDWithMessage:QZHLoaclString(@"handleSuccess") afterDelay:0.5];

                [weakSelf.qzTableView reloadData];
            } failure:^(NSError *error) {
                sender.on = !sender.on;
                   [[QZHHUD HUD] textHUDWithMessage:error.userInfo[@"NSLocalizedDescription"] afterDelay:0.5];
            }];
        }
    }else{
        //离线
    }
}
#pragma mark -- 红外夜视
-(void)creatActionSheet {
//"0"：关闭；"1"：自动；"2"：打开
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:QZHLoaclString(@"infraredNight") message:nil preferredStyle:UIAlertControllerStyleActionSheet];

    QZHWS(weakSelf)
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:QZHLoaclString(@"auto") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ([self.dpManager isSupportDP:TuyaSmartCameraBasicNightvisionDPName]) {
            
            [self.dpManager setValue:@"0" forDP:TuyaSmartCameraBasicNightvisionDPName success:^(id result) {
                [weakSelf.qzTableView reloadData];
            } failure:^(NSError *error) {
               [[QZHHUD HUD] textHUDWithMessage:error.userInfo[@"NSLocalizedDescription"] afterDelay:0.5];
            }];
        }
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:QZHLoaclString(@"close") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
          if ([self.dpManager isSupportDP:TuyaSmartCameraBasicNightvisionDPName]) {
              
              [self.dpManager setValue:@"1" forDP:TuyaSmartCameraBasicNightvisionDPName success:^(id result) {
                  [weakSelf.qzTableView reloadData];
              } failure:^(NSError *error) {
                 [[QZHHUD HUD] textHUDWithMessage:error.userInfo[@"NSLocalizedDescription"] afterDelay:0.5];
              }];
          }
    }];
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:QZHLoaclString(@"open") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ([self.dpManager isSupportDP:TuyaSmartCameraBasicNightvisionDPName]) {
            
            [self.dpManager setValue:@"2" forDP:TuyaSmartCameraBasicNightvisionDPName success:^(id result) {
                [weakSelf.qzTableView reloadData];
            } failure:^(NSError *error) {
               [[QZHHUD HUD] textHUDWithMessage:error.userInfo[@"NSLocalizedDescription"] afterDelay:0.5];
            }];
        }
    }];
    UIAlertAction *action4 = [UIAlertAction actionWithTitle:QZHLoaclString(@"cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    
    //把action添加到actionSheet里
    [actionSheet addAction:action1];
    [actionSheet addAction:action2];
    [actionSheet addAction:action3];
    [actionSheet addAction:action4];

    //相当于之前的[actionSheet show];
    [self presentViewController:actionSheet animated:YES completion:nil];
}
#pragma mark -- 设备升级信息

- (void)getFirmwareUpgradeInfo{
QZHWS(weakSelf)
    [self.device getFirmwareUpgradeInfo:^(NSArray<TuyaSmartFirmwareUpgradeModel *> *upgradeModelList) {
        weakSelf.deviceUpdateArr = upgradeModelList;

        [weakSelf.qzTableView reloadData];
    } failure:^(NSError *error) {
       [[QZHHUD HUD] textHUDWithMessage:error.userInfo[@"NSLocalizedDescription"] afterDelay:0.5];
        
    }];
}
- (BOOL)isAdminOrOwner{
    if ((self.homeModel.role == TYHomeRoleType_Admin ||self.homeModel.role == TYHomeRoleType_Owner )&& !self.deviceModel.isShare) {
        return YES;
    }
    return NO;
}

@end
