//
//  HomeManageVC.m
//  luxshare
//
//  Created by 黄振 on 2020/6/26.
//  Copyright © 2020 KingYellow. All rights reserved.
//

#import "HomeManageVC.h"
#import "HomeManageListCell.h"
#import "QZHDefaultButtonCell.h"
#import "HomeDetailVC.h"
#import "AddHomeVC.h"

@interface HomeManageVC ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic)UITableView *qzTableView;
@property (copy, nonatomic)NSMutableArray *listArr;
@property (strong, nonatomic)TuyaSmartHomeManager *magager;

@end

@implementation HomeManageVC
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getHomeList];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initConfig];
    
}
- (void)initConfig{
    self.view.backgroundColor = QZHKIT_COLOR_LEADBACK;
    self.navigationItem.title = QZHLoaclString(@"home_manage");
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
-(UITableView *)qzTableView{
    if (!_qzTableView) {
        _qzTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [_qzTableView exp_tableViewDefault];
        self.qzTableView.backgroundColor = QZHKIT_COLOR_LEADBACK;
        self.qzTableView.separatorStyle = UITableViewCellSeparatorStyleNone;

        _qzTableView.delegate = self;
        _qzTableView.dataSource = self;
        [self.qzTableView registerClass:[HomeManageListCell class] forCellReuseIdentifier:QZHCELL_REUSE_TEXT];
        [self.qzTableView registerClass:[QZHDefaultButtonCell class] forCellReuseIdentifier:QZHCELL_REUSE_DEFAULT];

    }
    return _qzTableView;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (section == 0) {
        
        HomeManageListCell *cell = [tableView dequeueReusableCellWithIdentifier:QZHCELL_REUSE_TEXT];
        TuyaSmartHomeModel *model = self.listArr[row];
        
        cell.nameLab.text = model.name;
        if (model.dealStatus == TYHomeStatusPending) {
            cell.statusLab.text = QZHLoaclString(@"home_memberstatus_pending");
        }else{
            cell.statusLab.text = @"";
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    }else{
        QZHDefaultButtonCell *cell = [tableView dequeueReusableCellWithIdentifier:QZHCELL_REUSE_DEFAULT];
        cell.nameLab.text = QZHLoaclString(@"home_addHome");
        [cell.nameLab mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.centerY.mas_equalTo(cell);
        }];
        cell.nameLab.textColor = QZHKIT_COLOR_SKIN;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
 
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return section==0?self.listArr.count:1;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}
-(void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section{
    view.tintColor = QZHKIT_COLOR_LEADBACK;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    QZHWS(weakSelf)
    if (section == 1) {
        AddHomeVC *vc = [[AddHomeVC alloc] init];
        vc.refresh = ^{
            [weakSelf getHomeList];
        };
        [self.navigationController pushViewController:vc animated:YES];

    }else{
        TuyaSmartHomeModel *model = self.listArr[row];
        if (model.dealStatus == TYHomeStatusPending) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:QZHLoaclString (@"home_pendrecive") message:[NSString stringWithFormat:@"%@\"%@\"%@",QZHLoaclString(@"home_pendTextfirst"),model.name,QZHLoaclString(@"home_pendTextsecond")] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *reject = [UIAlertAction actionWithTitle:QZHLoaclString(@"home_rejectJoin") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self initMemberList:model accept:NO];
            }];
            UIAlertAction *accept = [UIAlertAction actionWithTitle:QZHLoaclString(@"home_acceptPend") style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                [self initMemberList:model accept:YES];

            }];
            [alert addAction:reject];
            [alert addAction:accept];
            [self presentViewController:alert animated:YES completion:nil];
        
        }else{
             HomeDetailVC *vc = [[HomeDetailVC alloc] init];
             vc.homeModel = model;
             [self.navigationController pushViewController:vc animated:YES];
         }

    }
}

#pragma mark --lazy
- (NSMutableArray *)listArr{
    if (!_listArr) {
        _listArr = [NSMutableArray array];
 
    }
    return _listArr;
}
- (void)getHomeList {
    QZHWS(weakSelf)
   self.magager = [[TuyaSmartHomeManager alloc] init];
    [self.magager getHomeListWithSuccess:^(NSArray<TuyaSmartHomeModel *> *homes) {
        [weakSelf.listArr removeAllObjects];
        [weakSelf.listArr addObjectsFromArray:homes];
        [weakSelf.qzTableView reloadData];
        
    } failure:^(NSError *error) {
        [[QZHHUD HUD] textHUDWithMessage:error.userInfo[@"NSLocalizedDescription"] afterDelay:0.5];
    }];
}
//加入拒绝家庭邀请
- (void)initMemberList:(TuyaSmartHomeModel *)homemodel accept:(BOOL)isaccept {
    QZHWS(weakSelf)
    TuyaSmartHome *home = [TuyaSmartHome homeWithHomeId:homemodel.homeId];
    [home joinFamilyWithAccept:isaccept success:^(BOOL result) {
        [weakSelf getHomeList];
    } failure:^(NSError *error) {
        [[QZHHUD HUD] textHUDWithMessage:error.userInfo[@"NSLocalizedDescription"] afterDelay:0.5];
    }];
}

@end
