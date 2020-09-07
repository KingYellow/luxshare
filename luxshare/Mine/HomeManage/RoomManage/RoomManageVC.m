//
//  RoomManageVC.m
//  luxshare
//
//  Created by 黄振 on 2020/6/29.
//  Copyright © 2020 KingYellow. All rights reserved.
//

#import "RoomManageVC.h"
#import "NameEditVC.h"
#import "PerInfoDefaultCell.h"
#import "QZHDefaultButtonCell.h"
#import "MineHeaderCell.h"
#import "UITableView+MoveCell.h"
#import "RoomDetailVC.h"

@interface RoomManageVC ()<UITableViewDelegate,UITableViewDataSource,TuyaSmartHomeDelegate>
@property (strong, nonatomic)UITableView *qzTableView;
@property (copy, nonatomic)NSMutableArray *listArr;
@property (strong, nonatomic)TuyaSmartHome *home;
@end

@implementation RoomManageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initConfig];
}
- (void)initConfig{
    self.view.backgroundColor = QZHKIT_COLOR_LEADBACK;
    self.navigationItem.title = QZHLoaclString(@"room_roomDetail");
    [self exp_navigationBarTextWithColor:QZHKIT_COLOR_NAVIBAR_TITLE font:QZHKIT_FONT_TABBAR_TITLE];
    [self exp_navigationBarColor:QZHKIT_COLOR_NAVIBAR_BACK hiddenShadow:NO];
    [self UIConfig];
    [self addMovingAction];
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
//        [_qzTableView exp_tableViewDefault];
        self.qzTableView.backgroundColor = QZHKIT_COLOR_LEADBACK;
        self.qzTableView.separatorStyle = UITableViewCellSeparatorStyleNone;

        _qzTableView.delegate = self;
        _qzTableView.dataSource = self;

        [self.qzTableView registerClass:[PerInfoDefaultCell class] forCellReuseIdentifier:QZHCELL_REUSE_TEXT];
        [self.qzTableView registerClass:[QZHDefaultButtonCell class] forCellReuseIdentifier:QZHCELL_REUSE_DEFAULT];
    }
    return _qzTableView;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (section == 0) {
        
        PerInfoDefaultCell *cell = [tableView dequeueReusableCellWithIdentifier:QZHCELL_REUSE_TEXT];
        TuyaSmartRoomModel *model = self.listArr[row];
        cell.nameLab.text = model.name;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    }else{

        QZHDefaultButtonCell *cell = [tableView dequeueReusableCellWithIdentifier:QZHCELL_REUSE_DEFAULT];
        cell.nameLab.text = QZHLoaclString(@"room_addOtherRoom");
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
    if (section == 0 ) {
        return self.listArr.count;

    }else{
        return 1;
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 50;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.listArr.count == 0 && section == 0) {
        return 0;
    }
     return 20;
}

-(void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section{
    view.tintColor = QZHKIT_COLOR_LEADBACK;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    QZHWS(weakSelf)
    if (section == 0) {
        TuyaSmartRoomModel *room = self.listArr[row];
        RoomDetailVC *vc = [[RoomDetailVC alloc] init];
        vc.homeModel = self.homeModel;
        vc.roomModel = room;
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (section == 1) {
        NameEditVC *vc = [[NameEditVC alloc] init];
        vc.home = self.home;
        vc.refresh = ^{
            weakSelf.home =[TuyaSmartHome homeWithHomeId:self.homeModel.homeId];
            [weakSelf.listArr removeAllObjects];
            [weakSelf.listArr addObjectsFromArray:self.home.roomList];
            [self addMovingAction];
            [weakSelf.qzTableView reloadData];
        };
        [self.navigationController pushViewController:[vc exp_hiddenTabBar] animated:YES];
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

    return @"删除";

}
//删除相应方法

- (void)tableView:(UITableView*)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath*)indexPath {
    TuyaSmartRoomModel *model = self.listArr[indexPath.row];
    [self.home removeHomeRoomWithRoomId:model.roomId  success:^{
        [QZHNotification postNotificationName:QZHNotificationKeyK1 object:nil];
        [self.listArr removeObjectAtIndex:indexPath.row];
        [self.qzTableView reloadData];
    } failure:^(NSError *error) {
        [[QZHHUD HUD] textHUDWithMessage:error.userInfo[@"NSLocalizedDescription"] afterDelay:0.5];
    }];
}

#pragma mark --lazy
- (NSMutableArray *)listArr{
    if (!_listArr) {
        _listArr = [NSMutableArray arrayWithArray:self.home.roomList];
    }
    return _listArr;
}
-(TuyaSmartHome *)home{
    if (!_home) {
        self.home =[TuyaSmartHome homeWithHomeId:self.homeModel.homeId];
        self.home.delegate = self;
    }
    return _home;
}
- (void)addMovingAction{
    
    QZHWS(weakSelf)
    [self.qzTableView setDataWithArray:self.listArr withBlock:^(NSMutableArray *newArray) {

        [weakSelf.home sortRoomList:newArray success:^{
            [[QZHHUD HUD] textHUDWithMessage:QZHLoaclString(@"handleSuccess") afterDelay:0.5];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf.listArr removeAllObjects];
                [weakSelf.listArr addObjectsFromArray:newArray];
                [weakSelf.qzTableView reloadData];
            });

        } failure:^(NSError *error) {
              
            [[QZHHUD HUD] textHUDWithMessage:error.userInfo[@"NSLocalizedDescription"]  afterDelay:0.5];
        }];
        
    }];
}
#pragma mark - TuyaSmartHomeDelegate

- (void)home:(TuyaSmartHome *)home roomInfoUpdate:(TuyaSmartRoomModel *)room {
    [self.qzTableView reloadData];
}
@end
