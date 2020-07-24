//
//  BasicFunVC.m
//  luxshare
//
//  Created by 黄振 on 2020/7/17.
//  Copyright © 2020 KingYellow. All rights reserved.
//

#import "BasicFunVC.h"
#import "SettingDefaultCell.h"
#import "SettingSwitchCell.h"
#import "DeviceInfoVC.h"
#import "TalkTypeVC.h"


@interface BasicFunVC ()<UITableViewDelegate,UITableViewDataSource,TuyaSmartCameraDPObserver>
@property (strong, nonatomic)UITableView *qzTableView;

@property (strong, nonatomic)TuyaSmartCameraDPManager *dpManager;
@property (strong, nonatomic)TuyaSmartDevice *device;
@end

@implementation BasicFunVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initConfig];
}
- (void)initConfig{
    self.view.backgroundColor = QZHKIT_COLOR_LEADBACK;
    self.navigationItem.title = QZHLoaclString(@"setting_basicFun");
    [self exp_navigationBarTextWithColor:QZHKIT_COLOR_NAVIBAR_TITLE font:QZHKIT_FONT_TABBAR_TITLE];
    [self exp_navigationBarColor:QZHKIT_COLOR_NAVIBAR_BACK hiddenShadow:NO];
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
    NSInteger row = indexPath.row;
        if (row == 0) {
            SettingSwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:QZHCELL_REUSE_IMAGE];
            cell.nameLab.text = @"状态指示灯";
            cell.radioPosition = -1;
            cell.switchBtn.tag = 0;

            cell.switchBtn.on =  [[self.dpManager valueForDP:TuyaSmartCameraBasicIndicatorDPName] boolValue];
            [cell.switchBtn addTarget:self action:@selector(valueChange:) forControlEvents:UIControlEventValueChanged];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;

            return cell;
        }else if (row == 1) {
                  SettingSwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:QZHCELL_REUSE_IMAGE];
                  cell.nameLab.text = @"时间水印";
                  cell.radioPosition = 0;
                  cell.switchBtn.tag = 1;
                  cell.switchBtn.on =  [[self.dpManager valueForDP:TuyaSmartCameraBasicOSDDPName] boolValue];
                  [cell.switchBtn addTarget:self action:@selector(valueChange:) forControlEvents:UIControlEventValueChanged];
                  cell.selectionStyle = UITableViewCellSelectionStyleNone;

                  return cell;
        }else{
            
            SettingDefaultCell *cell = [tableView dequeueReusableCellWithIdentifier:QZHCELL_REUSE_TEXT];
            cell.nameLab.text = @"对讲方式";
            cell.radioPosition = 1;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
 
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}
-(void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section{
    view.tintColor = QZHKIT_COLOR_LEADBACK;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = indexPath.row;
    if (row == 0) {
        DeviceInfoVC *vc = [[DeviceInfoVC alloc] init];
        vc.deviceModel = self.deviceModel;
        vc.homeModel = self.homeModel;
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (row == 2) {
        TalkTypeVC *vc = [[TalkTypeVC alloc] init];
        vc.deviceModel = self.deviceModel;
        vc.homeModel = self.homeModel;
        [self.navigationController pushViewController:vc animated:YES];
    }

}

#pragma mark -- action
- (void)valueChange:(UISwitch *) sender{
    QZHWS(weakSelf)
    if (sender.tag == 0) {
        //状态指示灯
        if ([self.dpManager isSupportDP:TuyaSmartCameraBasicIndicatorDPName]) {
            
            [self.dpManager setValue:@(sender.on) forDP:TuyaSmartCameraBasicIndicatorDPName success:^(id result) {
                [weakSelf.qzTableView reloadData];
            } failure:^(NSError *error) {
                sender.on = !sender.on;
            }];
        }
    }else{
        //水印
        if ([self.dpManager isSupportDP:TuyaSmartCameraBasicOSDDPName]) {
                 
                 [self.dpManager setValue:@(sender.on) forDP:TuyaSmartCameraBasicOSDDPName success:^(id result) {
                     [weakSelf.qzTableView reloadData];
                 } failure:^(NSError *error) {
                     sender.on = !sender.on;
                 }];
             }
    }
}

#pragma mark - TuyaSmartCameraDPObserver
- (void)cameraDPDidUpdate:(TuyaSmartCameraDPManager *)manager dps:(NSDictionary *)dpsData {
    // 如果变化的功能点中包含时间水印开关的功能点
    if ([dpsData objectForKey:TuyaSmartCameraBasicOSDDPName]) {
        BOOL res = [[dpsData objectForKey:TuyaSmartCameraBasicOSDDPName] boolValue];
    }
}

@end
