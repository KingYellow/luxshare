//
//  AddHomeVC.m
//  luxshare
//
//  Created by 黄振 on 2020/7/1.
//  Copyright © 2020 KingYellow. All rights reserved.
//

#import "AddHomeVC.h"
#import "QZHFieldCell.h"
#import "QZHSelectCell.h"
#import "QZHDefaultButtonCell.h"
#import "NameEditVC.h"

@interface AddHomeVC ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic)UITableView *qzTableView;
@property (strong, nonatomic)NSMutableArray *listArr;
@property (strong, nonatomic)NSString *name;
@property (strong, nonatomic)NSString *location;
@property (strong, nonatomic)TuyaSmartHome *home;
@property (strong, nonatomic)UIButton *rightBtn;
@end

@implementation AddHomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initConfig];

}
- (void)initConfig{
    self.view.backgroundColor = QZHKIT_COLOR_LEADBACK;
    self.navigationItem.title = QZHLoaclString(@"home_addHome");
    [self exp_navigationBarTextWithColor:QZHKIT_COLOR_NAVIBAR_TITLE font:QZHKIT_FONT_TABBAR_TITLE];
    [self exp_navigationBarColor:QZHKIT_COLOR_NAVIBAR_BACK hiddenShadow:NO];
    [self UIConfig];
    self.rightBtn = [self exp_addRightItemTitle:QZHLoaclString(@"save") itemIcon:@""];
    [self.rightBtn setTitleColor:QZH_KIT_Color_WHITE_30 forState:UIControlStateNormal];
    self.rightBtn.enabled = NO;
    
}
- (void)exp_rightAction{

    [self addHome];
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

        [self.qzTableView registerClass:[QZHFieldCell class] forCellReuseIdentifier:QZHCELL_REUSE_TEXT];
        [self.qzTableView registerClass:[QZHSelectCell class] forCellReuseIdentifier:QZHCELL_REUSE_DEFAULT];
        [self.qzTableView registerClass:[QZHDefaultButtonCell class] forCellReuseIdentifier:QZHCELL_REUSE_IMAGE];

    }
    return _qzTableView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (section == 0) {
        
        QZHFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:QZHCELL_REUSE_TEXT];
//        [cell.nameLab mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.width.mas_equalTo(100);
//        }];
        if (row == 0) {
             cell.nameLab.text = QZHLoaclString(@"home_name");
             cell.textfield.placeholder = QZHLoaclString(@"member_max25");
             cell.textfield.text = self.name;
             cell.textfield.tag = 0;
        }else{
            cell.nameLab.text = QZHLoaclString(@"home_location");
             cell.textfield.placeholder = QZHLoaclString(@"member_max25");
             cell.textfield.text = self.location;
             cell.textfield.tag = 1;
        }
 
        [cell.textfield addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventEditingChanged];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    }else if(section == 1) {
        QZHSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:QZHCELL_REUSE_DEFAULT];
         cell.nameLab.text = self.listArr[row][@"name"];
        cell.selectBtn.selected = [self.listArr[row][@"selected"] boolValue];
        cell.selectBtn.tag = indexPath.row;
        [cell.selectBtn addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];
         cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        QZHDefaultButtonCell *cell = [tableView dequeueReusableCellWithIdentifier:QZHCELL_REUSE_IMAGE];
        [cell.nameLab mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.centerY.mas_equalTo(cell);
        }];
        cell.nameLab.textColor = QZHKIT_COLOR_SKIN;
        
        cell.nameLab.text = QZHLoaclString(@"addOtherRoom");
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
       return cell;
    }
 
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        UIView *view = [[UIView alloc] init];
        UILabel *lab = [[UILabel alloc] init];
        lab.text = QZHLoaclString(@"home_room");
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
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0 ) {
        return 2;
    }else if(section == 1){
        return self.listArr.count;
    }else{
        return 1;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
   
    if (section == 1) {
        return 40;
    }
     return 20;
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section{
    view.tintColor = QZHKIT_COLOR_LEADBACK;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger section = indexPath.section;
    if (section == 2) {
        QZHWS(weakSelf)
        NameEditVC *vc = [[NameEditVC alloc] init];
        vc.selectBlock = ^(NSString *name) {
            NSDictionary *dic = @{@"name":name,@"selected":@"1"};
            [weakSelf.listArr addObject:dic];
            [weakSelf.qzTableView reloadData];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark --lazy
- (NSMutableArray *)listArr{
    if (!_listArr) {
        _listArr = [NSMutableArray arrayWithArray:@[@{@"name":QZHLoaclString(@"LivingRoom"),@"selected":@"1"},@{@"name":QZHLoaclString(@"MasterBedroom"),@"selected":@"1"},@{@"name":QZHLoaclString(@"GuestBedroom"),@"selected":@"1"},@{@"name":QZHLoaclString(@"DiningRoom"),@"selected":@"1"},@{@"name":QZHLoaclString(@"Kitchen"),@"selected":@"1"},@{@"name":QZHLoaclString(@"Study"),@"selected":@"1"}]];
    }
    return _listArr;
}


- (TuyaSmartHome *)home{
    if (!_home) {
        self.home =[TuyaSmartHome homeWithHomeId:11];
    }
    return _home;
}

// 家庭下新增房间代理回调
- (void)home:(TuyaSmartHome *)home didAddRoom:(TuyaSmartRoomModel *)room {
      [self.qzTableView reloadData];
}
- (void)valueChanged:(UITextField *)sender{
    if (sender.text.length > 25) {
         sender.text = [sender.text substringToIndex:25];
     }
    if (sender.tag == 0) {
 
        self.name = sender.text;
    }else{
        self.location = sender.text;
    }
    if (self.name.length > 0) {
        [self.rightBtn setTitleColor:QZH_KIT_Color_WHITE_100 forState:UIControlStateNormal];
        self.rightBtn.enabled = YES;
    }else{
        [self.rightBtn setTitleColor:QZH_KIT_Color_WHITE_30 forState:UIControlStateNormal];
        self.rightBtn.enabled = NO;
    }
}

- (void)addHome {
    NSMutableArray *arr = [NSMutableArray array];
    for (NSDictionary *dic in self.listArr) {
        if ([dic[@"selected"] isEqualToString:@"1"]) {
            [arr addObject:dic[@"name"]];
        }
    }
//    if (arr.count == 0) {
//        [[QZHHUD HUD] textHUDWithMessage:QZHLoaclString(@"home_selectOneRoom") afterDelay:0.5];
//        return;
//    }
    QZHWS(weakSelf)
    [[[TuyaSmartHomeManager alloc] init] addHomeWithName:self.name geoName:self.location rooms:arr latitude:0 longitude:0 success:^(long long result) {
        if (self.isFirst) {
            [[QZHHUD HUD] textHUDWithMessage:QZHLoaclString(@"handleSuccess") afterDelay:0.5];
            [QZHDataHelper saveValue:QZHKEY_TOKEN forKey:QZHKEY_TOKEN];
            [QZHROOT_DELEGATE setVC];
        }else{
            [[QZHHUD HUD] textHUDWithMessage:QZHLoaclString(@"handleSuccess") afterDelay:0.5];
            weakSelf.refresh();
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf.navigationController popViewControllerAnimated:YES];
                
            });
        }

    } failure:^(NSError *error) {
           [[QZHHUD HUD] textHUDWithMessage:error.userInfo[@"NSLocalizedDescription"] afterDelay:0.5];
    }];
        
}
- (void)selectAction:(UIButton *)sender{
    sender.selected = !sender.selected;
    NSDictionary *dic = self.listArr[sender.tag];
    NSMutableDictionary *dicm =[[NSMutableDictionary alloc] initWithDictionary:dic];
    dicm[@"selected"] = sender.selected?@"1":@"0";
    [self.listArr replaceObjectAtIndex:sender.tag withObject:dicm];
    [self.qzTableView reloadData];
}
@end
