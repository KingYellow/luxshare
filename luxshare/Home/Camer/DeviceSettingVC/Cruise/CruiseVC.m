//
//  CruiseVC.m
//  luxshare
//
//  Created by 黄振 on 2020/12/28.
//  Copyright © 2020 KingYellow. All rights reserved.
//

#import "CruiseVC.h"
#import "CruiseTimerSelectView.h"
#import "CruiseSwitchCell.h"
#import "CruiseDefaultCell.h"
#import "CruiseTimeCell.h"

@interface CruiseVC ()<UITableViewDelegate,UITableViewDataSource,TuyaSmartCameraDPObserver,TuyaSmartDeviceDelegate>
@property (strong, nonatomic)UITableView *qzTableView;

@property (strong, nonatomic)TuyaSmartCameraDPManager *dpManager;
@property (strong, nonatomic)TuyaSmartDevice *device;
@property (strong, nonatomic)UIView *selectTimeView;

@end

@implementation CruiseVC

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

        _qzTableView.delegate = self;
        _qzTableView.dataSource = self;

        [self.qzTableView registerClass:[CruiseDefaultCell class] forCellReuseIdentifier:QZHCELL_REUSE_DEFAULT];
        [self.qzTableView registerClass:[CruiseSwitchCell class] forCellReuseIdentifier:QZHCELL_REUSE_IMAGE];
        [self.qzTableView registerClass:[CruiseTimeCell class] forCellReuseIdentifier:QZHCELL_REUSE_TEXT];

    }
    return _qzTableView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (section == 0) {
        
            CruiseSwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:QZHCELL_REUSE_IMAGE];
            cell.nameLab.text = QZHLoaclString(@"cruise_turnOnCamerCruise");
            cell.switchBtn.on = [self.deviceModel.dps[@"174"] boolValue];
            [cell.switchBtn addTarget:self action:@selector(valueChange:) forControlEvents:UIControlEventValueChanged];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
             return cell;
      
    }else if(section == 1){
        
        CruiseDefaultCell *cell = [tableView dequeueReusableCellWithIdentifier:QZHCELL_REUSE_DEFAULT];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.selectBtn.tag = row;
        [cell.selectBtn addTarget:self action:@selector(cruiseModeValueChange:) forControlEvents:UIControlEventTouchUpInside];
        if (row == 0) {

            cell.nameLab.text = QZHLoaclString(@"cruise_panoramicCruise");
            cell.contentLab.text = QZHLoaclString(@"cruise_cycleThroughAllMonitoringAngles");

            cell.selectBtn.selected = ![self.deviceModel.dps[@"175"] boolValue];
             return cell;
        }else{
            return  [UITableViewCell new];

            cell.nameLab.text = QZHLoaclString(@"cruise_collectionPointCruise");
            cell.contentLab.text = QZHLoaclString(@"cruise_cycleThrougAllTheCollectionPoints");
            cell.selectBtn.selected = [self.deviceModel.dps[@"175"] boolValue];
            return cell;
        }         
    }else{
        
        if (row == 0) {
             CruiseTimeCell *cell = [tableView dequeueReusableCellWithIdentifier:QZHCELL_REUSE_TEXT];
            cell.nameLab.text = QZHLoaclString(@"cruise_cruiseAllDay");
            cell.contentLab.text = QZHLoaclString(@"cruise_camerCurisingAllDay");
            cell.selectBtn.selected = ![self.deviceModel.dps[@"176"] boolValue];
            cell.selectBtn.tag = row;
            [cell.selectBtn addTarget:self action:@selector(cruiseTimeValueChange:) forControlEvents:UIControlEventTouchUpInside];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
             return cell;
        }else{
            CruiseTimeCell *cell = [tableView dequeueReusableCellWithIdentifier:QZHCELL_REUSE_TEXT];
           cell.nameLab.text = QZHLoaclString(@"cruise_timedCruise");
            cell.contentLab.text = QZHLoaclString(@"cruise_cruiseInTheSpecifieTime");
            cell.cruiseLab.text = QZHLoaclString(@"cruise_cruiseTime");
            NSString *timeStr = self.deviceModel.dps[@"177"];
            cell.timeLab.text = [NSString stringWithFormat:@"%@",timeStr];
            if ([timeStr isEqualToString:@""]) {
                
            }else{
                
                NSData *jsonData = [timeStr dataUsingEncoding:NSUTF8StringEncoding];
                NSError *err;
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                    options:NSJSONReadingMutableContainers
                                                                      error:&err];
                NSString *startTime = dic[@"t_start"];
                NSString *endTime = dic[@"t_end"];

                cell.timeLab.text = [NSString stringWithFormat:@"%@-%@",startTime,endTime];
            }
            cell.selectBtn.selected = [self.deviceModel.dps[@"176"] boolValue];
            cell.selectBtn.tag = row;
            [cell.selectBtn addTarget:self action:@selector(cruiseTimeValueChange:) forControlEvents:UIControlEventTouchUpInside];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
        UIView *view = [[UIView alloc] init];
        UILabel *lab = [[UILabel alloc] init];

        if (section == 0) {

        }else if(section == 1){
            lab.text = QZHLoaclString(@"cruise_setCruiseMode");

        }else if(section == 2){
            lab.text = QZHLoaclString(@"cruise_selectCruiseTime");

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
    if([self.deviceModel.dps[@"174"] boolValue]){
        return 3;;
    }
   
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0 || section == 1) {
        return 1;
    }
    return 2;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 10;
    }
     return 50;
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section{
    view.tintColor = QZHKIT_COLOR_LEADBACK;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;

    if (section == 2 && row == 1) {

        QZHWS(weakSelf)
        CruiseTimerSelectView *selectView = [[CruiseTimerSelectView alloc] initWithFrame:self.navigationController.view.frame];
        NSString *timestr = self.deviceModel.dps[@"177"];
        if (timestr) {
            selectView.selectTime = timestr;
        }
        [selectView  creatSelectTimerViewConfig];
  
        selectView.selectBlock = ^(NSString * _Nonnull starttime, NSString * _Nonnull endTime) {
            NSDictionary *timeDic = @{@"t_start":starttime,@"t_end":endTime};

            NSData *data=[NSJSONSerialization dataWithJSONObject:timeDic options:NSJSONWritingPrettyPrinted error:nil];
            NSString *jsonStr=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            NSString *jsonClear = [jsonStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
             jsonClear = [jsonClear stringByReplacingOccurrencesOfString:@" " withString:@""];

            NSDictionary  *dps = @{@"177":jsonStr};
              [weakSelf.device publishDps:dps success:^{

              } failure:^(NSError *error) {

                  [[QZHHUD HUD] textHUDWithMessage:error.userInfo[@"NSLocalizedDescription"] afterDelay:1.0];
              }];
            
        };
        [self.navigationController.view addSubview:selectView];
    }
}

#pragma mark -- action
- (void)valueChange:(UISwitch *)sender{
    self.device = [TuyaSmartDevice deviceWithDeviceId:self.deviceModel.devId];
    self.device.delegate = self;
    self.deviceModel = self.device.deviceModel;
    if ([self.deviceModel.dps[@"237"] boolValue]) {
        [[QZHHUD HUD]textHUDWithMessage:QZHLoaclString(@"turnOffHumanTracking") afterDelay:1.0];
        sender.on = !sender.on;
        return;
    }
    
    NSDictionary  *dps = @{@"174": @(sender.on)};
    
      [self.device publishDps:dps success:^{

      } failure:^(NSError *error) {
          sender.on = !sender.on;
          [[QZHHUD HUD] textHUDWithMessage:error.userInfo[@"NSLocalizedDescription"] afterDelay:1.0];

      }];
}
- (void)cruiseTimeValueChange:(UIButton *)sender{
    
    NSDictionary  *dps = @{@"176": [NSString stringWithFormat:@"%ld",(long)sender.tag]};

      [self.device publishDps:dps success:^{

      } failure:^(NSError *error) {

          [[QZHHUD HUD] textHUDWithMessage:error.userInfo[@"NSLocalizedDescription"] afterDelay:1.0];

      }];
}
- (void)cruiseModeValueChange:(UIButton *)sender{

    NSDictionary  *dps = @{@"175": [NSString stringWithFormat:@"%ld",(long)sender.tag]};
    
      [self.device publishDps:dps success:^{

      } failure:^(NSError *error) {

          [[QZHHUD HUD] textHUDWithMessage:error.userInfo[@"NSLocalizedDescription"] afterDelay:1.0];

      }];
}

#pragma mark -- deviceDelete
- (void)device:(TuyaSmartDevice *)device dpsUpdate:(NSDictionary *)dps{
    self.device = [TuyaSmartDevice deviceWithDeviceId:self.deviceModel.devId];
    self.device.delegate = self;
    self.deviceModel = self.device.deviceModel;
    [self.qzTableView reloadData];
}

@end
