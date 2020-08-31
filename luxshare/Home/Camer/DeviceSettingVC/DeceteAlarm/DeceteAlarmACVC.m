//
//  DeceteAlarmACVC.m
//  luxshare
//
//  Created by 黄振 on 2020/8/1.
//  Copyright © 2020 KingYellow. All rights reserved.
//
//    162    设备重启
//    167    哭声侦测开关
//    168    报警区域开关
//    169    报警区域
//    170    人形过滤
//    185    告警消息上报
//    231    主动休眠
//    232    哭声检测灵敏度

#import "DeceteAlarmACVC.h"
#import "PerInfoDefaultCell.h"
#import "SettingSwitchCell.h"
#import "DeviceInfoVC.h"
#import "BasicFunVC.h"
#import "AlarmTimeListVC.h"
#import "AlarmAreaVC.h"

@interface DeceteAlarmACVC ()<UITableViewDelegate,UITableViewDataSource,TuyaSmartCameraDPObserver,TuyaSmartDeviceDelegate>
@property (strong, nonatomic)UITableView *qzTableView;

@property (strong, nonatomic)TuyaSmartCameraDPManager *dpManager;
@property (strong, nonatomic)TuyaSmartDevice *device;
@property (copy, nonatomic)NSArray *deviceUpdateArr;
@property (assign, nonatomic)BOOL humanFilter;
@property (assign, nonatomic)BOOL alarmAreaSwitch;
@property (strong, nonatomic)NSString *alarmArea;
@property (assign, nonatomic)BOOL crySwitch;
@property (strong, nonatomic)NSString *crySensitivity;
@property (strong, nonatomic)NSMutableArray *timeArr;
@property (assign, nonatomic)int interval;
@end

@implementation DeceteAlarmACVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initConfig];
}
- (void)initConfig{
    self.view.backgroundColor = QZHKIT_COLOR_LEADBACK;
    self.navigationItem.title = QZHLoaclString(@"setting_deceteAlarm");
    [self exp_navigationBarTextWithColor:QZHKIT_COLOR_NAVIBAR_TITLE font:QZHKIT_FONT_TABBAR_TITLE];
    [self exp_navigationBarColor:QZHKIT_COLOR_NAVIBAR_BACK hiddenShadow:NO];
    [self UIConfig];
    self.dpManager = [[TuyaSmartCameraDPManager alloc] initWithDeviceId:self.deviceModel.devId];
    [self.dpManager addObserver:self];
    self.device = [TuyaSmartDevice deviceWithDeviceId:self.deviceModel.devId];
    self.deviceModel = self.device.deviceModel;
    self.device.delegate = self;
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
        [self.qzTableView registerClass:[SettingSwitchCell class] forCellReuseIdentifier:QZHCELL_REUSE_IMAGE];
    }
    return _qzTableView;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (section == 0) {
        if (row == 2) {

             PerInfoDefaultCell *cell = [tableView dequeueReusableCellWithIdentifier:QZHCELL_REUSE_TEXT];
             cell.nameLab.text = QZHLoaclString(@"setting_alarmSensitivity");
             int state = [[self.dpManager valueForDP:TuyaSmartCameraMotionSensitivityDPName] intValue];

             if (state == 0) {
                 cell.describeLab.text = @"低灵敏度";
             }
             if (state == 1) {
                 cell.describeLab.text = @"中灵敏度";
             }
             if (state == 2) {
                 cell.describeLab.text = @"高灵敏度";
             }
             cell.selectionStyle = UITableViewCellSelectionStyleNone;
             cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

            return cell;
        }else{

             SettingSwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:QZHCELL_REUSE_IMAGE];
            [cell.nameLab mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(15);
            }];
            if (row == 0) {
                cell.nameLab.text = QZHLoaclString(@"setting_decrteAlarmSwitch");
                cell.switchBtn.on = [self.deviceModel.dps[@"134"] boolValue];
                cell.switchBtn.tag = 0;
            }else{
                cell.nameLab.text = QZHLoaclString(@"setting_personFilter");
                cell.switchBtn.on = [self.deviceModel.dps[@"170"] boolValue];
                cell.switchBtn.tag = 1;
            }

            cell.contentView.backgroundColor = QZHColorWhite;
            [cell.switchBtn addTarget:self action:@selector(valueChange:) forControlEvents:UIControlEventValueChanged];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
             return cell;
        }
      
    }else if(section == 1){
        
        if (row == 0) {
             SettingSwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:QZHCELL_REUSE_IMAGE];
            cell.nameLab.text = QZHLoaclString(@"setting_alarmAreaSwitch");
            [cell.nameLab mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(15);
            }];
            cell.switchBtn.on = [self.deviceModel.dps[@"168"] boolValue];
            cell.switchBtn.tag = 2;
            cell.contentView.backgroundColor = QZHColorWhite;
            [cell.switchBtn addTarget:self action:@selector(valueChange:) forControlEvents:UIControlEventValueChanged];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
             return cell;
        }else{
            PerInfoDefaultCell *cell = [tableView dequeueReusableCellWithIdentifier:QZHCELL_REUSE_TEXT];
            cell.nameLab.text = QZHLoaclString(@"setting_alarmArea");
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
         
    }else if(section == 2){
        
        if (row == 0) {
             SettingSwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:QZHCELL_REUSE_IMAGE];
            cell.nameLab.text = QZHLoaclString(@"setting_decetecVoice");
            [cell.nameLab mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(15);
            }];
            cell.switchBtn.on = [[self.dpManager valueForDP:TuyaSmartCameraDecibelDetectDPName] boolValue];
            cell.switchBtn.tag = 3;
            cell.contentView.backgroundColor = QZHColorWhite;
            [cell.switchBtn addTarget:self action:@selector(valueChange:) forControlEvents:UIControlEventValueChanged];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
             return cell;
        }else{
            PerInfoDefaultCell *cell = [tableView dequeueReusableCellWithIdentifier:QZHCELL_REUSE_TEXT];
             cell.nameLab.text = QZHLoaclString(@"setting_decetecVoiceSensitivity");
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            int state = [[self.dpManager valueForDP:TuyaSmartCameraDecibelSensitivityDPName] intValue];
            if (state == 0) {
                cell.describeLab.text = @"低灵敏度";
            }
            if (state == 1) {
                cell.describeLab.text = @"高灵敏度";
            }
             cell.selectionStyle = UITableViewCellSelectionStyleNone;
             return cell;
        }
         
    }else if(section == 3){
        
        if (row == 0) {
             SettingSwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:QZHCELL_REUSE_IMAGE];
            cell.nameLab.text = QZHLoaclString(@"setting_decetecCry");
            [cell.nameLab mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(15);
            }];
            cell.switchBtn.on = [self.deviceModel.dps[@"167"] boolValue];
            cell.switchBtn.tag = 4;
            cell.contentView.backgroundColor = QZHColorWhite;
            [cell.switchBtn addTarget:self action:@selector(valueChange:) forControlEvents:UIControlEventValueChanged];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
             return cell;
        }else{
            PerInfoDefaultCell *cell = [tableView dequeueReusableCellWithIdentifier:QZHCELL_REUSE_TEXT];
             cell.nameLab.text = QZHLoaclString(@"setting_decetecCrySensitivity");
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            int state = [self.deviceModel.dps[@"232"] intValue];
            if (state == 0) {
                cell.describeLab.text = @"低灵敏度";
            }
            if (state == 1) {
                cell.describeLab.text = @"高灵敏度";
            }
             cell.selectionStyle = UITableViewCellSelectionStyleNone;
             return cell;
        }
         
    }else{
        PerInfoDefaultCell *cell = [tableView dequeueReusableCellWithIdentifier:QZHCELL_REUSE_TEXT];
        if (row == 0) {
            cell.nameLab.text = @"定时";
        }else{
            cell.nameLab.text = @"报警间隔";
            int time = [self.deviceModel.dps[@"133"] intValue];
             cell.describeLab.text  = [NSString stringWithFormat:@"%d分钟",time];
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
 
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
        UIView *view = [[UIView alloc] init];
        UILabel *lab = [[UILabel alloc] init];

        if (section == 0) {
            lab.text = QZHLoaclString(@"setting_moveAlarm");

        }else if(section == 1){
            lab.text = QZHLoaclString(@"setting_alarmArea");

        }else if(section == 2){
            lab.text = QZHLoaclString(@"setting_decetecVoice");

        }else if(section == 3){
            lab.text = QZHLoaclString(@"setting_decetecCry");

        }else{
            lab.text = QZHLoaclString(@"setting_timerAlarm");

        }
        lab.font = QZHKIT_FONT_LISTCELL_SUB_TITLE;
        lab.textColor = QZHKIT_Color_BLACK_54;
        lab.frame = CGRectMake(15, 20, QZHScreenWidth, 20);
        [view addSubview:lab];
        return view;


}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
   
    return 5;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0 ) {
        return 3;
    }else if(section == 1){
       
        return 2;
    }else{
        return 2;
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

     return 50;
}

-(void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section{
    view.tintColor = QZHKIT_COLOR_LEADBACK;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    if (section == 0) {
        if (row == 2) {
            [self creatPIRActionSheet];
        }
    }
    if (section == 1) {
        if (row == 1) {
            AlarmAreaVC *vc = [[AlarmAreaVC alloc] init];
            vc.deviceModel = self.deviceModel;
            vc.homeModel = self.homeModel;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    if (section == 2) {
        if (row == 1) {
            [self creatDecibelActionSheet];
        }
    }
    if (section == 3) {
        if (row == 1) {
            [self creatCryActionSheet];
        }
    }
    if (section == 4) {
        if (row == 0) {
            AlarmTimeListVC *vc = [[AlarmTimeListVC alloc] init];
            vc.deviceModel = self.deviceModel;
            vc.homeModel = self.homeModel;
            [self.navigationController pushViewController:vc animated:YES];
        }
        if (row == 1) {
            QZHWS(weakSelf)
           [BRStringPickerView showPickerWithTitle:@"时间间隔" dataSourceArr:self.timeArr selectIndex:0 resultBlock:^(BRResultModel * _Nullable resultModel) {
                NSDictionary  *dps = @{@"133": @(resultModel.index*2 + 1)};

                [weakSelf.device publishDps:dps success:^{
                      [weakSelf.qzTableView reloadData];

                } failure:^(NSError *error) {
                    [[QZHHUD HUD]textHUDWithMessage:@"设备暂不支持" afterDelay:1.0];
//                      [[QZHHUD HUD] textHUDWithMessage:error.userInfo[@"NSLocalizedDescription"] afterDelay:0.5];

                  }];
            }];

        }
    }
}
#pragma mark -- lazy
-(NSMutableArray *)timeArr{
    if (!_timeArr) {
        _timeArr = [NSMutableArray arrayWithArray:@[@"1分钟",@"3分钟",@"5分钟"]];
        
    }
    return _timeArr;
}
#pragma mark -- action
- (void)valueChange:(UISwitch *) sender{
    QZHWS(weakSelf)
    if (sender.tag == 0) {
        
        NSDictionary  *dps = @{@"134": @(sender.on)};
          [self.device publishDps:dps success:^{

          } failure:^(NSError *error) {
              sender.on = !sender.on;
              [[QZHHUD HUD] textHUDWithMessage:error.userInfo[@"NSLocalizedDescription"] afterDelay:0.5];

          }];
            
//        [self.dpManager setValue:@(YES) forDP:TuyaSmartCameraMotionDetectDPName success:^(id result) {
//            [weakSelf.qzTableView reloadData];
//        } failure:^(NSError *error) {
//            sender.on = !sender.on;
//        }];
    }
    if (sender.tag == 1) {
        NSDictionary  *dps = @{@"170": @(sender.on)};
          [self.device publishDps:dps success:^{

          } failure:^(NSError *error) {
              sender.on = !sender.on;
              [[QZHHUD HUD] textHUDWithMessage:error.userInfo[@"NSLocalizedDescription"] afterDelay:0.5];

          }];
    }
    if (sender.tag == 2) {
        NSDictionary  *dps = @{@"168": @(sender.on)};
          [self.device publishDps:dps success:^{

          } failure:^(NSError *error) {
              sender.on = !sender.on;
              [[QZHHUD HUD] textHUDWithMessage:error.userInfo[@"NSLocalizedDescription"] afterDelay:0.5];

          }];
    }
    if (sender.tag == 3) {
        if ([self.dpManager isSupportDP:TuyaSmartCameraDecibelDetectDPName]) {
            
            [self.dpManager setValue:@(sender.on) forDP:TuyaSmartCameraDecibelDetectDPName success:^(id result) {
                [weakSelf.qzTableView reloadData];
            } failure:^(NSError *error) {
                sender.on = !sender.on;
                [[QZHHUD HUD] textHUDWithMessage:error.userInfo[@"NSLocalizedDescription"] afterDelay:0.5];

            }];
        }
    }
    if (sender.tag == 4) {
        NSDictionary  *dps = @{@"167": @(sender.on)};
          [self.device publishDps:dps success:^{

          } failure:^(NSError *error) {
              sender.on = !sender.on;
              [[QZHHUD HUD] textHUDWithMessage:error.userInfo[@"NSLocalizedDescription"] afterDelay:0.5];
          }];
    }
    //隐私
}

#pragma mark -- PIR

-(void)creatPIRActionSheet{

    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"移动侦测灵敏度" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    QZHWS(weakSelf)
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"低灵敏度" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ([self.dpManager isSupportDP:TuyaSmartCameraMotionSensitivityDPName]) {
            
            [self.dpManager setValue:@"0" forDP:TuyaSmartCameraMotionSensitivityDPName success:^(id result) {
                [weakSelf.qzTableView reloadData];
            } failure:^(NSError *error) {
               [[QZHHUD HUD] textHUDWithMessage:error.userInfo[@"NSLocalizedDescription"] afterDelay:0.5];
            }];
        }
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"中灵敏度" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
          if ([self.dpManager isSupportDP:TuyaSmartCameraMotionSensitivityDPName]) {
              
              [self.dpManager setValue:@"1" forDP:TuyaSmartCameraMotionSensitivityDPName success:^(id result) {
                  [weakSelf.qzTableView reloadData];
              } failure:^(NSError *error) {
                 [[QZHHUD HUD] textHUDWithMessage:error.userInfo[@"NSLocalizedDescription"] afterDelay:0.5];
              }];
          }
    }];
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"高灵敏度" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ([self.dpManager isSupportDP:TuyaSmartCameraMotionSensitivityDPName]) {
            
            [self.dpManager setValue:@"2" forDP:TuyaSmartCameraMotionSensitivityDPName success:^(id result) {
                [weakSelf.qzTableView reloadData];
            } failure:^(NSError *error) {
               [[QZHHUD HUD] textHUDWithMessage:error.userInfo[@"NSLocalizedDescription"] afterDelay:0.5];
            }];
        }
    }];
    
    UIAlertAction *action5 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"取消");
    }];
    
    //把action添加到actionSheet里
    [actionSheet addAction:action1];
    [actionSheet addAction:action2];
    [actionSheet addAction:action3];
    [actionSheet addAction:action5];

    //相当于之前的[actionSheet show];
    [self presentViewController:actionSheet animated:YES completion:nil];
}

#pragma mark -- decibel

-(void)creatDecibelActionSheet{
    QZHWS(weakSelf)
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"声音检测灵敏度" message:nil preferredStyle:UIAlertControllerStyleActionSheet];

    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"低灵敏度" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
          if ([self.dpManager isSupportDP:TuyaSmartCameraDecibelSensitivityDPName]) {
              
              [self.dpManager setValue:@"0" forDP:TuyaSmartCameraDecibelSensitivityDPName success:^(id result) {
                  [weakSelf.qzTableView reloadData];
              } failure:^(NSError *error) {
                 [[QZHHUD HUD] textHUDWithMessage:error.userInfo[@"NSLocalizedDescription"] afterDelay:0.5];
              }];
          }
    }];

    UIAlertAction *action4 = [UIAlertAction actionWithTitle:@"高灵敏度" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ([self.dpManager isSupportDP:TuyaSmartCameraDecibelSensitivityDPName]) {
            
            [self.dpManager setValue:@"1" forDP:TuyaSmartCameraDecibelSensitivityDPName success:^(id result) {
                [weakSelf.qzTableView reloadData];
            } failure:^(NSError *error) {
               [[QZHHUD HUD] textHUDWithMessage:error.userInfo[@"NSLocalizedDescription"] afterDelay:0.5];
            }];
        }
    }];
    UIAlertAction *action5 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"取消");
    }];
    
    //把action添加到actionSheet里
    [actionSheet addAction:action2];
    [actionSheet addAction:action4];
    [actionSheet addAction:action5];


    //相当于之前的[actionSheet show];
    [self presentViewController:actionSheet animated:YES completion:nil];
}
-(void)creatCryActionSheet{
    QZHWS(weakSelf)
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"哭声检测灵敏度" message:nil preferredStyle:UIAlertControllerStyleActionSheet];

    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"低灵敏度" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSDictionary  *dps = @{@"232": @"0"};

        [self.device publishDps:dps success:^{
            [weakSelf.qzTableView reloadData];

        } failure:^(NSError *error) {
            [[QZHHUD HUD] textHUDWithMessage:error.userInfo[@"NSLocalizedDescription"] afterDelay:0.5];

        }];

    }];

    UIAlertAction *action4 = [UIAlertAction actionWithTitle:@"高灵敏度" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSDictionary  *dps = @{@"232": @"1"};

        [self.device publishDps:dps success:^{
              [weakSelf.qzTableView reloadData];

          } failure:^(NSError *error) {
              [[QZHHUD HUD] textHUDWithMessage:error.userInfo[@"NSLocalizedDescription"] afterDelay:0.5];

          }];
    }];
    UIAlertAction *action5 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"取消");
    }];
    
    //把action添加到actionSheet里
    [actionSheet addAction:action2];
    [actionSheet addAction:action4];
    [actionSheet addAction:action5];


    //相当于之前的[actionSheet show];
    [self presentViewController:actionSheet animated:YES completion:nil];
}
#pragma mark -- deviceDelete
- (void)device:(TuyaSmartDevice *)device dpsUpdate:(NSDictionary *)dps{
    self.device = [TuyaSmartDevice deviceWithDeviceId:self.deviceModel.devId];

    [self.qzTableView reloadData];
}
-(void)dealloc{
    self.device.delegate = nil;
}
@end
