//
//  RoomDetailVC.m
//  luxshare
//
//  Created by 黄振 on 2020/7/2.
//  Copyright © 2020 KingYellow. All rights reserved.
//

#import "RoomDetailVC.h"
#import "PerInfoDefaultCell.h"
#import "QZHDefaultButtonCell.h"

@interface RoomDetailVC ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic)UITableView *qzTableView;
@property (strong, nonatomic)TuyaSmartRoom *room;
@property (strong, nonatomic)UIButton *rightBtn;

@end

@implementation RoomDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.roomName = self.roomModel.name;
    [self initConfig];
}
- (void)initConfig{
    self.view.backgroundColor = QZHKIT_COLOR_LEADBACK;
    self.navigationItem.title = QZHLoaclString(@"room_detail");
    [self exp_navigationBarTextWithColor:QZHKIT_COLOR_NAVIBAR_TITLE font:QZHKIT_FONT_TABBAR_TITLE];
    [self exp_navigationBarColor:QZHKIT_COLOR_NAVIBAR_BACK hiddenShadow:NO];
    self.rightBtn = [self exp_addRightItemTitle:QZHLoaclString(@"save") itemIcon:@""];
    [self UIConfig];

}
- (void)UIConfig{
    
    [self.view addSubview:self.qzTableView];
         [self.qzTableView mas_makeConstraints:^(MASConstraintMaker *make) {
         make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0 ));
     }];
}
-(void)exp_rightAction{
    
    [self updateRoomName:self.roomName];

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
    }
    return _qzTableView;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger section = indexPath.section;
    if (section == 0) {
        PerInfoDefaultCell *cell = [tableView dequeueReusableCellWithIdentifier:QZHCELL_REUSE_TEXT];
        cell.nameLab.text = QZHLoaclString(@"room_name");
        [cell.nameLab mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(110);
        }];
        cell.describeLab.text = self.roomName;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    }else{
        QZHDefaultButtonCell *cell = [tableView dequeueReusableCellWithIdentifier:QZHCELL_REUSE_DEFAULT];
          cell.nameLab.text = QZHLoaclString(@"home_removeHome");
        cell.nameLab.textColor = QZHKIT_Color_BLACK_26;
          cell.selectionStyle = UITableViewCellSelectionStyleNone;
          return cell;
    }
 
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        UIView *view = [[UIView alloc] init];
        UILabel *lab = [[UILabel alloc] init];
        lab.text = QZHLoaclString(@"room_noDevices");
        lab.font = QZHKIT_FONT_LISTCELL_SUB_TITLE;
        lab.textColor = QZHKIT_Color_BLACK_54;
        lab.frame = CGRectMake(15, 30, QZHScreenWidth, 20);
        [view addSubview:lab];
        return view;
    }else{
        return [UIView new];
    }

}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return section == 0?1:0;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 50;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
   
     return 30;
}

-(void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section{
    view.tintColor = QZHKIT_COLOR_LEADBACK;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    QZHWS(weakSelf)
    UIAlertController *alert = [UIAlertController alertWithTextfieldTitle:QZHLoaclString(@"room_editRoomName") originaltext:self.roomName textblock:^(NSString * _Nonnull fieldtext) {
        if (fieldtext.length == 0) {
            [[QZHHUD HUD] textHUDWithMessage:QZHLoaclString(@"roon_namelenngthMin1") afterDelay:0.5];
            return ;
        }
        weakSelf.roomName = fieldtext;
        [weakSelf.qzTableView reloadData];
        
    }];
    [self presentViewController:alert animated:YES completion:nil];
   
}

#pragma mark --lazy

-(TuyaSmartRoom *)room{
    if (!_room) {
        self.room =[TuyaSmartRoom roomWithRoomId:self.roomModel.roomId homeId:self.homeModel.homeId];
    }
    return _room;
}
- (void)updateRoomName:(NSString *)roomName {
    QZHWS(weakSelf)
    [self.room updateRoomName:roomName success:^{
        [[QZHHUD HUD] textHUDWithMessage:QZHLoaclString(@"handleSuccess") afterDelay:0.5];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.navigationController popViewControllerAnimated:YES];
            
        });
        
    } failure:^(NSError *error) {

        [[QZHHUD HUD] textHUDWithMessage:error.userInfo[@"NSLocalizedDescription"] afterDelay:0.5];
    }];
}
@end
