//
//  DeviceInfoVC.m
//  luxshare
//
//  Created by 黄振 on 2020/7/15.
//  Copyright © 2020 KingYellow. All rights reserved.
//

#import "DeviceInfoVC.h"
#import "PerInfoDefaultCell.h"
#import "DeviceLogoCell.h"
#import "SelectRooeVC.h"


@interface DeviceInfoVC ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic)UITableView *qzTableView;
@property (strong, nonatomic)TuyaSmartDevice *device;
@end

@implementation DeviceInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initConfig];
    [self getNewData];
    self.device = [TuyaSmartDevice deviceWithDeviceId:self.deviceModel.devId];
}
- (void)initConfig{
    self.view.backgroundColor = QZHKIT_COLOR_LEADBACK;
    self.navigationItem.title = QZHLoaclString(@"device_deviceInfo");
    [self exp_navigationBarTextWithColor:QZHKIT_COLOR_NAVIBAR_TITLE font:QZHKIT_FONT_TABBAR_TITLE];
    [self exp_navigationBarColor:QZHKIT_COLOR_NAVIBAR_BACK hiddenShadow:NO];
    [self UIConfig];

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

        [self.qzTableView registerClass:[PerInfoDefaultCell class] forCellReuseIdentifier:QZHCELL_REUSE_TEXT];
        [self.qzTableView registerClass:[DeviceLogoCell class] forCellReuseIdentifier:QZHCELL_REUSE_IMAGE];
    }
    return _qzTableView;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (section == 0) {
        DeviceLogoCell *cell = [tableView dequeueReusableCellWithIdentifier:QZHCELL_REUSE_IMAGE];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if ([self.deviceModel.productId isEqualToString:BATTERY_PRODUCT_ID]) {
            cell.logoIMG.image = QZHLoadIcon(@"ic_ipc_battery");
        }else{
            cell.logoIMG.image = QZHLoadIcon(@"ic_ipc_ac");
        }
        return cell;
    }else{
        
        PerInfoDefaultCell *cell = [tableView dequeueReusableCellWithIdentifier:QZHCELL_REUSE_TEXT];
        if (row == 0) {
            cell.nameLab.text = QZHLoaclString(@"device_deviceName");
            if (self.deviceModel.name) {
                cell.describeLab.text = self.deviceModel.name;

            }else{
                cell.describeLab.text = QZHLoaclString(@"device_deviceNamePlace");
            }
        }else{
            if (self.deviceModel.roomId) {
                TuyaSmartRoom *room = [TuyaSmartRoom roomWithRoomId:self.deviceModel.roomId homeId:self.homeModel.homeId];
                cell.describeLab.text = room.roomModel.name;

            }else{
                cell.describeLab.text = @"";
            }
            cell.nameLab.text = QZHLoaclString(@"device_deviceLocation");
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }

}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
   
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0 ) {
        return 1;
    }else{
        return 2;
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 90;
    }
    return 50;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
   
    return 20;
}

-(void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section{
    view.tintColor = QZHKIT_COLOR_LEADBACK;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   NSInteger section = indexPath.section;
   NSInteger row = indexPath.row;
   if (section == 1 & row == 0) {
       QZHWS(weakSelf)
       UIAlertController *alert =   [UIAlertController alertWithTextfieldTitle:QZHLoaclString(@"device_deviceName") originaltext:self.deviceModel.name textblock:^(NSString * _Nonnull fieldtext) {
           [weakSelf modifyDeviceName:fieldtext];
           
       }];
       [self presentViewController:alert animated:YES completion:nil];
       
   }
   if (section == 1 & row == 1) {
       SelectRooeVC *vc = [[SelectRooeVC alloc] init];
       vc.homeModel = self.homeModel;
       vc.deviceModel = self.deviceModel;
       QZHWS(weakSelf)
       vc.selectBlack = ^(TuyaSmartRoomModel * _Nonnull model) {
           [weakSelf addDevice:model];
       };
       [self.navigationController pushViewController:vc animated:YES];
      }
}

#pragma mark --method
- (void)modifyDeviceName:(NSString *)name {
    // self.device = [TuyaSmartDevice deviceWithDeviceId:@"your_device_id"];

    [self.device updateName:name success:^{
        QZHWS(weakSelf)
        [[QZHHUD HUD] textHUDWithMessage:QZHLoaclString(@"handleSuccess") afterDelay:0.5];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.qzTableView reloadData];
        });

    } failure:^(NSError *error) {
        NSLog(@"updateName failure: %@", error);
           [[QZHHUD HUD] textHUDWithMessage:error.userInfo[@"NSLocalizedDescription"] afterDelay:0.5];
    }];
}

- (void)addDevice:(TuyaSmartRoomModel *)model {
    
    TuyaSmartRoom *room = [TuyaSmartRoom roomWithRoomId:model.roomId homeId:self.homeModel.homeId];
    [room addDeviceWithDeviceId:self.deviceModel.devId success:^{
        QZHWS(weakSelf)
        [[QZHHUD HUD] textHUDWithMessage:QZHLoaclString(@"handleSuccess") afterDelay:0.5];
        [QZHNotification postNotificationName:QZHNotificationKeyK1 object:nil];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf getNewData];
            
        });
    } failure:^(NSError *error) {
        [[QZHHUD HUD] textHUDWithMessage:error.userInfo[@"NSLocalizedDescription"] afterDelay:0.5];
        
    }];
}

- (void)getNewData{
    TuyaSmartHome *home = [TuyaSmartHome homeWithHomeId:self.homeModel.homeId];
    [home getHomeDetailWithSuccess:^(TuyaSmartHomeModel *homeModel) {
        self.homeModel = home.homeModel;
        self.deviceModel = [TuyaSmartDevice deviceWithDeviceId:self.deviceModel.devId].deviceModel;
        [self.qzTableView reloadData];
    } failure:^(NSError *error) {
        [[QZHHUD HUD] textHUDWithMessage:error.userInfo[@"NSLocalizedDescription"] afterDelay:0.5];

    }];


}

@end
