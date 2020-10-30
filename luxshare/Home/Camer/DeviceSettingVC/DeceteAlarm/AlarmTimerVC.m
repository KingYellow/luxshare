//
//  AlarmTimerVC.m
//  luxshare
//
//  Created by 黄振 on 2020/8/5.
//  Copyright © 2020 KingYellow. All rights reserved.
//

#import "AlarmTimerVC.h"
#import "SettingDefaultCell.h"
#import "SettingSwitchCell.h"
#import "QZHTimeCell.h"
#import "WeekSelectVC.h"

@interface AlarmTimerVC ()<UITableViewDelegate,UITableViewDataSource,TuyaSmartCameraDPObserver>
@property (strong, nonatomic)UITableView *qzTableView;
@property (copy, nonatomic)NSArray *listArr;
@property (strong, nonatomic)NSMutableArray *memberArr;
@property (strong, nonatomic)TuyaSmartCameraDPManager *dpManager;
@property (strong, nonatomic)TuyaSmartDevice *device;
@property (strong, nonatomic)NSString *selectTime;
@property (assign, nonatomic)BOOL motionON;
@property (assign, nonatomic)BOOL voiceON;
@property (assign, nonatomic)BOOL noticeON;
@property (strong, nonatomic)NSString *weekDays;
@property (strong, nonatomic)NSString *remarkText;
@property (strong, nonatomic)TuyaSmartTimer *timer;
@end

@implementation AlarmTimerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.timerModel) {
        self.motionON = [self.timerModel.dps[@"134"] boolValue];
        self.noticeON = self.timerModel.isAppPush;
        self.voiceON = [self.timerModel.dps[@"139"] boolValue];
        self.selectTime = self.timerModel.time;
        self.listArr = [self getweekArr:self.timerModel.loops];
        self.weekDays = [self getWeekday:self.listArr];
        self.remarkText = self.timerModel.aliasName;
    }else{
        self.motionON = YES;
        self.noticeON = YES;
        self.voiceON = YES;
        NSDateFormatter *form = [NSDateFormatter jk_dateFormatterWithFormat:@"HH:mm"];
        self.selectTime = [form stringFromDate:[NSDate date]];
        self.weekDays = QZHLoaclString(@"onlyOnce");
    }

    [self initConfig];
}

- (void)initConfig{
    self.view.backgroundColor = QZHKIT_COLOR_LEADBACK;
    self.navigationItem.title = QZHLoaclString(@"setting_setting");
    [self exp_navigationBarTextWithColor:QZHKIT_COLOR_NAVIBAR_TITLE font:QZHKIT_FONT_TABBAR_TITLE];
    [self exp_navigationBarColor:QZHKIT_COLOR_NAVIBAR_BACK hiddenShadow:NO];
    [self exp_addRightItemTitle:QZHLoaclString(@"save") itemIcon:@""];
    [self UIConfig];
    self.dpManager = [[TuyaSmartCameraDPManager alloc] initWithDeviceId:self.deviceModel.devId];
    [self.dpManager addObserver:self];
    self.device = [TuyaSmartDevice deviceWithDeviceId:self.deviceModel.devId];

}
- (void)UIConfig{
    
    [self.view addSubview:self.qzTableView];
         [self.qzTableView mas_makeConstraints:^(MASConstraintMaker *make) {
         make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0 ));
     }];
}
- (void)exp_rightAction{
    QZHWS(weakSelf)
    NSString *loop = @"";
    if ([self.weekDays isEqualToString:QZHLoaclString(@"onlyOnce")]) {
        loop = @"0000000";
    }else{
        for (NSDictionary *dic in self.listArr) {
             if ([dic[@"select"] boolValue]) {
               loop = [loop stringByAppendingString:@"1"];
             }else{
               loop = [loop stringByAppendingString:@"0"];
             }
         }
    }
    NSDictionary *dps = @{@"139":@(self.voiceON),@"134":@(self.motionON)};
    self.timer = [[TuyaSmartTimer alloc] init];
    if (self.timerModel) {
        [self.timer updateTimerWithTask:QZHTUYATIMERALARM loops:loop devId:self.deviceModel.devId timerId:self.timerModel.timerId time:self.selectTime dps:dps timeZone:@"+08:00" isAppPush:self.noticeON aliasName:self.remarkText success:^{
            [[QZHHUD HUD] textHUDWithMessage:QZHLoaclString(@"handleSuccess") afterDelay:0.5];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                weakSelf.refresh();
                [weakSelf.navigationController popViewControllerAnimated:YES];
                
            });
        } failure:^(NSError *error) {
            [[QZHHUD HUD] textHUDWithMessage:error.userInfo[@"NSLocalizedDescription"] afterDelay:0.5];

        }];
    }else{
        [self.timer addTimerWithTask:QZHTUYATIMERALARM loops:loop devId:self.deviceModel.devId time:self.selectTime dps:dps timeZone:@"+08:00" isAppPush:self.noticeON aliasName:self.remarkText success:^{
            [[QZHHUD HUD] textHUDWithMessage:QZHLoaclString(@"handleSuccess") afterDelay:0.5];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                weakSelf.refresh();
                [weakSelf.navigationController popViewControllerAnimated:YES];
                
            });
            
        } failure:^(NSError *error) {
               [[QZHHUD HUD] textHUDWithMessage:error.userInfo[@"NSLocalizedDescription"] afterDelay:0.5];
        }];
    }
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
        [self.qzTableView registerClass:[QZHTimeCell class] forCellReuseIdentifier:QZHCELL_REUSE_DEFAULT];

    }
    return _qzTableView;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (section == 0) {
        QZHTimeCell *cell = [tableView dequeueReusableCellWithIdentifier:QZHCELL_REUSE_DEFAULT];
        cell.timeLab.text = self.selectTime;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        return cell;
        
    }else if(section == 1){
        
        if (row == 2) {
             SettingSwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:QZHCELL_REUSE_IMAGE];
             cell.nameLab.text = QZHLoaclString(@"beginNotice");
            cell.radioPosition = 1;
            cell.switchBtn.on = YES;
            cell.switchBtn.tag = 2;
            [cell.switchBtn addTarget:self action:@selector(valueChange:) forControlEvents:UIControlEventValueChanged];

            cell.selectionStyle = UITableViewCellSelectionStyleNone;
             return cell;
        }else{

            SettingDefaultCell *cell = [tableView dequeueReusableCellWithIdentifier:QZHCELL_REUSE_TEXT];
             if (row == 0) {
                 cell.nameLab.text = QZHLoaclString(@"repeat");
                 cell.tagLab.text = self.weekDays;
                 cell.radioPosition = -1;
             }else{
                 cell.nameLab.text = QZHLoaclString(@"note");
                 cell.radioPosition = 0;
                 cell.tagLab.text = self.remarkText;

             }
             cell.selectionStyle = UITableViewCellSelectionStyleNone;
             return cell;
        }
         
    }else{
        SettingDefaultCell *cell = [tableView dequeueReusableCellWithIdentifier:QZHCELL_REUSE_TEXT];
         cell.nameLab.text = self.memberArr[row];
         if (row == 0) {
             cell.radioPosition = -1;
             if (self.motionON) {
                 cell.tagLab.text = QZHLoaclString(@"open");
             }else{
                 cell.tagLab.text = QZHLoaclString(@"close");
             }
         }else{
             cell.radioPosition = 1;
             if (self.voiceON) {
                 cell.tagLab.text = QZHLoaclString(@"open");
             }else{
                 cell.tagLab.text = QZHLoaclString(@"close");
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
    if ([self isAdminOrOwner]) {
        return 3;
    }
   
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0 ) {
        return 1;
    }else if(section == 1){
       
        return 3;
    }else{
        return 2;
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    if (indexPath.section == 0) {
        return 70;
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
    QZHWS(weakSelf)
    if (section == 0) {
        if (row == 0) {
            [BRDatePickerView showDatePickerWithMode:BRDatePickerModeHM title:QZHLoaclString(@"selectDate") selectValue:nil minDate:nil maxDate:nil isAutoSelect:NO resultBlock:^(NSDate * _Nullable selectDate, NSString * _Nullable selectValue) {
                weakSelf.selectTime = selectValue;
                [weakSelf.qzTableView exp_refreshAtIndexSection:0];
            }];
           
        }
    }
    if (section == 1) {
        if (row == 0) {
            [self selectDateAction];
        }
        if (row == 1) {
            QZHWS(weakSelf)
          UIAlertController *alert = [UIAlertController alertWithTextfieldTitle:QZHLoaclString(@"note") originaltext:self.remarkText textblock:^(NSString * _Nonnull fieldtext) {
                weakSelf.remarkText = fieldtext;
                [weakSelf.qzTableView exp_refreshAtIndexSection:1];
            }];
            [self presentViewController:alert animated:YES completion:nil];
        }

    }
    if (section == 2) {
       if (row == 0) {
           [self creatMotionONActionSheet];
       }
       if (row == 1) {
          [self creatVoiceONActionSheet];
       }
        
    }
}

#pragma mark --lazy
- (NSArray *)listArr{
    if (!_listArr) {
        _listArr = [NSArray array];
 
    }
    return _listArr;
}
- (NSMutableArray *)memberArr{
    if (!_memberArr) {
        _memberArr = [NSMutableArray arrayWithArray:@[QZHLoaclString(@"decrteAlarm"),QZHLoaclString(@"voiceAlarm")]];
 
    }
    return _memberArr;
}
#pragma mark -- action
- (void)valueChange:(UISwitch *) sender{
    self.noticeON = sender.on;
}
- (void)selectDateAction{
    QZHWS(weakSelf)
    WeekSelectVC *VC = [[WeekSelectVC alloc] init];
    if (self.listArr.count> 0) {
        VC.listArr = [NSMutableArray arrayWithArray:self.listArr];
    }

    VC.selectWeek = ^(NSArray * _Nonnull listArr) {
        weakSelf.listArr = listArr;
        weakSelf.weekDays = [weakSelf getWeekday:listArr];
        [self.qzTableView exp_refreshAtIndexSection:1];;
    };
    [self.navigationController pushViewController:VC animated:YES];
}
#pragma mark -- 移动侦测开关
-(void)creatMotionONActionSheet {
    QZHWS(weakSelf)
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:QZHLoaclString(@"decrteAlarm") message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:QZHLoaclString(@"open") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        weakSelf.motionON = YES;
        [weakSelf.qzTableView exp_refreshAtIndexSection:2];

    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:QZHLoaclString(@"close") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        weakSelf.motionON = NO;
        [weakSelf.qzTableView exp_refreshAtIndexSection:2];

    }];

    UIAlertAction *action3 = [UIAlertAction actionWithTitle:QZHLoaclString(@"cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"取消");
    }];
    [actionSheet addAction:action1];
    [actionSheet addAction:action2];
    [actionSheet addAction:action3];

    [self presentViewController:actionSheet animated:YES completion:nil];
}
#pragma mark -- 声音侦测开关
-(void)creatVoiceONActionSheet {
    QZHWS(weakSelf)
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:QZHLoaclString(@"voiceAlarm") message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:QZHLoaclString(@"open") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        weakSelf.voiceON = YES;
        [weakSelf.qzTableView exp_refreshAtIndexSection:2];

    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:QZHLoaclString(@"close") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        weakSelf.voiceON = NO;
        [weakSelf.qzTableView exp_refreshAtIndexSection:2];
    }];

    UIAlertAction *action3 = [UIAlertAction actionWithTitle:QZHLoaclString(@"cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"取消");
    }];
    [actionSheet addAction:action1];
    [actionSheet addAction:action2];
    [actionSheet addAction:action3];

    [self presentViewController:actionSheet animated:YES completion:nil];
}

- (BOOL)isAdminOrOwner{
    if (self.homeModel.role == TYHomeRoleType_Admin ||self.homeModel.role == TYHomeRoleType_Owner) {
        return YES;
    }
    return NO;
}
- (NSArray *)getweekArr:(NSString *)weekday{
    NSMutableArray *week = [NSMutableArray array];
    
    for (NSInteger i = 0; i < weekday.length; i++) {
        NSRange   range =  NSMakeRange(i, 1);
        NSString *subStr = [weekday substringWithRange:range];
        [week addObject:subStr];
    }
    if (week.count > 6) {
        NSMutableArray *weekArrM = [NSMutableArray arrayWithObjects:@{@"week":QZHLoaclString(@"Sunday"),@"select":@"0",},@{@"week":QZHLoaclString(@"Monday"),@"select":@"0",},@{@"week":QZHLoaclString(@"Tuesday"),@"select":@"0",},@{@"week":QZHLoaclString(@"Wednesday"),@"select":@"0",},@{@"week":QZHLoaclString(@"Thursday"),@"select":@"0",},@{@"week":QZHLoaclString(@"Friday"),@"select":@"0",},@{@"week":QZHLoaclString(@"Saturday"),@"select":@"0",}, nil];
        for (int i = 0; i < weekArrM.count; i++) {
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:weekArrM[i]];
             if ([week[i] boolValue]) {
                 [dic setValue:@"1" forKey:@"select"];
             }else{
                 [dic setValue:@"0" forKey:@"select"];
             }
             [weekArrM replaceObjectAtIndex:i withObject:dic];
        }
        return weekArrM;

    }else{
        return [NSArray arrayWithObjects:@[],@[],@[],@[],@[],@[],@[], nil];
    }
}
- (NSString *)getWeekday:(NSArray *)weeks{
    NSMutableArray *weekArr = [NSMutableArray array];
    NSString *weekDay = @"";
    for (NSDictionary *dic in weeks) {
         if ([dic[@"select"] boolValue]) {
             [weekArr addObject:dic[@"week"]];
         }
     }
    if (weekArr.count == 7) {
        weekDay = QZHLoaclString(@"EveryDay");
    }else if(weekArr.count == 5 && ![weekArr containsObject:QZHLoaclString(@"Saturday")] && ![weekArr containsObject:QZHLoaclString(@"Sunday")]){
           weekDay = QZHLoaclString(@"WorkDay");
    }else if(weekArr.count == 0){
        weekDay = QZHLoaclString(@"onlyOnce");
    }else{
        weekDay = [weekArr componentsJoinedByString:@","];
    }
    return weekDay;
}
@end
