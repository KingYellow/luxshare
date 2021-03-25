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
         make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, QZHHeightBottom, 0 ));
     }];
}

#pragma mark -tableView
- (UITableView *)qzTableView{
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (section == 0) {
        if (row == 2) {

             PerInfoDefaultCell *cell = [tableView dequeueReusableCellWithIdentifier:QZHCELL_REUSE_TEXT];
             cell.nameLab.text = QZHLoaclString(@"setting_motionDetectionSensitivity");
             int state = [[self.dpManager valueForDP:TuyaSmartCameraMotionSensitivityDPName] intValue];

             if (state == 0) {
                 cell.describeLab.text = QZHLoaclString(@"lowSensitivity");
             }
             if (state == 1) {
                 cell.describeLab.text = QZHLoaclString(@"midSensitivity");
             }
             if (state == 2) {
                 cell.describeLab.text = QZHLoaclString(@"highSensitivity");
             }
            if ([self.deviceModel.dps[@"134"] boolValue]) {
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }else{
                //关闭人形侦测时候 隐藏报警灵敏度
                return [UITableViewCell new];
            }
             cell.selectionStyle = UITableViewCellSelectionStyleNone;

            return cell;
        }else{

             SettingSwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:QZHCELL_REUSE_IMAGE];
            [cell.nameLab mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(15);
            }];
            if (row == 1) {
                cell.nameLab.text = QZHLoaclString(@"setting_personFilter");
                if ([self.deviceModel.dps[@"134"] boolValue]) {
                    cell.switchBtn.on = [self.deviceModel.dps[@"170"] boolValue];
                    cell.switchBtn.tag = 1;

                }else{
                    //关闭人形侦测时候 隐藏报警灵敏度
                    return [UITableViewCell new];
                }
            }else{
                cell.nameLab.text = QZHLoaclString(@"setting_decrteAlarmSwitch");
                cell.switchBtn.on = [self.deviceModel.dps[@"134"] boolValue];
                cell.switchBtn.tag = 0;
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
            cell.describeLab.text = @"";
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
            int state = [[self.dpManager valueForDP:TuyaSmartCameraDecibelSensitivityDPName] intValue];
            if (state == 0) {
                cell.describeLab.text = QZHLoaclString(@"lowSensitivity");
            }
            if (state == 1) {
                cell.describeLab.text = QZHLoaclString(@"highSensitivity");
            }
             cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

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
        }else if (row == 2) {
            SettingSwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:QZHCELL_REUSE_IMAGE];
           cell.nameLab.text = QZHLoaclString(@"playLullabyAuto");
           [cell.nameLab mas_updateConstraints:^(MASConstraintMaker *make) {
               make.left.mas_equalTo(15);
           }];
           cell.switchBtn.on = [self.deviceModel.dps[@"234"] boolValue];
           cell.switchBtn.tag = 41;
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
                cell.describeLab.text = QZHLoaclString(@"lowSensitivity");
            }
            if (state == 1) {
                cell.describeLab.text = QZHLoaclString(@"highSensitivity");
            }
             cell.selectionStyle = UITableViewCellSelectionStyleNone;
             return cell;
        }
         
    }else if(section == 4){

        PerInfoDefaultCell *cell = [tableView dequeueReusableCellWithIdentifier:QZHCELL_REUSE_TEXT];
         cell.nameLab.text = QZHLoaclString(@"setting_deceteMusic");
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        int state = [self.deviceModel.dps[@"233"] intValue];
        if (state == 0) {
            cell.describeLab.text = QZHLoaclString(@"closeAlarmMusic");
        }
        if (state == 1) {
            cell.describeLab.text = QZHLoaclString(@"welcome");
        }
        if (state == 2) {
            cell.describeLab.text = QZHLoaclString(@"dangerGoAway");
        }
        if (state == 3) {
            cell.describeLab.text = QZHLoaclString(@"homeGoAway");
        }
         cell.selectionStyle = UITableViewCellSelectionStyleNone;
         return cell;
    }else{
        PerInfoDefaultCell *cell = [tableView dequeueReusableCellWithIdentifier:QZHCELL_REUSE_TEXT];
        if (row == 0) {
            
            cell.nameLab.text = QZHLoaclString(@"timer");
            cell.describeLab.text  = @"";

        }else{
            
            cell.nameLab.text = QZHLoaclString(@"alarminterval");
            int time = [self.deviceModel.dps[@"133"] intValue];
            cell.describeLab.text  = [NSString stringWithFormat:@"%dmin",time];
        }
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
 
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
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

        }else if(section == 4){
            lab.text = QZHLoaclString(@"setting_deceteMusic");

        }else{
            lab.text = QZHLoaclString(@"setting_timerAlarm");

        }
        lab.font = QZHKIT_FONT_LISTCELL_SUB_TITLE;
        lab.textColor = QZHKIT_Color_BLACK_54;
        lab.frame = CGRectMake(15, 20, QZHScreenWidth, 20);
        [view addSubview:lab];
        return view;


}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
   
    return 6;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0 ) {
        return 3;
    }else if(section == 1){
        if ([self.deviceModel.dps[@"168"] boolValue]) {
            return 2;
        }else{
            return 1;
        }
    }else if(section == 2){
       
        return 0;
    }else if(section == 3){
        if ([self.deviceModel.dps[@"167"] boolValue]) {
            return 3;
        }else{
            return 1;
        }
    }else if(section == 4){
       //暂时隐藏提示音
        return 0;
//        return 1;
    }else{
        return 2;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;

    if ((section == 0 && row == 2) || (section == 0 && row == 1)) {
        if ([self.deviceModel.dps[@"134"] boolValue]) {
            return 50;
        }else{
            return 0;
        }
    }
    if (section == 2) {
        return 0;
    }
    return 50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 2) {
        return 0;
    }
    if (section == 4) {
        //暂时隐藏提示音
        return 0;
    }
     return 50;
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section{
    view.tintColor = QZHKIT_COLOR_LEADBACK;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    if (section == 0) {
        if (![QZHDeviceStatus deviceIsOnline:self.deviceModel]) {
            [[QZHHUD HUD] textHUDWithMessage:QZHLoaclString(@"deviceOfflineNoOperate") afterDelay:1.0];
            return;
        }
        if (row == 2) {
            [self creatPIRActionSheet];
        }
    }
    if (section == 1) {
        if (![QZHDeviceStatus deviceIsOnline:self.deviceModel]) {
            [[QZHHUD HUD] textHUDWithMessage:QZHLoaclString(@"deviceOfflineNoOperate") afterDelay:1.0];
            return;
        }
        if (row == 1) {
           BOOL private =  [[self.dpManager valueForDP:TuyaSmartCameraBasicPrivateDPName] boolValue];

            if (private) {
                [[QZHHUD HUD] textHUDWithMessage:QZHLoaclString(@"privateNoSetAlarmArea") afterDelay:1.0];
            }else{
                AlarmAreaVC *vc = [[AlarmAreaVC alloc] init];
                vc.deviceModel = self.deviceModel;
                vc.homeModel = self.homeModel;
                [self.navigationController pushViewController:vc animated:YES];
                
            }
        }
    }
    if (section == 2) {
        if (![QZHDeviceStatus deviceIsOnline:self.deviceModel]) {
            [[QZHHUD HUD] textHUDWithMessage:QZHLoaclString(@"deviceOfflineNoOperate") afterDelay:1.0];
            return;
        }
        if (row == 1) {
            [self creatDecibelActionSheet];
        }
    }
    if (section == 3) {
        if (![QZHDeviceStatus deviceIsOnline:self.deviceModel]) {
            [[QZHHUD HUD] textHUDWithMessage:QZHLoaclString(@"deviceOfflineNoOperate") afterDelay:1.0];
            return;
        }
        if (row == 1) {
            [self creatCryActionSheet];
        }
    }
    if (section == 4) {
        if (![QZHDeviceStatus deviceIsOnline:self.deviceModel]) {
            [[QZHHUD HUD] textHUDWithMessage:QZHLoaclString(@"deviceOfflineNoOperate") afterDelay:1.0];
            return;
        }
        [self creatDeceteMusicSheet];
    }
    if (section == 5) {
        if (row == 0) {
            AlarmTimeListVC *vc = [[AlarmTimeListVC alloc] init];
            vc.deviceModel = self.deviceModel;
            vc.homeModel = self.homeModel;
            [self.navigationController pushViewController:vc animated:YES];
        }
        if (row == 1) {
            QZHWS(weakSelf)
           [BRStringPickerView showPickerWithTitle:QZHLoaclString(@"alarminterval") dataSourceArr:self.timeArr selectIndex:0 resultBlock:^(BRResultModel * _Nullable resultModel) {
               NSString *time = @"0";
               if (resultModel.index == 0) {
                   time = @"1";
               }
               if (resultModel.index == 1) {
                   time = @"3";
               }
               if (resultModel.index == 2) {
                   time = @"5";
               }
                NSDictionary  *dps = @{@"133": time};

                [weakSelf.device publishDps:dps success:^{
                      [weakSelf.qzTableView reloadData];

                } failure:^(NSError *error) {
                   [[QZHHUD HUD] textHUDWithMessage:error.userInfo[@"NSLocalizedDescription"] afterDelay:0.5];

                  }];
            }];

        }
    }
}
#pragma mark -- lazy
- (NSMutableArray *)timeArr{
    if (!_timeArr) {
        _timeArr = [NSMutableArray arrayWithArray:@[@"1min",@"3min",@"5min"]];
        
    }
    return _timeArr;
}
#pragma mark -- action
- (void)valueChange:(UISwitch *)sender{
    
    if (![QZHDeviceStatus deviceIsOnline:self.deviceModel]) {
        sender.on = !sender.on;
        [[QZHHUD HUD] textHUDWithMessage:QZHLoaclString(@"deviceOfflineNoOperate") afterDelay:1.0];
        return;
    }
    QZHWS(weakSelf)
    if (sender.tag == 1) {
        
        NSDictionary  *dps = @{@"170": @(sender.on)};
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
    if (sender.tag == 0) {
        NSDictionary  *dps = @{@"134": @(sender.on)};
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
    if (sender.tag == 41) {
        NSDictionary  *dps = @{@"234": @(sender.on)};
          [self.device publishDps:dps success:^{

          } failure:^(NSError *error) {
              sender.on = !sender.on;
              [[QZHHUD HUD] textHUDWithMessage:error.userInfo[@"NSLocalizedDescription"] afterDelay:0.5];
          }];
    }
    //隐私
}

#pragma mark -- PIR

- (void)creatPIRActionSheet{

    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:QZHLoaclString(@"setting_decetecSensitivity") message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    QZHWS(weakSelf)
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:QZHLoaclString(@"lowSensitivity") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ([self.dpManager isSupportDP:TuyaSmartCameraMotionSensitivityDPName]) {
            
            [self.dpManager setValue:@"0" forDP:TuyaSmartCameraMotionSensitivityDPName success:^(id result) {
                [weakSelf.qzTableView reloadData];
            } failure:^(NSError *error) {
               [[QZHHUD HUD] textHUDWithMessage:error.userInfo[@"NSLocalizedDescription"] afterDelay:0.5];
            }];
        }
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:QZHLoaclString(@"midSensitivity") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
          if ([self.dpManager isSupportDP:TuyaSmartCameraMotionSensitivityDPName]) {
              
              [self.dpManager setValue:@"1" forDP:TuyaSmartCameraMotionSensitivityDPName success:^(id result) {
                  [weakSelf.qzTableView reloadData];
              } failure:^(NSError *error) {
                 [[QZHHUD HUD] textHUDWithMessage:error.userInfo[@"NSLocalizedDescription"] afterDelay:0.5];
              }];
          }
    }];
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:QZHLoaclString(@"highSensitivity") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ([self.dpManager isSupportDP:TuyaSmartCameraMotionSensitivityDPName]) {
            
            [self.dpManager setValue:@"2" forDP:TuyaSmartCameraMotionSensitivityDPName success:^(id result) {
                [weakSelf.qzTableView reloadData];
            } failure:^(NSError *error) {
               [[QZHHUD HUD] textHUDWithMessage:error.userInfo[@"NSLocalizedDescription"] afterDelay:0.5];
            }];
        }
    }];
    
    UIAlertAction *action5 = [UIAlertAction actionWithTitle:QZHLoaclString(@"cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
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

- (void)creatDecibelActionSheet{
    QZHWS(weakSelf)
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:QZHLoaclString(@"voiceSensitivity") message:nil preferredStyle:UIAlertControllerStyleActionSheet];

    UIAlertAction *action2 = [UIAlertAction actionWithTitle:QZHLoaclString(@"lowSensitivity") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
          if ([self.dpManager isSupportDP:TuyaSmartCameraDecibelSensitivityDPName]) {
              
              [self.dpManager setValue:@"0" forDP:TuyaSmartCameraDecibelSensitivityDPName success:^(id result) {
                  [weakSelf.qzTableView reloadData];
              } failure:^(NSError *error) {
                 [[QZHHUD HUD] textHUDWithMessage:error.userInfo[@"NSLocalizedDescription"] afterDelay:0.5];
              }];
          }
    }];

    UIAlertAction *action4 = [UIAlertAction actionWithTitle:QZHLoaclString(@"highSensitivity") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ([self.dpManager isSupportDP:TuyaSmartCameraDecibelSensitivityDPName]) {
            
            [self.dpManager setValue:@"1" forDP:TuyaSmartCameraDecibelSensitivityDPName success:^(id result) {
                [weakSelf.qzTableView reloadData];
            } failure:^(NSError *error) {
               [[QZHHUD HUD] textHUDWithMessage:error.userInfo[@"NSLocalizedDescription"] afterDelay:0.5];
            }];
        }
    }];
    UIAlertAction *action5 = [UIAlertAction actionWithTitle:QZHLoaclString(@"cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"取消");
    }];
    
    //把action添加到actionSheet里
    [actionSheet addAction:action2];
    [actionSheet addAction:action4];
    [actionSheet addAction:action5];


    //相当于之前的[actionSheet show];
    [self presentViewController:actionSheet animated:YES completion:nil];
}
- (void)creatCryActionSheet{
    QZHWS(weakSelf)
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:QZHLoaclString(@"crySensitivity") message:nil preferredStyle:UIAlertControllerStyleActionSheet];

    UIAlertAction *action2 = [UIAlertAction actionWithTitle:QZHLoaclString(@"lowSensitivity") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSDictionary  *dps = @{@"232": @"0"};

        [self.device publishDps:dps success:^{
            [weakSelf.qzTableView reloadData];

        } failure:^(NSError *error) {
            [[QZHHUD HUD] textHUDWithMessage:error.userInfo[@"NSLocalizedDescription"] afterDelay:0.5];

        }];

    }];

    UIAlertAction *action4 = [UIAlertAction actionWithTitle:QZHLoaclString(@"highSensitivity") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSDictionary  *dps = @{@"232": @"1"};

        [self.device publishDps:dps success:^{
              [weakSelf.qzTableView reloadData];

          } failure:^(NSError *error) {
              [[QZHHUD HUD] textHUDWithMessage:error.userInfo[@"NSLocalizedDescription"] afterDelay:0.5];

          }];
    }];
    UIAlertAction *action5 = [UIAlertAction actionWithTitle:QZHLoaclString(@"cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"取消");
    }];
    
    //把action添加到actionSheet里
    [actionSheet addAction:action2];
    [actionSheet addAction:action4];
    [actionSheet addAction:action5];


    //相当于之前的[actionSheet show];
    [self presentViewController:actionSheet animated:YES completion:nil];
}
//报警声音
- (void)creatDeceteMusicSheet{
    QZHWS(weakSelf)
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:QZHLoaclString(@"alarmMusic") message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:QZHLoaclString(@"closeAlarmMusic") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSDictionary  *dps = @{@"233": @"0"};

        [self.device publishDps:dps success:^{
            [weakSelf.qzTableView reloadData];

        } failure:^(NSError *error) {
            [[QZHHUD HUD] textHUDWithMessage:error.userInfo[@"NSLocalizedDescription"] afterDelay:0.5];

        }];

    }];

    UIAlertAction *action2 = [UIAlertAction actionWithTitle:QZHLoaclString(@"welcome") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSDictionary  *dps = @{@"233": @"1"};

        [self.device publishDps:dps success:^{
              [weakSelf.qzTableView reloadData];

          } failure:^(NSError *error) {
              [[QZHHUD HUD] textHUDWithMessage:error.userInfo[@"NSLocalizedDescription"] afterDelay:0.5];

          }];
    }];
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:QZHLoaclString(@"dangerGoAway") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSDictionary  *dps = @{@"233": @"2"};

        [self.device publishDps:dps success:^{
            [weakSelf.qzTableView reloadData];

        } failure:^(NSError *error) {
            [[QZHHUD HUD] textHUDWithMessage:error.userInfo[@"NSLocalizedDescription"] afterDelay:0.5];

        }];

    }];

    UIAlertAction *action4 = [UIAlertAction actionWithTitle:QZHLoaclString(@"homeGoAway") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSDictionary  *dps = @{@"233": @"3"};

        [self.device publishDps:dps success:^{
              [weakSelf.qzTableView reloadData];

          } failure:^(NSError *error) {
              [[QZHHUD HUD] textHUDWithMessage:error.userInfo[@"NSLocalizedDescription"] afterDelay:0.5];

          }];
    }];
    UIAlertAction *action5 = [UIAlertAction actionWithTitle:QZHLoaclString(@"cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"取消");
    }];
    
    //把action添加到actionSheet里
    [actionSheet addAction:action1];
    [actionSheet addAction:action2];
    [actionSheet addAction:action3];
    [actionSheet addAction:action4];
    [actionSheet addAction:action5];


    //相当于之前的[actionSheet show];
    [self presentViewController:actionSheet animated:YES completion:nil];
}
#pragma mark -- deviceDelete
- (void)device:(TuyaSmartDevice *)device dpsUpdate:(NSDictionary *)dps{
    self.device = [TuyaSmartDevice deviceWithDeviceId:self.deviceModel.devId];
    self.device.delegate = self;
    self.deviceModel = self.device.deviceModel;
    [self.qzTableView reloadData];
}

@end
