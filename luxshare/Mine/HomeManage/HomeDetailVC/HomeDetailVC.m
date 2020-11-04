//
//  HomeDetailVC.m
//  luxshare
//
//  Created by 黄振 on 2020/6/29.
//  Copyright © 2020 KingYellow. All rights reserved.
//

#import "HomeDetailVC.h"
#import "PerInfoDefaultCell.h"
#import "QZHDefaultButtonCell.h"
#import "MineHeaderCell.h"
#import "RoomManageVC.h"
#import "AddMemberVC.h"
#import "MemberDetailVC.h"


@interface HomeDetailVC ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic)UITableView *qzTableView;
@property (strong, nonatomic)NSMutableArray *listArr;
@property (strong, nonatomic)NSMutableArray *memberArr;
@property (strong, nonatomic)TuyaSmartHome *home;
@end

@implementation HomeDetailVC
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getHomeDetailInfo];
    [self getHomeMember];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initConfig];
}
- (void)initConfig{
    self.view.backgroundColor = QZHKIT_COLOR_LEADBACK;
    self.navigationItem.title = QZHLoaclString(@"home_detail");
    [self exp_navigationBarTextWithColor:QZHKIT_COLOR_NAVIBAR_TITLE font:QZHKIT_FONT_TABBAR_TITLE];
    [self exp_navigationBarColor:QZHKIT_COLOR_NAVIBAR_BACK hiddenShadow:NO];
    [self UIConfig];

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
        [self.qzTableView registerClass:[MineHeaderCell class] forCellReuseIdentifier:QZHCELL_REUSE_IMAGE];
        [self.qzTableView registerClass:[QZHDefaultButtonCell class] forCellReuseIdentifier:QZHCELL_REUSE_DEFAULT];
    }
    return _qzTableView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    bool editable = [self isAdminOrOwner];
    if (section == 0) {
        
        PerInfoDefaultCell *cell = [tableView dequeueReusableCellWithIdentifier:QZHCELL_REUSE_TEXT];
        if (row == 0) {
            cell.nameLab.text = QZHLoaclString(@"home_name");
            cell.describeLab.text = self.homeModel.name;
        }else if(row == 1){
            cell.nameLab.text = QZHLoaclString(@"room_manage");
            cell.describeLab.text = [NSString stringWithFormat:@"%lu",(unsigned long)self.home.roomList.count];
        }else{
            cell.nameLab.text = QZHLoaclString(@"home_location");
            cell.describeLab.text = self.homeModel.geoName;
        }
        if (editable) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    }else if(section == 1){
        if (row < self.memberArr.count) {
            MineHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:QZHCELL_REUSE_IMAGE];
            TuyaSmartHomeMemberModel *model = self.memberArr[row];
            cell.nameLab.text = model.name;
            [cell.IMGView exp_loadImageUrlString:model.headPic placeholder:QZHICON_HEAD_PLACEHOLDER];
            if (model.role == TYHomeRoleType_Custom) {
                cell.tagLab.text = QZHLoaclString(@"TYHomeRoleType_Custom");

            }else if(model.role == TYHomeRoleType_Member){
                cell.tagLab.text = QZHLoaclString(@"TYHomeRoleType_Member");
            }else if(model.role == TYHomeRoleType_Admin){
                cell.tagLab.text = QZHLoaclString(@"TYHomeRoleType_Admin");
            }else if(model.role == TYHomeRoleType_Owner){
                cell.tagLab.text = QZHLoaclString(@"TYHomeRoleType_Owner");
            }else{
                cell.tagLab.text = @"无效";
            }
            if (model.dealStatus == TYHomeStatusPending) {
                cell.describeLab.text = QZHLoaclString(@"home_memberstatus_pending");
            }else if (model.dealStatus == TYHomeStatusReject) {
                cell.describeLab.text = QZHLoaclString(@"home_memberstatus_reject");
            }else{
                cell.describeLab.text = model.userName;
            }
            
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else{
            QZHDefaultButtonCell *cell = [tableView dequeueReusableCellWithIdentifier:QZHCELL_REUSE_DEFAULT];
            cell.nameLab.text = QZHLoaclString(@"home_addHomeMember");
            [cell.nameLab mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(20);
                make.centerY.mas_equalTo(cell);
            }];
            cell.nameLab.textColor = QZHKIT_COLOR_SKIN;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        
    }else{
        QZHDefaultButtonCell *cell = [tableView dequeueReusableCellWithIdentifier:QZHCELL_REUSE_DEFAULT];
          cell.nameLab.text = QZHLoaclString(@"home_removeHome");
        cell.nameLab.textColor = QZHKIT_Color_BLACK_26;
          cell.selectionStyle = UITableViewCellSelectionStyleNone;
          return cell;
    }
 
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 1) {
            UIView *view = [[UIView alloc] init];
        UILabel *lab = [[UILabel alloc] init];
        lab.text = QZHLoaclString(@"home_homeMember");
        lab.font = QZHKIT_FONT_LISTCELL_SUB_TITLE;
        lab.textColor = QZHKIT_Color_BLACK_54;
        lab.frame = CGRectMake(15, 30, QZHScreenWidth, 20);
        [view addSubview:lab];
        return view;
    }else{
        return [UIView new];
    }

}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if ([self isAdminOrOwner]) {
        return 3;
    }
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0 ) {
        return 3;
    }else if(section == 1){
        if ([self isAdminOrOwner]) {
            return self.memberArr.count + 1;
        }
        return self.memberArr.count;
    }else{
        return 1;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1 && indexPath.row < self.memberArr.count) {
        return 90;
    }
    return 50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
   
    if (section == 1) {
        return 60;
    }
     return 30;
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section{
    view.tintColor = QZHKIT_COLOR_LEADBACK;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (![self isAdminOrOwner] && indexPath.section == 0) {
        return;
    }
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    QZHWS(weakSelf)
    if (section == 0 && row == 0) {
     UIAlertController *alert = [UIAlertController alertWithTextfieldTitle:QZHLoaclString(@"home_editHomeName") originaltext:self.homeModel.name textblock:^(NSString * _Nonnull fieldtext) {
         [weakSelf updateHomeInfo:fieldtext loca:nil];
        }];
        [self presentViewController:alert animated:YES completion:nil];
    }
    if (section == 0 && row == 1) {
        RoomManageVC *vc = [[RoomManageVC alloc] init];
        vc.homeModel = self.homeModel;
        [self.navigationController pushViewController:[vc exp_hiddenTabBar] animated:YES];
    }
    if (section == 0 && row == 2) {
     UIAlertController *alert = [UIAlertController alertWithTextfieldTitle:QZHLoaclString(@"home_editHomeLocation") originaltext:self.homeModel.geoName textblock:^(NSString * _Nonnull fieldtext) {
         [weakSelf updateHomeInfo:nil loca:fieldtext];
        }];
        [self presentViewController:alert animated:YES completion:nil];
    }

    if (section == 1) {
        if (row == self.memberArr.count) {
            AddMemberVC *vc = [[AddMemberVC alloc] init];
            vc.homeModel = self.homeModel;
            [self.navigationController pushViewController:[vc exp_hiddenTabBar] animated:YES];
        }else{
            MemberDetailVC *vc = [[MemberDetailVC alloc] init];
            vc.homeModel = self.homeModel;
            vc.memberModel = self.memberArr[row];
            vc.disHomeBlock = ^{
                [weakSelf.navigationController popViewControllerAnimated:NO];
            };
            [self.navigationController pushViewController:vc animated:YES];
        }

    }
    if (section == 2) {
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:QZHLoaclString(@"tip") message:QZHLoaclString(@"deletedeviceWhenDeleteFamily") preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:QZHLoaclString(@"cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:QZHLoaclString(@"delete") style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [self dismissHome];

            
        }];
        [alertC addAction:action];
        [alertC addAction:action1];
        [self presentViewController:alertC animated:NO completion:nil];
    }
}

#pragma mark --lazy
- (NSMutableArray *)listArr{
    if (!_listArr) {
        _listArr = [NSMutableArray array];
 
    }
    return _listArr;
}
- (NSMutableArray *)memberArr{
    if (!_memberArr) {
        _memberArr = [NSMutableArray array];
 
    }
    return _memberArr;
}
- (TuyaSmartHome *)home{
    if (!_home) {
        self.home =[TuyaSmartHome homeWithHomeId:self.homeModel.homeId];
    }
    return _home;
}

#pragma mark -- action
- (void)getHomeDetailInfo {
   
    [self.home getHomeDetailWithSuccess:^(TuyaSmartHomeModel *homeModel) {
        // homeModel 家庭信息
       [self.qzTableView reloadData];
        NSLog(@"get home detail success");
    } failure:^(NSError *error) {
           [[QZHHUD HUD] textHUDWithMessage:error.userInfo[@"NSLocalizedDescription"] afterDelay:0.5];
    }];
}

- (void)updateHomeInfo:(NSString *)name loca:(NSString *)geoname{
    QZHWS(weakSelf)
    TuyaSmartHome *home = [TuyaSmartHome homeWithHomeId:self.homeModel.homeId];
    NSString *hname =self.homeModel.name;
    NSString *gname = self.homeModel.geoName;
    if (name) {
        hname = name;
        self.homeModel.name = name;
    }
    if (geoname) {
        gname = geoname;
        self.homeModel.geoName = geoname;
    }
    [home updateHomeInfoWithName:hname geoName:gname latitude:0 longitude:0 success:^{
        [[QZHHUD HUD] textHUDWithMessage:QZHLoaclString(@"handleSuccess") afterDelay:0.5];
 
        [weakSelf.qzTableView reloadData];
        NSLog(@"update home info success");
    } failure:^(NSError *error) {
        [[QZHHUD HUD] textHUDWithMessage:error.userInfo[@"NSLocalizedDescription"] afterDelay:0.5];
    }];
    
  
}
- (void)getHomeMember{
    [self.home getHomeMemberListWithSuccess:^(NSArray<TuyaSmartHomeMemberModel *> *memberList) {
        [self.memberArr removeAllObjects];
        [self.memberArr addObjectsFromArray:memberList];
        [self.qzTableView reloadData];
    } failure:^(NSError *error) {
        [[QZHHUD HUD] textHUDWithMessage:error.userInfo[@"NSLocalizedDescription"] afterDelay:0.5];
    }];
}
//// 家庭下新增房间代理回调
//- (void)home:(TuyaSmartHome *)home didAddRoom:(TuyaSmartRoomModel *)room {
//      [self.qzTableView reloadData];
//}
#pragma mark -- p判断是否是 管理员或者所有者

- (BOOL)isAdminOrOwner{
    if (self.homeModel.role == TYHomeRoleType_Admin ||self.homeModel.role == TYHomeRoleType_Owner) {
        return YES;
    }
    return NO;
}

- (void)dismissHome {
    QZHWS(weakSelf)
    [self.home dismissHomeWithSuccess:^() {
        [[QZHHUD HUD] textHUDWithMessage:QZHLoaclString(@"handleSuccess") afterDelay:0.5];
        [weakSelf getHomeList];
        
    } failure:^(NSError *error) {
        [[QZHHUD HUD] textHUDWithMessage:error.userInfo[@"NSLocalizedDescription"] afterDelay:0.5];
        
    }];
}

- (void)getHomeList {
   TuyaSmartHomeManager *magager = [TuyaSmartHomeManager new];
    [magager getHomeListWithSuccess:^(NSArray<TuyaSmartHomeModel *> *homes) {
        if (homes.count == 0) {
            [self addDefaultHome];
        }else{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
                
            });
        }

    } failure:^(NSError *error) {
        [[QZHHUD HUD] textHUDWithMessage:error.userInfo[@"NSLocalizedDescription"] afterDelay:0.5];
        
    }];
}
- (void)addDefaultHome{
    QZHWS(weakSelf)
    [[[TuyaSmartHomeManager alloc] init] addHomeWithName:@"我的家" geoName:@"" rooms:@[] latitude:0 longitude:0 success:^(long long result) {
        [weakSelf.navigationController popViewControllerAnimated:YES];

    } failure:^(NSError *error) {
           [[QZHHUD HUD] textHUDWithMessage:error.userInfo[@"NSLocalizedDescription"] afterDelay:0.5];
    }];
}
@end
