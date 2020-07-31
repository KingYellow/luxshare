//
//  MessageSettingVC.m
//  luxshare
//
//  Created by 黄振 on 2020/7/27.
//  Copyright © 2020 KingYellow. All rights reserved.
//

#import "MessageSettingVC.h"
#import "SettingDefaultCell.h"
#import "SettingSwitchCell.h"
#import "MessageTimeVC.h"

@interface MessageSettingVC ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic)UITableView *qzTableView;
@property (assign, nonatomic)BOOL MessageStatus;
@property (assign, nonatomic)BOOL warningStatus;
@property (assign, nonatomic)BOOL homeStatus;
@property (assign, nonatomic)BOOL notificeStatus;
@property (strong, nonatomic)NSString *weekDays;
@end

@implementation MessageSettingVC
- (void)viewWillAppear:(BOOL)animated{
    [self getMessagePushStatus];
    [self getWeekDays];
}
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
    if (section == 1) {
        if (row == 1) {
            SettingDefaultCell *cell = [tableView dequeueReusableCellWithIdentifier:QZHCELL_REUSE_TEXT];
            cell.nameLab.text = @"按时段免打扰";
            cell.radioPosition = 0;
            cell.tagLab.text = self.weekDays;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;

        }else{
            SettingSwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:QZHCELL_REUSE_IMAGE];
            if (row == 0) {
                cell.nameLab.text = @"告警";
                cell.switchBtn.tag = 1;
                cell.switchBtn.on = self.warningStatus;
                cell.radioPosition = -1;
            }else if(row == 2){
                cell.nameLab.text = @"家庭";
                cell.switchBtn.tag = 2;
                cell.radioPosition = 0;
                cell.switchBtn.on = self.homeStatus;


            }else{
                cell.nameLab.text = @"通知";
                cell.switchBtn.tag = 3;
                cell.radioPosition = 1;
                cell.switchBtn.on = self.notificeStatus;

            }
            [cell.switchBtn addTarget:self action:@selector(valueChange:) forControlEvents:UIControlEventValueChanged];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;

            return cell;

        }
        
    }else{
        SettingSwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:QZHCELL_REUSE_IMAGE];
        cell.nameLab.text = @"启用消息推送";
        cell.radioPosition = 2;
        cell.switchBtn.on = self.MessageStatus;
        cell.switchBtn.tag = 0;
        [cell.switchBtn addTarget:self action:@selector(valueChange:) forControlEvents:UIControlEventValueChanged];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
         return cell;
       
    }
 
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    return [UIView new];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.MessageStatus) {
        return 2;
    }
   
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0 ) {
        return 1;
    }else{
        return 4;
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (!self.warningStatus) {
        if (indexPath.section == 1 && indexPath.row == 1) {
            return 0;
        }
    }
    return 50;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
   
    return 25;
}

-(void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section{
    view.tintColor = QZHKIT_COLOR_LEADBACK;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;

    if (section == 1) {
        
        if (row == 1) {
            MessageTimeVC *vc = [[MessageTimeVC alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
        
    }
}

#pragma mark --lazy

#pragma mark -- action
- (void)valueChange:(UISwitch *) sender{
    QZHWS(weakSelf)
    if (sender.tag == 0) {
        [[TuyaSmartSDK sharedInstance] setPushStatusWithStatus:sender.on  success:^{
            // 设置成功
            
            [weakSelf getMessagePushStatus];
        } failure:^(NSError *error) {
            sender.on = !sender.on;
        }];

    }else if (sender.tag == 1) {
        [[TuyaSmartSDK sharedInstance] setDevicePushStatusWithStauts:sender.on  success:^{
            [weakSelf getSubMessageStatus];
            // 设置成功
        } failure:^(NSError *error) {
            sender.on = !sender.on;

        }];

    }else if (sender.tag == 2) {
        [[TuyaSmartSDK sharedInstance] setFamilyPushStatusWithStauts:sender.on  success:^{
            // 设置成功
            [weakSelf getSubMessageStatus];

        } failure:^(NSError *error) {
            sender.on = !sender.on;

        }];

    }else if (sender.tag == 3) {
        [[TuyaSmartSDK sharedInstance] setNoticePushStatusWithStauts:sender.on  success:^{
            // 设置成功
            [weakSelf getSubMessageStatus];

        } failure:^(NSError *error) {
            sender.on = !sender.on;

        }];
    }else{
    }
}

- (void)getMessagePushStatus{
    QZHWS(weakSelf)
    [[TuyaSmartSDK sharedInstance] getPushStatusWithSuccess:^(BOOL result) {
        // 当 result == YES 时，表示推送开关开启
        weakSelf.MessageStatus = result;

        if (result) {
            [weakSelf getSubMessageStatus];
        }else{
            [weakSelf.qzTableView reloadData];
        }

    } failure:^(NSError *error) {

    }];
}
- (void)getSubMessageStatus{
    QZHWS(weakSelf)
    
    dispatch_group_t downloadGroup = dispatch_group_create();
    dispatch_group_enter(downloadGroup);

    //设备警告类
    [[TuyaSmartSDK sharedInstance] getDevicePushStatusWithSuccess:^(BOOL result) {
      // 当 result == YES 时，表示接收设备告警消息推送
        weakSelf.warningStatus = result;
        dispatch_group_leave(downloadGroup);

    } failure:^(NSError *error) {
        dispatch_group_leave(downloadGroup);

    }];
    dispatch_group_enter(downloadGroup);

    //家庭通知类
    [[TuyaSmartSDK sharedInstance] getFamilyPushStatusWithSuccess:^(BOOL result) {
        // 当 result == YES 时，表示接收家庭消息推送
        weakSelf.homeStatus = result;
        dispatch_group_leave(downloadGroup);

    } failure:^(NSError *error) {
        dispatch_group_leave(downloadGroup);

    }];
    //消息通知类
    dispatch_group_enter(downloadGroup);

    [[TuyaSmartSDK sharedInstance] getNoticePushStatusWithSuccess:^(BOOL result) {
        // 当 result == YES 时，表示接收通知消息推送
        weakSelf.notificeStatus = result;
        dispatch_group_leave(downloadGroup);

    } failure:^(NSError *error) {
        dispatch_group_leave(downloadGroup);

    }];
    
    dispatch_group_notify(downloadGroup, dispatch_get_main_queue(), ^{
        [weakSelf.qzTableView reloadData];
    });
}

- (void)getWeekDays{
    NSMutableArray *weekArr = [NSMutableArray array];
    NSMutableArray *listArr = [NSMutableArray arrayWithArray:[QZHDataHelper readValueForKey:@"weekDays"]];
    for (NSDictionary *dic in listArr) {
        if ([dic[@"select"] boolValue]) {
            [weekArr addObject:dic[@"week"]];
        }
    }
    if (weekArr.count == 7) {
        self.weekDays = @"每天";
    }else if(weekArr.count == 5 && ![weekArr containsObject:@"星期六"] && ![weekArr containsObject:@"星期日"]){
        self.weekDays = @"工作日";
    }else if(weekArr.count == 0){
        self.weekDays = @"永不";
    }else{
        self.weekDays = [weekArr componentsJoinedByString:@","];
    }
}

@end
