//
//  DeceteAlarmVC.m
//  luxshare
//
//  Created by 黄振 on 2020/7/17.
//  Copyright © 2020 KingYellow. All rights reserved.
//

#import "DeceteAlarmVC.h"
#import "PerInfoDefaultCell.h"
#import "SettingSwitchCell.h"
#import "DeviceInfoVC.h"
#import "BasicFunVC.h"


@interface DeceteAlarmVC ()<UITableViewDelegate,UITableViewDataSource,TuyaSmartCameraDPObserver>
@property (strong, nonatomic)UITableView *qzTableView;

@property (strong, nonatomic)TuyaSmartCameraDPManager *dpManager;
@property (strong, nonatomic)TuyaSmartDevice *device;
@property (copy, nonatomic)NSArray *deviceUpdateArr;
@end

@implementation DeceteAlarmVC

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

            PerInfoDefaultCell *cell = [tableView dequeueReusableCellWithIdentifier:QZHCELL_REUSE_TEXT];
            cell.nameLab.text = @"PIR开关";
            int state = [[self.dpManager valueForDP:TuyaSmartCameraBasicPIRDPName] intValue];
            if (state == 0) {
                cell.describeLab.text = @"关闭";
            }
            if (state == 1) {
                cell.describeLab.text = @"低灵敏度";
            }
            if (state == 2) {
                cell.describeLab.text = @"中灵敏度";
            }
            if (state == 3) {
                cell.describeLab.text = @"高灵敏度";
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

           return cell;

        
    }else if(section == 1){
        
        if (row == 0) {
             SettingSwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:QZHCELL_REUSE_IMAGE];
            cell.nameLab.text = QZHLoaclString(@"setting_decetecCry");
            [cell.nameLab mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(15);
            }];
            cell.switchBtn.on = [[self.dpManager valueForDP:TuyaSmartCameraDecibelDetectDPName] boolValue];
            cell.contentView.backgroundColor = QZHColorWhite;
            [cell.switchBtn addTarget:self action:@selector(valueChange:) forControlEvents:UIControlEventValueChanged];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
             return cell;
        }else{
            PerInfoDefaultCell *cell = [tableView dequeueReusableCellWithIdentifier:QZHCELL_REUSE_TEXT];
             cell.nameLab.text = @"哭声检测灵敏度";
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
         
    }else{
        PerInfoDefaultCell *cell = [tableView dequeueReusableCellWithIdentifier:QZHCELL_REUSE_TEXT];
        if (row == 0) {
            cell.nameLab.text = @"定时";
        }else{
            cell.nameLab.text = @"报警间隔";
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
   
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0 ) {
        return 1;
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
        if (row == 0) {
            [self creatPIRActionSheet];
        }
    }
    if (section == 1) {
        if (row == 1) {
            [self creatDecibelActionSheet];
        }
    }
    if (section == 2) {


    }
}

#pragma mark -- action
- (void)valueChange:(UISwitch *) sender{
    QZHWS(weakSelf)
    //隐私
    if ([self.dpManager isSupportDP:TuyaSmartCameraDecibelDetectDPName]) {
        
        [self.dpManager setValue:@(sender.on) forDP:TuyaSmartCameraDecibelDetectDPName success:^(id result) {
            [weakSelf.qzTableView reloadData];
        } failure:^(NSError *error) {
            sender.on = !sender.on;
            [[QZHHUD HUD] textHUDWithMessage:error.userInfo[@"NSLocalizedDescription"] afterDelay:0.5];

        }];
    }

}

#pragma mark -- PIR

-(void)creatPIRActionSheet{

    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"PIR开关" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    /*
     typedef NS_ENUM(NSInteger, UIAlertActionStyle) {
     UIAlertActionStyleDefault = 0,
     UIAlertActionStyleCancel,         取消按钮
     UIAlertActionStyleDestructive     破坏性按钮，比如：“删除”，字体颜色是红色的
     } NS_ENUM_AVAILABLE_IOS(8_0);
     
     */
    // 创建action，这里action1只是方便编写，以后再编程的过程中还是以命名规范为主
    QZHWS(weakSelf)
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"关闭" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ([self.dpManager isSupportDP:TuyaSmartCameraBasicPIRDPName]) {
            
            [self.dpManager setValue:@"0" forDP:TuyaSmartCameraBasicPIRDPName success:^(id result) {
                [weakSelf.qzTableView reloadData];
            } failure:^(NSError *error) {
               [[QZHHUD HUD] textHUDWithMessage:error.userInfo[@"NSLocalizedDescription"] afterDelay:0.5];
            }];
        }
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"低灵敏度" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
          if ([self.dpManager isSupportDP:TuyaSmartCameraBasicPIRDPName]) {
              
              [self.dpManager setValue:@"1" forDP:TuyaSmartCameraBasicPIRDPName success:^(id result) {
                  [weakSelf.qzTableView reloadData];
              } failure:^(NSError *error) {
                 [[QZHHUD HUD] textHUDWithMessage:error.userInfo[@"NSLocalizedDescription"] afterDelay:0.5];
              }];
          }
    }];
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"中灵敏度" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ([self.dpManager isSupportDP:TuyaSmartCameraBasicPIRDPName]) {
            
            [self.dpManager setValue:@"2" forDP:TuyaSmartCameraBasicPIRDPName success:^(id result) {
                [weakSelf.qzTableView reloadData];
            } failure:^(NSError *error) {
               [[QZHHUD HUD] textHUDWithMessage:error.userInfo[@"NSLocalizedDescription"] afterDelay:0.5];
            }];
        }
    }];
    UIAlertAction *action4 = [UIAlertAction actionWithTitle:@"高灵敏度" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ([self.dpManager isSupportDP:TuyaSmartCameraBasicPIRDPName]) {
            
            [self.dpManager setValue:@"3" forDP:TuyaSmartCameraBasicPIRDPName success:^(id result) {
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
    [actionSheet addAction:action4];
    [actionSheet addAction:action5];


    //相当于之前的[actionSheet show];
    [self presentViewController:actionSheet animated:YES completion:nil];
}

#pragma mark -- decibel

-(void)creatDecibelActionSheet{

    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"哭声检测灵敏度" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    /*
     typedef NS_ENUM(NSInteger, UIAlertActionStyle) {
     UIAlertActionStyleDefault = 0,
     UIAlertActionStyleCancel,         取消按钮
     UIAlertActionStyleDestructive     破坏性按钮，比如：“删除”，字体颜色是红色的
     } NS_ENUM_AVAILABLE_IOS(8_0);
     
     */
    // 创建action，这里action1只是方便编写，以后再编程的过程中还是以命名规范为主
    QZHWS(weakSelf)

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

@end
