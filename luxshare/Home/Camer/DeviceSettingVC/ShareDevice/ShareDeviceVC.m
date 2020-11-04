//
//  ShareDeviceVC.m
//  luxshare
//
//  Created by 黄振 on 2020/7/22.
//  Copyright © 2020 KingYellow. All rights reserved.
//

#import "ShareDeviceVC.h"
#import "QZHDefaultButtonCell.h"
#import "MineHeaderCell.h"
#import "MemberDetailVC.h"
#import "AddSharerVC.h"


@interface ShareDeviceVC ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic)UITableView *qzTableView;
@property (strong, nonatomic)NSArray *memberArr;
@property (strong, nonatomic)TuyaSmartHome *home;
@property (strong, nonatomic)TuyaSmartHomeManager *homeManager;
@property (strong, nonatomic)TuyaSmartHomeDeviceShare *deviceShare;

@end

@implementation ShareDeviceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initConfig];
    self.homeManager = [TuyaSmartHomeManager new];
    [self getReceiveMemberList];
}
- (void)initConfig{
    self.view.backgroundColor = QZHKIT_COLOR_LEADBACK;
    self.navigationItem.title = QZHLoaclString(@"share_shareMember");
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
- (UITableView *)qzTableView{
    if (!_qzTableView) {
        _qzTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [_qzTableView exp_tableViewDefault];
        self.qzTableView.backgroundColor = QZHKIT_COLOR_LEADBACK;
        self.qzTableView.separatorStyle = UITableViewCellSeparatorStyleNone;

        _qzTableView.delegate = self;
        _qzTableView.dataSource = self;

        [self.qzTableView registerClass:[MineHeaderCell class] forCellReuseIdentifier:QZHCELL_REUSE_IMAGE];
        [self.qzTableView registerClass:[QZHDefaultButtonCell class] forCellReuseIdentifier:QZHCELL_REUSE_DEFAULT];
    }
    return _qzTableView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (section == 0) {
        
        MineHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:QZHCELL_REUSE_IMAGE];
        TuyaSmartShareMemberModel *model = self.memberArr[row];
        cell.nameLab.text = model.nickName;
        cell.describeLab.text = model.userName;
        [cell.IMGView exp_loadImageUrlString:model.iconUrl placeholder:QZHICON_HEAD_PLACEHOLDER];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
       
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;

        
    }else{
        QZHDefaultButtonCell *cell = [tableView dequeueReusableCellWithIdentifier:QZHCELL_REUSE_DEFAULT];
          cell.nameLab.text = QZHLoaclString(@"share_addShareMember");
        cell.nameLab.textColor = QZHKIT_COLOR_SKIN;
          cell.selectionStyle = UITableViewCellSelectionStyleNone;
          return cell;
    }
 
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

        return [UIView new];
    

}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if ([self isAdminOrOwner]) {
        return 2;
    }
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0 ) {
        return self.memberArr.count;
    }else{
        return 1;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 90;
    }
    return 60;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

     return 30;
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section{
    view.tintColor = QZHKIT_COLOR_LEADBACK;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        AddSharerVC *VC = [[AddSharerVC alloc] init];
        VC.deviceModel = self.deviceModel;
        VC.homeModel = self.homeModel;
        QZHWS(weakSelf)
        VC.refresh = ^{
            [weakSelf getReceiveMemberList];
        };
        [self.navigationController pushViewController:VC animated:YES];
    }
}

- (BOOL)tableView:(UITableView*)tableView canEditRowAtIndexPath:(NSIndexPath*)indexPath {
    if (indexPath.section == 0) {
        return YES;
    }
    return NO;

}
//修改按钮文字
- (NSString*)tableView:(UITableView*)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath*)indexPath {

    return QZHLoaclString(@"delete");

}
//删除相应方法

- (void)tableView:(UITableView*)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath*)indexPath {
    TuyaSmartShareMemberModel *model = self.memberArr[indexPath.row];
     self.deviceShare  = [[TuyaSmartHomeDeviceShare alloc] init];
    [self.deviceShare removeDeviceShareWithMemberId:model.memberId devId:self.deviceModel.devId success:^{

        [self getReceiveMemberList];
    } failure:^(NSError *error) {

        [[QZHHUD HUD] textHUDWithMessage:error.userInfo[@"NSLocalizedDescription"] afterDelay:0.5];

    }];
}

#pragma mark --lazy

- (NSArray *)memberArr{
    if (!_memberArr) {
        _memberArr = [NSArray array];
 
    }
    return _memberArr;
}


- (TuyaSmartHome *)home{
    if (!_home) {
        self.home =[TuyaSmartHome homeWithHomeId:self.homeModel.homeId];
    }
    return _home;
}
#pragma mark -- p判断是否是 管理员或者所有者

- (BOOL)isAdminOrOwner{
    if (self.homeModel.role == TYHomeRoleType_Admin ||self.homeModel.role == TYHomeRoleType_Owner) {
        return YES;
    }
    return NO;
}

- (void)getReceiveMemberList {
    self.deviceShare  = [[TuyaSmartHomeDeviceShare alloc] init];
    
    [self.deviceShare getDeviceShareMemberListWithDevId:self.deviceModel.devId success:^(NSArray<TuyaSmartShareMemberModel *> *list) {

        self.memberArr = list;
        [self.qzTableView reloadData];
    } failure:^(NSError *error) {

        [[QZHHUD HUD] textHUDWithMessage:error.userInfo[@"NSLocalizedDescription"] afterDelay:0.5];

    }];

}
@end
