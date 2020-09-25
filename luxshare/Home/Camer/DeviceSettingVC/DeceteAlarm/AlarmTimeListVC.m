//
//  AlarmTimeListVC.m
//  luxshare
//
//  Created by 黄振 on 2020/8/6.
//  Copyright © 2020 KingYellow. All rights reserved.
//

#import "AlarmTimeListVC.h"
#import "SettingDefaultCell.h"
#import "SettingSwitchCell.h"
#import "QZHTimeCell.h"
#import "AlarmTimerVC.h"
#import "AlarmTimeListCell.h"

@interface AlarmTimeListVC ()<UITableViewDelegate,UITableViewDataSource,TuyaSmartCameraDPObserver>
@property (strong, nonatomic)UITableView *qzTableView;
@property (copy, nonatomic)NSMutableArray *listArr;
@property (strong, nonatomic)NSMutableArray *memberArr;
@property (strong, nonatomic)TuyaSmartCameraDPManager *dpManager;
@property (strong, nonatomic)TuyaSmartDevice *device;
@property (strong, nonatomic)TuyaSmartTimer *timer;
@end

@implementation AlarmTimeListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initConfig];
    [self getTimerList];
}

- (void)initConfig{
    self.view.backgroundColor = QZHKIT_COLOR_LEADBACK;
    self.navigationItem.title = QZHLoaclString(@"setting_setting");
    [self exp_navigationBarTextWithColor:QZHKIT_COLOR_NAVIBAR_TITLE font:QZHKIT_FONT_TABBAR_TITLE];
    [self exp_navigationBarColor:QZHKIT_COLOR_NAVIBAR_BACK hiddenShadow:NO];
    [self exp_addRightItemTitle:@"添加定时" itemIcon:@""];
    [self UIConfig];
    self.dpManager = [[TuyaSmartCameraDPManager alloc] initWithDeviceId:self.deviceModel.devId];
    [self.dpManager addObserver:self];
    self.device = [TuyaSmartDevice deviceWithDeviceId:self.deviceModel.devId];
    self.deviceModel = self.device.deviceModel;

}
- (void)UIConfig{
    
    [self.view addSubview:self.qzTableView];
         [self.qzTableView mas_makeConstraints:^(MASConstraintMaker *make) {
         make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0 ));
     }];
}
-(void)exp_rightAction{
    QZHWS(weakSelf)
    AlarmTimerVC *vc = [[AlarmTimerVC alloc] init];
    vc.deviceModel = self.deviceModel;
    vc.homeModel = self.homeModel;
    vc.refresh = ^{
        [weakSelf getTimerList];
    };
    [self.navigationController pushViewController:vc animated:YES];
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

        [self.qzTableView registerClass:[AlarmTimeListCell class] forCellReuseIdentifier:QZHCELL_REUSE_TEXT];


    }
    return _qzTableView;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = indexPath.row;
    TYTimerModel *model = self.listArr[row];
    AlarmTimeListCell *cell = [tableView dequeueReusableCellWithIdentifier:QZHCELL_REUSE_TEXT];
    cell.timeLab.text = model.time;
    NSArray *weekArr = [self getweekArr:model.loops];
    cell.weekLab.text = [self getWeekday:weekArr];
    cell.statusSwitch.on = model.status;
    cell.statusSwitch.tag = row;
    [cell.statusSwitch addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    cell.itemLab.text = [NSString stringWithFormat:@"移动侦测:%@ 声音侦测:%@",[model.dps[@"134"] boolValue]?@"开启":@"关闭",[model.dps[@"139"] boolValue]?@"开启":@"关闭"];
    if (model.status) {
        cell.contentView.alpha = 1.0;
    }else{
        cell.contentView.alpha = 0.5;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
 
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        UIView *view = [[UIView alloc] init];
        UILabel *lab = [[UILabel alloc] init];
        lab.text = @"定时可能会存在30S左右的误差";
        lab.font = QZHKIT_FONT_LISTCELL_SUB_TITLE;
        lab.textColor = QZHKIT_Color_BLACK_54;
        lab.frame = CGRectMake(15, 15, QZHScreenWidth, 20);
        [view addSubview:lab];
        return view;
    }else{
        return [UIView new];
    }

}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listArr.count;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
     return 50;
}

-(void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section{
    view.tintColor = QZHKIT_COLOR_LEADBACK;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = indexPath.row;
    TYTimerModel *model = self.listArr[row];
    QZHWS(weakSelf)
    AlarmTimerVC *vc = [[AlarmTimerVC alloc] init];
    vc.deviceModel = self.deviceModel;
    vc.homeModel = self.homeModel;
    vc.timerModel = model;
    vc.refresh = ^{
        [weakSelf getTimerList];
    };
    [self.navigationController pushViewController:vc animated:YES];

}
- (BOOL)tableView:(UITableView*)tableView canEditRowAtIndexPath:(NSIndexPath*)indexPath {
    if (indexPath.section == 0) {
        return YES;
    }
    return NO;

}
//修改按钮文字
- (NSString*)tableView:(UITableView*)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath*)indexPath {

    return @"删除";

}
//删除相应方法

- (void)tableView:(UITableView*)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath*)indexPath {
    TYTimerModel *model = self.listArr[indexPath.row];
    [self.timer removeTimerWithTask:QZHTUYATIMERALARM devId:self.deviceModel.devId  timerId:model.timerId success:^{
        [[QZHHUD HUD] textHUDWithMessage:@"删除成功" afterDelay:1.0];
        [self getTimerList];
    } failure:^(NSError *error) {
        [[QZHHUD HUD] textHUDWithMessage:error.userInfo[@"NSLocalizedDescription"] afterDelay:0.5];
        
    }];
}
#pragma mark --lazy
- (NSMutableArray *)listArr{
    if (!_listArr) {
        _listArr = [NSMutableArray array];
 
    }
    return _listArr;
}



- (BOOL)isAdminOrOwner{
    if (self.homeModel.role == TYHomeRoleType_Admin ||self.homeModel.role == TYHomeRoleType_Owner) {
        return YES;
    }
    return NO;
}

- (void)getTimerList{
     self.timer = [[TuyaSmartTimer alloc] init];

    [self.timer getTimerWithTask:QZHTUYATIMERALARM devId:self.deviceModel.devId success:^(NSArray<TYTimerModel *> *list) {
        self.listArr =  [NSMutableArray arrayWithArray:list];
        [self.qzTableView reloadData];
    } failure:^(NSError *error) {
        [[QZHHUD HUD] textHUDWithMessage:error.userInfo[@"NSLocalizedDescription"] afterDelay:0.5];

    }];
}
- (NSArray *)getweekArr:(NSString *)weekday{
    NSMutableArray *week = [NSMutableArray array];
    
    for (NSInteger i = 0; i < weekday.length; i++) {
        NSRange   range =  NSMakeRange(i, 1);
        NSString *subStr = [weekday substringWithRange:range];
        [week addObject:subStr];
    }
    if (week.count > 6) {
        NSMutableArray *weekArrM = [NSMutableArray arrayWithObjects:@{@"week":@"星期日",@"select":@"0",},@{@"week":@"星期一",@"select":@"0",},@{@"week":@"星期二",@"select":@"0",},@{@"week":@"星期三",@"select":@"0",},@{@"week":@"星期四",@"select":@"0",},@{@"week":@"星期五",@"select":@"0",},@{@"week":@"星期六",@"select":@"0",}, nil];
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
         weekDay = @"每天";
     }else if(weekArr.count == 5 && ![weekArr containsObject:@"星期六"] && ![weekArr containsObject:@"星期日"]){
            weekDay = @"工作日";
     }else if(weekArr.count == 0){
         weekDay = @"仅限一次";
     }else{
         weekDay = [weekArr componentsJoinedByString:@","];
     }
    return weekDay;
}
#pragma mark -- action
- (void)valueChanged:(UISwitch *)sender{
    TYTimerModel *model = self.listArr[sender.tag];
    [self.timer updateTimerStatusWithTask:QZHTUYATIMERALARM devId:self.deviceModel.devId timerId:model.timerId status:sender.on success:^{
        [self getTimerList];
        
      } failure:^(NSError *error) {
           [[QZHHUD HUD] textHUDWithMessage:error.userInfo[@"NSLocalizedDescription"] afterDelay:0.5];
          sender.on = !sender.on;
      }];
}
@end
