//
//  WeekSelectVC.m
//  luxshare
//
//  Created by 黄振 on 2020/7/28.
//  Copyright © 2020 KingYellow. All rights reserved.
//

#import "WeekSelectVC.h"
#import "SelectRoomCell.h"


@interface WeekSelectVC ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic)UITableView *qzTableView;
@property (strong, nonatomic)NSMutableArray *memberArr;
@property (assign, nonatomic)NSInteger selectIndex;
@end

@implementation WeekSelectVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initConfig];
}
- (void)initConfig{
    self.view.backgroundColor = QZHKIT_COLOR_LEADBACK;
    self.navigationItem.title = QZHLoaclString(@"message_selectWeek");
    [self exp_navigationBarTextWithColor:QZHKIT_COLOR_NAVIBAR_TITLE font:QZHKIT_FONT_TABBAR_TITLE];
    [self exp_addLeftItemTitle:@"" itemIcon:nil];
    [self exp_navigationBarColor:QZHKIT_COLOR_NAVIBAR_BACK hiddenShadow:NO];
    [self UIConfig];
    self.selectIndex = 0;
}
- (void)exp_leftAction{
    
    self.selectWeek(self.listArr);
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
    NSDictionary *dic = self.listArr[row];
    cell.nameLab.text = dic[@"week"];
    cell.selectBtn.tag = row;
    cell.selectBtn.selected = [dic[@"select"] boolValue];
    [cell.selectBtn addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];

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



#pragma mark --lazy
- (NSMutableArray *)listArr{
    if (!_listArr) {
        _listArr = [NSMutableArray arrayWithObjects:@{@"week":@"星期日",@"select":@"0",},@{@"week":@"星期一",@"select":@"0",},@{@"week":@"星期二",@"select":@"0",},@{@"week":@"星期三",@"select":@"0",},@{@"week":@"星期四",@"select":@"0",},@{@"week":@"星期五",@"select":@"0",},@{@"week":@"星期六",@"select":@"0",}, nil];
    }
    return _listArr;
}

- (void)selectAction:(UIButton *)sender{
    sender.selected = !sender.selected;
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:self.listArr[sender.tag]];
    if (sender.selected) {
        [dic setValue:@"1" forKey:@"select"];
    }else{
        [dic setValue:@"0" forKey:@"select"];
    }
    [self.listArr replaceObjectAtIndex:sender.tag withObject:dic];
}

@end
