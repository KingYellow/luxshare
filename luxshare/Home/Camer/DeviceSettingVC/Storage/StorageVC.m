//
//  StorageVC.m
//  luxshare
//
//  Created by 黄振 on 2020/7/17.
//  Copyright © 2020 KingYellow. All rights reserved.
//

#import "StorageVC.h"
#import "PerInfoDefaultCell.h"
#import "SettingSwitchCell.h"
#import "QZHDefaultButtonCell.h"
#import "FormatProgressView.h"

@interface StorageVC ()<UITableViewDelegate,UITableViewDataSource,TuyaSmartCameraDPObserver>
@property (strong, nonatomic)UITableView *qzTableView;

@property (strong, nonatomic)TuyaSmartCameraDPManager *dpManager;
@property (strong, nonatomic)TuyaSmartDevice *device;
@property (copy, nonatomic)NSArray *deviceArr;
@property (strong, nonatomic)FormatProgressView *progessView;
@end

@implementation StorageVC

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
    self.deviceArr = [self storageSize];
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
        [self.qzTableView registerClass:[QZHDefaultButtonCell class] forCellReuseIdentifier:QZHCELL_REUSE_DEFAULT];

    }
    return _qzTableView;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (section == 0) {

            PerInfoDefaultCell *cell = [tableView dequeueReusableCellWithIdentifier:QZHCELL_REUSE_TEXT];
            int state = [[self.dpManager valueForDP:TuyaSmartCameraBasicPIRDPName] intValue];
            if (row == 0) {
                cell.nameLab.text = @"总容量";
                cell.describeLab.text = self.deviceArr.firstObject;
            }
            if (row == 1) {
                cell.nameLab.text = @"已使用";
                cell.describeLab.text = self.deviceArr[1];

            }
            if (row == 2) {
                cell.nameLab.text = @"剩余容量";
                cell.describeLab.text = self.deviceArr[2];
            }

            cell.selectionStyle = UITableViewCellSelectionStyleNone;
           return cell;

        
    }else if(section == 1){
        
        if (row == 0) {
             SettingSwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:QZHCELL_REUSE_IMAGE];
            cell.nameLab.text = @"录像开关";
            [cell.nameLab mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(15);
            }];
            cell.switchBtn.on = [[self.dpManager valueForDP:TuyaSmartCameraSDCardRecordDPName] boolValue];
            cell.contentView.backgroundColor = QZHColorWhite;
            [cell.switchBtn addTarget:self action:@selector(valueChange:) forControlEvents:UIControlEventValueChanged];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
             return cell;
        }else{
            PerInfoDefaultCell *cell = [tableView dequeueReusableCellWithIdentifier:QZHCELL_REUSE_TEXT];
             cell.nameLab.text = @"定时";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
             cell.selectionStyle = UITableViewCellSelectionStyleNone;
             return cell;
        }
         
    }else{
        QZHDefaultButtonCell *cell = [tableView dequeueReusableCellWithIdentifier:QZHCELL_REUSE_DEFAULT];
        cell.nameLab.text = @"格式化";
        cell.nameLab.textColor = QZHKIT_Color_BLACK_54;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
 
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
        UIView *view = [[UIView alloc] init];
        UILabel *lab = [[UILabel alloc] init];

        if (section == 0) {
            lab.text = @"存储容量";

        }else if(section == 1){
            lab.text = @"存储设置";
        }
        lab.font = QZHKIT_FONT_LISTCELL_SUB_TITLE;
        lab.textColor = QZHKIT_Color_BLACK_54;
        lab.frame = CGRectMake(15, 20, QZHScreenWidth, 20);
        [view addSubview:lab];
        return view;


}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
   
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0 ) {
        return 3;
    }else if(section == 1){
       
        return 2;
    }else{
        return 1;
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 2) {
        return 20;
    }
     return 50;
}

-(void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section{
    view.tintColor = QZHKIT_COLOR_LEADBACK;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    if (section == 2) {
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"是否确认格式化" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController.view addSubview:self.progessView];
            
        }];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            
            [self.dpManager setValue:@(YES) forDP:TuyaSmartCameraSDCardFormatDPName success:^(id result) {
                
            } failure:^(NSError *error) {
                
            }];
        }];
        [alertC addAction:action];
        [alertC addAction:action1];
        [self presentViewController:alertC animated:NO completion:nil];
    }
 
}


#pragma mark -- action
- (void)valueChange:(UISwitch *) sender{
    QZHWS(weakSelf)
    //隐私
    if ([self.dpManager isSupportDP:TuyaSmartCameraSDCardRecordDPName]) {
        
        [self.dpManager setValue:@(sender.on) forDP:TuyaSmartCameraSDCardRecordDPName success:^(id result) {
            [weakSelf.qzTableView reloadData];
        } failure:^(NSError *error) {
            sender.on = !sender.on;
        }];
    }

}


- (NSArray *)storageSize{
    NSMutableArray *arr = [NSMutableArray array];
    if ([self.dpManager isSupportDP:TuyaSmartCameraSDCardStorageDPName]) {
             
        NSString *st =  [self.dpManager valueForDP:TuyaSmartCameraSDCardStorageDPName];
        NSArray *stroge = [st componentsSeparatedByString:@"|"];
        for (NSString *str in stroge) {
           NSInteger lon = [str integerValue];
            if (lon < 1024) {
                [arr addObject: [NSString stringWithFormat:@"%.2lfK",lon/1.0]];
            }else if(lon >= 1024 && lon < 1024 * 1024){
                [arr addObject: [NSString stringWithFormat:@"%.2lfM",lon/1024.0]];

            }else{
                [arr addObject: [NSString stringWithFormat:@"%.2lfG",lon/(1024.0 * 1024)]];
            }
        }
    }
    if (arr.count != 3) {
        return @[@"",@"",@""];
    }
    return arr;
}

-(FormatProgressView *)progessView{
    if (!_progessView) {
        _progessView = [[FormatProgressView alloc] init];
        _progessView.frame = self.navigationController.view.bounds;
    }
    return _progessView;
}
@end
