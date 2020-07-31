//
//  MineVC.m
//  DDSample
//
//  Created by 黄振 on 2020/4/1.
//  Copyright © 2020 KingYellow. All rights reserved.
//

#import "MineVC.h"
#import "MineHeaderCell.h"
#import "MineDefaultCell.h"
#import "HomeManageVC.h"
#import "PerInfoVC.h"
#import "SettingVC.h"
#import "TOTAWebVC.h"

@interface MineVC ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic)UITableView *qzTableView;

@property (copy, nonatomic)NSMutableArray *listArr;
@property (copy, nonatomic)NSMutableArray *logoArr;

@end

@implementation MineVC
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.qzTableView reloadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = QZHKIT_COLOR_LEADBACK;
    [self initConfig];

}
- (void)initConfig{
    
    [self exp_navigationBarTextWithColor:QZHKIT_COLOR_NAVIBAR_TITLE font:QZHKIT_FONT_TABBAR_TITLE];
    [self exp_navigationBarColor:QZHKIT_COLOR_NAVIBAR_BACK hiddenShadow:NO];
     self.navigationItem.title = QZHLoaclString(@"mine");
    
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
        
        [self.qzTableView registerClass:[MineHeaderCell class] forCellReuseIdentifier:QZHCELL_REUSE_IMAGE];
        [self.qzTableView registerClass:[MineDefaultCell class] forCellReuseIdentifier:QZHCELL_REUSE_TEXT];
    }
    return _qzTableView;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (section == 0) {
        MineHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:QZHCELL_REUSE_IMAGE];
        [cell.IMGView exp_loadImageUrlString:[TuyaSmartUser sharedInstance].headIconUrl placeholder:QZHICON_HEAD_PLACEHOLDER];
        cell.nameLab.text = [TuyaSmartUser sharedInstance].nickname;
        cell.describeLab.text = [TuyaSmartUser sharedInstance].phoneNumber;

        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if (section == 1) {
        MineDefaultCell *cell = [tableView dequeueReusableCellWithIdentifier:QZHCELL_REUSE_TEXT];
        cell.nameLab.text = self.listArr[row];
        cell.IMGView.image = QZHLoadIcon(self.logoArr[row]);
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (row == 2) {
            cell.tagLab.hidden = NO;
            NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
            NSString *appVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
            cell.tagLab.text = [NSString stringWithFormat:@"V %@",appVersion];
        }else{
            cell.tagLab.hidden = YES;
        }
        return cell;
    }else{
        MineDefaultCell *cell = [tableView dequeueReusableCellWithIdentifier:QZHCELL_REUSE_TEXT];
        cell.nameLab.text = @"设置";
        cell.IMGView.image = QZHLoadIcon(@"shezhi");
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
 
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return self.listArr.count;
            break;
        case 2:
            return 1;
            break;
            
        default:
            return 0;
            break;
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

-(void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section{
    view.tintColor = QZHKIT_COLOR_LEADBACK;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    if (section == 0 && row == 0) {
        PerInfoVC *vc = [[PerInfoVC alloc] init];
        [self.navigationController pushViewController:[vc exp_hiddenTabBar] animated:YES];
    }
    if (section == 1 && row == 0) {
        TOTAWebVC *vc = [[TOTAWebVC alloc] init];
        vc.urlString = @"https://smartapp.tuya.com/tuyasmart/help";
        [self.navigationController pushViewController:[vc exp_hiddenTabBar] animated:YES];
    }
    if (section == 1 && row == 1) {
        HomeManageVC *vc = [[HomeManageVC alloc] init];
        [self.navigationController pushViewController:[vc exp_hiddenTabBar] animated:YES];
    }

    if (section == 2 && row == 0) {
        SettingVC *vc = [[SettingVC alloc] init];
        [self.navigationController pushViewController:[vc exp_hiddenTabBar] animated:YES];
    }

}

- (NSMutableArray *)listArr{
    if (!_listArr) {
        _listArr = [NSMutableArray arrayWithArray:@[QZHLoaclString(@"mine_commonQuestions"),QZHLoaclString(@"mine_familyManagement"),QZHLoaclString(@"mine_currentVersion")]];
 
    }
    return _listArr;
}

-(NSMutableArray *)logoArr{
    if (!_logoArr) {
        _logoArr = [NSMutableArray arrayWithArray:@[@"lianxi",@"shezhi",@"shezhi"]];
    }
    return _logoArr;
}

@end
