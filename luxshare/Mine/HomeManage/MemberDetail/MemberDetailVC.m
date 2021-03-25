//
//  MemberDetailVC.m
//  luxshare
//
//  Created by 黄振 on 2020/6/30.
//  Copyright © 2020 KingYellow. All rights reserved.
//

#import "MemberDetailVC.h"
#import "PerInfoDefaultCell.h"
#import "QZHDefaultButtonCell.h"
#import "PerInfoPicCell.h"
#import "AddMemberVC.h"
#import "YFMPaymentView.h"


@interface MemberDetailVC ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic)UITableView *qzTableView;

@property (strong, nonatomic)TuyaSmartHome *home;
@property (strong, nonatomic)NSString *role;

@end

@implementation MemberDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initConfig];
}
- (void)initConfig{
    self.view.backgroundColor = QZHKIT_COLOR_LEADBACK;
    self.navigationItem.title = QZHLoaclString(@"home_homeMember");
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

        [self.qzTableView registerClass:[PerInfoDefaultCell class] forCellReuseIdentifier:QZHCELL_REUSE_TEXT];
        [self.qzTableView registerClass:[PerInfoPicCell class] forCellReuseIdentifier:QZHCELL_REUSE_IMAGE];
        [self.qzTableView registerClass:[QZHDefaultButtonCell class] forCellReuseIdentifier:QZHCELL_REUSE_DEFAULT];
    }
    return _qzTableView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (section == 0) {
        
        if (row == 0) {
            PerInfoDefaultCell *cell = [tableView dequeueReusableCellWithIdentifier:QZHCELL_REUSE_TEXT];
            cell.nameLab.text = QZHLoaclString(@"member_name");
            cell.describeLab.text = self.memberModel.name;
            if ([QZHCommons isAdminOrOwner:self.homeModel]) {
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else{
            PerInfoPicCell *cell = [tableView dequeueReusableCellWithIdentifier:QZHCELL_REUSE_IMAGE];
            cell.nameLab.text = QZHLoaclString(@"member_headpic");
            [cell.IMGView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.width.mas_equalTo(40);
            }];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            QZHViewRadius(cell.IMGView, 20);
            [cell.IMGView exp_loadImageUrlString:self.memberModel.headPic placeholder:QZHICON_HEAD_PLACEHOLDER];
            return cell;
        }
        
    }else if(section == 1){
        PerInfoDefaultCell *cell = [tableView dequeueReusableCellWithIdentifier:QZHCELL_REUSE_TEXT];
       cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (row == 0) {
            cell.nameLab.text = QZHLoaclString(@"member_memberAccount");
            cell.describeLab.text = self.memberModel.userName;

        }else{
            cell.nameLab.text = QZHLoaclString(@"member_homeRole");
            cell.describeLab.text = [self getRole:self.memberModel.role];
            if (self.memberModel.role != TYHomeRoleType_Owner && [self isAdmin]) {
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
        }
      return cell;
        
    }else{
        QZHDefaultButtonCell *cell = [tableView dequeueReusableCellWithIdentifier:QZHCELL_REUSE_DEFAULT];
        if ([self.memberModel.uid isEqualToString:[TuyaSmartUser sharedInstance].uid]) {
            cell.nameLab.text = QZHLoaclString(@"member_leaveFamily");
        }else{
            cell.nameLab.text = QZHLoaclString(@"member_removeMember");
        }
        
        cell.nameLab.textColor = QZHKIT_Color_BLACK_26;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
 
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
   // self.homeModel 自己在家庭里身份
    // self.memberModel 查看的人在家庭里身份
    NSString *uid = [TuyaSmartUser sharedInstance].uid;
    if ([QZHCommons isAdminOrOwner:self.homeModel]) {
        //拥有者
        if (self.homeModel.role == TYHomeRoleType_Owner) {
            return 3;
        }else{
            if (self.memberModel.role == TYHomeRoleType_Owner) {
                return 2;
            }else{
                return 3;
            }
        }
    }else{
        //普通
        if ([self.memberModel.uid isEqualToString:uid]) {
            return 3;
        }else{
            return 2;
        }
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0 ) {
        return 2;
    }else if(section == 1){
        return 2;
    }else{
        return 1;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

     return 30;
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section{
    view.tintColor = QZHKIT_COLOR_LEADBACK;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (![QZHCommons isAdminOrOwner:self.homeModel]) {
        return;
    }
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    QZHWS(weakSelf)
    if (section == 0 && row == 0) {
        
     UIAlertController *alert = [UIAlertController alertWithTextfieldTitle:QZHLoaclString(@"home_editMemberName") originaltext:self.memberModel.name textblock:^(NSString * _Nonnull fieldtext) {
         [weakSelf updateMemberInfo:fieldtext role:self.memberModel.role];
        }];
        [self presentViewController:alert animated:YES completion:nil];
    }

    if (section == 1 && row == 1) {
        if (self.memberModel.role == TYHomeRoleType_Owner || self.homeModel.role == TYHomeRoleType_Admin) {
            return;
        }

 
        NSArray *payTypeArr = @[@{@"tip":QZHLoaclString(@"role_normalTip"),
                                   @"title":QZHLoaclString(@"role_normal")},@{@"tip":QZHLoaclString(@"role_adminTip"),@"title":QZHLoaclString(@"role_admin")}];
         
        YFMPaymentView *pop = [[YFMPaymentView alloc]initTotalPay:@"39.99" vc:self dataSource:payTypeArr];
        if (self.memberModel.role == TYHomeRoleType_Member) {
            pop.currentIndex = 0;
        }else if(self.memberModel.role == TYHomeRoleType_Admin){
            pop.currentIndex = 1;
        }

        pop.modalPresentationStyle = UIModalPresentationOverFullScreen;
        [self presentViewController:pop animated:YES completion:nil];
         
         pop.payType = ^(NSInteger index) {
             if (index == 0) {
                 self.role = QZHLoaclString(@"role_normal");
                 [weakSelf updateMemberInfo:nil role:TYHomeRoleType_Member];

             }else{
                 self.role = QZHLoaclString(@"role_admin");
                 [weakSelf updateMemberInfo:nil role:TYHomeRoleType_Admin];

             }
         };
    }

    if (section == 2) {
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:QZHLoaclString(@"tip") message:QZHLoaclString(@"deletedWillNaverRevover") preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:QZHLoaclString(@"cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:QZHLoaclString(@"delete") style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [self removeMember:self.memberModel];
            
        }];
        [alertC addAction:action];
        [alertC addAction:action1];
        [self presentViewController:alertC animated:NO completion:nil];
    }
 
}

#pragma mark  -- Action

- (void)updateMemberInfo:(NSString *)name role:(TYHomeRoleType)type{
    QZHWS(weakSelf)
    TuyaSmartHomeMember *homeMember = [[TuyaSmartHomeMember alloc] init];
    TuyaSmartHomeMemberRequestModel *requestModel = [[TuyaSmartHomeMemberRequestModel alloc] init];
    requestModel.memberId = self.memberModel.memberId;
    if (name) {
        requestModel.name = name;
    }
    requestModel.role = type;
    [homeMember updateHomeMemberInfoWithMemberRequestModel:requestModel  success:^{
        [[QZHHUD HUD] textHUDWithMessage:QZHLoaclString(@"handleSuccess") afterDelay:0.5];
        weakSelf.memberModel.role = requestModel.role;
        if (name) {
            weakSelf.memberModel.name = name;
        }
        [weakSelf.qzTableView reloadData];
    } failure:^(NSError *error) {
        [[QZHHUD HUD] textHUDWithMessage:error.userInfo[@"NSLocalizedDescription"] afterDelay:0.5];
        
    }];
  
}

#pragma mark -- 判断是否是 管理员或者所有者

- (BOOL)isAdmin{
    if (self.homeModel.role == TYHomeRoleType_Owner) {
        return YES;
    }
    return NO;
}
- (NSString *)getRole:(TYHomeRoleType) role{
    NSString *str;
    if (role == TYHomeRoleType_Owner) {
        str =QZHLoaclString(@"role_owner");
    }else if(role == TYHomeRoleType_Admin){
        str = QZHLoaclString(@"role_admin");
    }else{
        str = QZHLoaclString(@"role_normal");
    }
    return str;
}

- (void)removeMember:(TuyaSmartHomeMemberModel *)memberModel {
    TuyaSmartHomeMember *homeMember = [[TuyaSmartHomeMember alloc] init];
    QZHWS(weakSelf)
    [homeMember removeHomeMemberWithMemberId:memberModel.memberId success:^{
        
        [[QZHHUD HUD] textHUDWithMessage:QZHLoaclString(@"handleSuccess") afterDelay:0.5];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.navigationController popViewControllerAnimated:YES];
            if (self.memberModel.role == TYHomeRoleType_Owner) {
                weakSelf.disHomeBlock();
            }
            
        });
    } failure:^(NSError *error) {
       [[QZHHUD HUD] textHUDWithMessage:error.userInfo[@"NSLocalizedDescription"] afterDelay:0.5];
        
    }];
}

@end
