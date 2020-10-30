//
//  ElectricManageVC.m
//  luxshare
//
//  Created by 黄振 on 2020/7/20.
//  Copyright © 2020 KingYellow. All rights reserved.
//

#import "ElectricManageVC.h"
#import "PerInfoDefaultCell.h"
#import "ElectricManageCell.h"
#import "BRPickerView.h"



@interface ElectricManageVC ()<UITableViewDelegate,UITableViewDataSource,TuyaSmartCameraDPObserver>
@property (strong, nonatomic)UITableView *qzTableView;

@property (strong, nonatomic)TuyaSmartCameraDPManager *dpManager;
@property (strong, nonatomic)TuyaSmartDevice *device;
@property (strong, nonatomic)NSMutableArray *numbrArr;
@property (strong, nonatomic)NSString *stateStr;
@end

@implementation ElectricManageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initConfig];
}
- (void)initConfig{
    self.view.backgroundColor = QZHKIT_COLOR_LEADBACK;
    self.navigationItem.title = QZHLoaclString(@"setting_electricManage");
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

        [self.qzTableView registerClass:[PerInfoDefaultCell class] forCellReuseIdentifier:QZHCELL_REUSE_TEXT];
        [self.qzTableView registerClass:[ElectricManageCell class] forCellReuseIdentifier:QZHCELL_REUSE_IMAGE];
    }
    return _qzTableView;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (section == 0) {

        PerInfoDefaultCell *cell = [tableView dequeueReusableCellWithIdentifier:QZHCELL_REUSE_TEXT];
        if (row == 0) {
            cell.nameLab.text = QZHLoaclString(@"electricHas");
            int state = [[self.dpManager valueForDP:TuyaSmartCameraWirelessElectricityDPName] intValue];
            cell.describeLab.text = [[NSString stringWithFormat:@"%d",state] stringByAppendingString:@"%"];

        }else{
            cell.nameLab.text = QZHLoaclString(@"powerType");
            int state = [[self.dpManager valueForDP:TuyaSmartCameraWirelessPowerModeDPName] intValue];
            if (!state) {
                cell.describeLab.text = QZHLoaclString(@"batteryPower");
            }else{
                cell.describeLab.text = QZHLoaclString(@"linePower");
            }

        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;

        
    }else{
        ElectricManageCell *cell = [tableView dequeueReusableCellWithIdentifier:QZHCELL_REUSE_IMAGE];
        cell.nameLab.text = QZHLoaclString(@"setlowPowerNumber");
        cell.describeLab.text = QZHLoaclString(@"setlowPowerRange");
        int state = [[self.dpManager valueForDP:TuyaSmartCameraWirelessLowpowerDPName] intValue];
        self.stateStr = [NSString stringWithFormat:@"%d",state];
        cell.statusLab.text = [[NSString stringWithFormat:@"%d",state] stringByAppendingString:@"%"];

        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
 
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    return view;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
   
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0 ) {
        return 2;
    }else {
        return 1;
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 50;
    }else{
        return 80;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

     return 30;
}

-(void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section{
    view.tintColor = QZHKIT_COLOR_LEADBACK;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger section = indexPath.section;
    if (section == 1) {
        QZHWS(weakSelf)
        BRStringPickerView *pick = [[BRStringPickerView alloc] initWithPickerMode:BRStringPickerComponentSingle];
        pick.dataSourceArr = self.numbrArr;
        pick.title = QZHLoaclString(@"setlowPowerRange");
        pick.selectValue = self.stateStr;
        pick.resultModelBlock = ^(BRResultModel * _Nullable resultModel) {
            if ([self.dpManager isSupportDP:TuyaSmartCameraWirelessLowpowerDPName]) {
                 
                int a = [resultModel.value intValue];
                 [self.dpManager setValue:@(a)  forDP:TuyaSmartCameraWirelessLowpowerDPName success:^(id result) {
                     [weakSelf.qzTableView reloadData];
                 } failure:^(NSError *error) {
                    [[QZHHUD HUD] textHUDWithMessage:error.userInfo[@"NSLocalizedDescription"] afterDelay:0.5];
                 }];
             }
        };
        [pick show];
    }
}
-(NSMutableArray *)numbrArr{
    if (!_numbrArr) {
        _numbrArr = [NSMutableArray array];
        for (int i = 10; i < 51; i++) {
            [_numbrArr addObject:[NSString stringWithFormat:@"%d",i]];
        }
    }
    return _numbrArr;
}

@end
