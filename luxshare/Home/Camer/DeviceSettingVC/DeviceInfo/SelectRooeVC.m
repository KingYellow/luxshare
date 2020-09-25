//
//  SelectRooeVC.m
//  luxshare
//
//  Created by 黄振 on 2020/7/15.
//  Copyright © 2020 KingYellow. All rights reserved.
//

#import "SelectRooeVC.h"
#import "SelectRoomCell.h"


@interface SelectRooeVC ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic)UITableView *qzTableView;
@property (copy, nonatomic)NSMutableArray *listArr;
@property (strong, nonatomic)NSMutableArray *memberArr;
@property (strong, nonatomic)TuyaSmartHome *home;
@property (assign, nonatomic)NSInteger selectIndex;
@end

@implementation SelectRooeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initConfig];
}
- (void)initConfig{
    self.view.backgroundColor = QZHKIT_COLOR_LEADBACK;
    self.navigationItem.title = QZHLoaclString(@"room_roomDetail");
    [self exp_navigationBarTextWithColor:QZHKIT_COLOR_NAVIBAR_TITLE font:QZHKIT_FONT_TABBAR_TITLE];
    [self exp_navigationBarColor:QZHKIT_COLOR_NAVIBAR_BACK hiddenShadow:NO];
    [self exp_addRightItemTitle:QZHLoaclString(@"save") itemIcon:@""];
    [self UIConfig];
    self.selectIndex = 0;
}
- (void)exp_rightAction{
    if (![QZHDeviceStatus deviceIsOnline:self.deviceModel]) {
        [[QZHHUD HUD] textHUDWithMessage:@"设备已经离线,请设备上线后再设置" afterDelay:1.0];
        return;
    }
    self.selectBlack(self.listArr[self.selectIndex]);
    [self.navigationController popViewControllerAnimated:YES];
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
//        [_qzTableView exp_tableViewDefault];
        self.qzTableView.backgroundColor = QZHKIT_COLOR_LEADBACK;
        self.qzTableView.separatorStyle = UITableViewCellSeparatorStyleNone;

        _qzTableView.delegate = self;
        _qzTableView.dataSource = self;

        [self.qzTableView registerClass:[SelectRoomCell class] forCellReuseIdentifier:QZHCELL_REUSE_TEXT];
    }
    return _qzTableView;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = indexPath.row;
    SelectRoomCell *cell = [tableView dequeueReusableCellWithIdentifier:QZHCELL_REUSE_TEXT];
    TuyaSmartRoomModel *modle = self.listArr[row];
    cell.nameLab.text = modle.name;
    cell.selectBtn.tag = row;
    [cell.selectBtn addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];

    if (self.selectIndex == row) {
        cell.selectBtn.selected = YES;
    }else{
        cell.selectBtn.selected = NO;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
 
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listArr.count;
   
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 50;
}


-(void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section{
    view.tintColor = QZHKIT_COLOR_LEADBACK;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (row == self.selectIndex) {
        
    }else{
        self.selectIndex = row;
        [self.qzTableView reloadData];
    }


}


#pragma mark --lazy
- (NSMutableArray *)listArr{
    if (!_listArr) {
        _listArr = [NSMutableArray arrayWithArray:self.home.roomList];
        for (int i = 0; i < self.listArr.count; i++) {
                if (self.deviceModel.roomId == [self.listArr[i] roomId]) {
                self.selectIndex = i;
            }
        }
    }
    return _listArr;
}
-(TuyaSmartHome *)home{
    if (!_home) {
        self.home =[TuyaSmartHome homeWithHomeId:self.homeModel.homeId];
    }
    return _home;
}

- (void)selectAction:(UIButton *)sender{
    if (sender.tag == self.selectIndex) {
        
    }else{
        self.selectIndex = sender.tag;
        [self.qzTableView reloadData];
    }
}

@end
