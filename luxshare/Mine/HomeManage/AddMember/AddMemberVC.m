//
//  AddMemberVC.m
//  luxshare
//
//  Created by 黄振 on 2020/6/29.
//  Copyright © 2020 KingYellow. All rights reserved.
//

#import "AddMemberVC.h"
#import "QZHFieldCell.h"
#import "PerInfoDefaultCell.h"
#import "AddressBookTVC.h"
#import "YFMPaymentView.h"

@interface AddMemberVC ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic)UITableView *qzTableView;
@property (strong, nonatomic)NSString *name;
@property (strong, nonatomic)NSString *account;
@property (strong, nonatomic)NSString *country;
@property (strong, nonatomic)NSString *role;
@property (strong, nonatomic)TuyaSmartHome *home;
@property (strong, nonatomic)ContactModel *countryModel;
@property (assign, nonatomic)CGFloat cellalpha;
@property (strong, nonatomic)UIButton *rightBtn;
@end

@implementation AddMemberVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initConfig];
    self.role = QZHLoaclString(@"role_normal");
    self.cellalpha = 0.5;
}
- (void)initConfig{
    self.view.backgroundColor = QZHKIT_COLOR_LEADBACK;
    self.navigationItem.title = QZHLoaclString(@"home_addMember");
    [self exp_navigationBarTextWithColor:QZHKIT_COLOR_NAVIBAR_TITLE font:QZHKIT_FONT_TABBAR_TITLE];
    [self exp_navigationBarColor:QZHKIT_COLOR_NAVIBAR_BACK hiddenShadow:NO];
    [self UIConfig];
    self.rightBtn = [self exp_addRightItemTitle:QZHLoaclString(@"save") itemIcon:@""];
    [self.rightBtn setTitleColor:QZH_KIT_Color_WHITE_30 forState:UIControlStateNormal];
    self.rightBtn.enabled = NO;
    self.countryModel = [ContactModel new];
    self.countryModel.code = @"86";
    self.countryModel.chinese = @"中国";
    self.countryModel.english = @"China";

}
- (void)exp_rightAction{
    [self addShare];
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

        [self.qzTableView registerClass:[QZHFieldCell class] forCellReuseIdentifier:QZHCELL_REUSE_TEXT];
        [self.qzTableView registerClass:[PerInfoDefaultCell class] forCellReuseIdentifier:QZHCELL_REUSE_DEFAULT];
    }
    return _qzTableView;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (section == 0) {
        
        QZHFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:QZHCELL_REUSE_TEXT];
        cell.nameLab.text = QZHLoaclString(@"member_name");
        cell.textfield.placeholder = QZHLoaclString(@"member_inputName");
        cell.textfield.text = self.name;
        cell.textfield.tag = 0;
        [cell.textfield addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventEditingChanged];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    }else if(section == 1){
        if (row == 0) {
            PerInfoDefaultCell *cell = [tableView dequeueReusableCellWithIdentifier:QZHCELL_REUSE_DEFAULT];
            cell.nameLab.text = QZHLoaclString(@"member_country");
            if (self.countryModel) {
                cell.describeLab.text = [NSString stringWithFormat:@"%@ +%@",[QZHCommons languageOfTheDeviceSystem] == LanguageChinese?self.countryModel.chinese:self.countryModel.english,self.countryModel.code];
            }else{
                cell.describeLab.text = [NSString stringWithFormat:@"%@ +%@",[QZHCommons languageOfTheDeviceSystem] == LanguageChinese?self.countryModel.chinese:self.countryModel.english,self.countryModel.code];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            return cell;
        }else{
            QZHFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:QZHCELL_REUSE_TEXT];
            cell.nameLab.text = QZHLoaclString(@"member_account");
            cell.textfield.placeholder = QZHLoaclString(@"member_inputAccount");
            cell.textfield.text = self.account;
            cell.textfield.tag = 1;
            [cell.textfield addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventEditingChanged];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        
    }else{
        PerInfoDefaultCell *cell = [tableView dequeueReusableCellWithIdentifier:QZHCELL_REUSE_DEFAULT];
         cell.nameLab.text = QZHLoaclString(@"home_role");
         cell.describeLab.text = self.role;
        cell.contentView.alpha = self.cellalpha;
         cell.selectionStyle = UITableViewCellSelectionStyleNone;
         cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
         return cell;
    }
 
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 2) {
        UIView *view = [[UIView alloc] init];
        UILabel *lab = [[UILabel alloc] init];
        lab.text = QZHLoaclString(@"role_addMemberTip");
        lab.font = QZHKIT_FONT_LISTCELL_SUB_TITLE;
        lab.textColor = QZHKIT_Color_BLACK_54;
        lab.numberOfLines = 0;
        [view addSubview:lab];
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(0, 15, 0, 15));
        }];
        return view;
    }else{
        return [UIView new];
    }

}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0 ) {
        return 1;
    }else if(section == 1){
        return 2;
    }else{
        return 1;
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 50;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
   
    if (section == 2) {
        return 70;
    }
     return 20;
}

-(void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section{
    view.tintColor = QZHKIT_COLOR_LEADBACK;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (section == 1 && row == 0) {
        AddressBookTVC *vc = [[AddressBookTVC alloc] init];
        QZHWS(weakSelf)
        vc.countryBlock = ^(ContactModel * _Nonnull countryCode) {
            weakSelf.countryModel = countryCode;
            [weakSelf.qzTableView reloadData];
        };

        [self.navigationController pushViewController:vc animated:YES];
    }

    if (section == 2) {
        if (self.cellalpha < 1.0) {
            return;
        }
            NSArray *payTypeArr = @[@{@"tip":QZHLoaclString(@"role_normalTip"),
                                  @"title":QZHLoaclString(@"role_normal")},@{@"tip":QZHLoaclString(@"role_adminTip"),@"title":QZHLoaclString(@"role_admin")}];
        
        YFMPaymentView *pop = [[YFMPaymentView alloc]initTotalPay:@"39.99" vc:self dataSource:payTypeArr];
        if ([self.role isEqualToString:QZHLoaclString(@"role_normal")]) {
            pop.currentIndex = 0;
        }else if([self.role isEqualToString:QZHLoaclString(@"role_admin")]){
            pop.currentIndex = 1;
        }

        pop.modalPresentationStyle = UIModalPresentationOverFullScreen;
        [self presentViewController:pop animated:YES completion:nil];
        
        pop.payType = ^(NSInteger index) {
            if (index == 0) {
                self.role = QZHLoaclString(@"role_normal");
            }else{
                self.role = QZHLoaclString(@"role_admin");
            }
            [self.qzTableView reloadData];
        };

    }

}

#pragma mark --lazy
-(TuyaSmartHome *)home{
    if (!_home) {
        self.home =[TuyaSmartHome homeWithHomeId:self.homeModel.homeId];
    }
    return _home;
}

- (void)valueChanged:(UITextField *)sender{
    if (sender.tag == 0) {
        self.name = sender.text;
    }else{
        self.account = sender.text;
    }
    if (self.name.length > 0 && self.account.length > 0) {
        self.cellalpha = 1.0;
        [self.qzTableView exp_refreshAtIndexSection:2];
        [self.rightBtn setTitleColor:QZH_KIT_Color_WHITE_100 forState:UIControlStateNormal];
        self.rightBtn.enabled = YES;
    }else{
        self.cellalpha = 0.5;
        [self.qzTableView exp_refreshAtIndexSection:2];
        [self.rightBtn setTitleColor:QZH_KIT_Color_WHITE_30 forState:UIControlStateNormal];
        self.rightBtn.enabled = NO;
    }
}

- (void)addShare {
 
    TYHomeRoleType type = TYHomeRoleType_Member;
    if ([self.role isEqualToString:QZHLoaclString(@"role_admin")]) {
        type = TYHomeRoleType_Admin;
    }
    QZHWS(weakSelf)
    [self.home addHomeMemberWithName:self.name headPic:nil countryCode:self.countryModel.code userAccount:self.account role:type success:^(NSDictionary *dict) {
        [[QZHHUD HUD] textHUDWithMessage:QZHLoaclString(@"handleSuccess") afterDelay:0.5];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.navigationController popViewControllerAnimated:YES];
            
        });

    } failure:^(NSError *error) {
        [[QZHHUD HUD] textHUDWithMessage:error.userInfo[@"NSLocalizedDescription"] afterDelay:0.5];
    }];
    
}
@end
