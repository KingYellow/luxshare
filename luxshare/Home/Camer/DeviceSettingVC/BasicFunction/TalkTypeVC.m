//
//  TalkTypeVC.m
//  luxshare
//
//  Created by 黄振 on 2020/7/17.
//  Copyright © 2020 KingYellow. All rights reserved.
//

#import "TalkTypeVC.h"
#import "TalkTypeCell.h"


@interface TalkTypeVC ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic)UITableView *qzTableView;
@property (strong, nonatomic)NSMutableArray *listArr;
@property (strong, nonatomic)NSMutableArray *memberArr;
@property (strong, nonatomic)TuyaSmartHome *home;
@property (assign, nonatomic)NSInteger selectIndex;
@property (strong, nonatomic)UILabel *tipLab;
@end

@implementation TalkTypeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initConfig];
}
- (void)initConfig{
    self.view.backgroundColor = QZHKIT_COLOR_LEADBACK;
    self.navigationItem.title = QZHLoaclString(@"talkType");
    [self exp_navigationBarTextWithColor:QZHKIT_COLOR_NAVIBAR_TITLE font:QZHKIT_FONT_TABBAR_TITLE];
    [self exp_navigationBarColor:QZHKIT_COLOR_NAVIBAR_BACK hiddenShadow:NO];
    [self exp_addRightItemTitle:QZHLoaclString(@"save") itemIcon:@""];
    [self UIConfig];
    self.selectIndex = [[QZHDataHelper readValueForKey:@"talkType"] intValue];

}
- (void)UIConfig{
    [self.view addSubview:self.tipLab];
    [self.tipLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(15);
        make.right.mas_equalTo(-20);
    }];
    [self.view addSubview:self.qzTableView];
    
     [self.qzTableView mas_makeConstraints:^(MASConstraintMaker *make) {
         make.top.mas_equalTo(self.tipLab.mas_bottom).offset(15);
         make.left.bottom.right.mas_equalTo(0);
     }];
}
- (void)exp_rightAction{
    [QZHDataHelper saveValue:@(self.selectIndex) forKey:@"talkType"];
    self.refresh();
    [self.navigationController popViewControllerAnimated:YES];

}
#pragma mark -tableView
- (UITableView *)qzTableView{
    if (!_qzTableView) {
        _qzTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [_qzTableView exp_tableViewDefault];
        self.qzTableView.backgroundColor = QZHKIT_COLOR_LEADBACK;
        _qzTableView.delegate = self;
        _qzTableView.dataSource = self;
        _qzTableView.bounces = NO;
        [self.qzTableView registerClass:[TalkTypeCell class] forCellReuseIdentifier:QZHCELL_REUSE_TEXT];
    }
    return _qzTableView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = indexPath.row;
    TalkTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:QZHCELL_REUSE_TEXT];
    if (row == 0) {
        cell.nameLab.text = QZHLoaclString(@"talkOne");
        cell.tipLab.text = QZHLoaclString(@"talkOneTip");
    }else{
        cell.nameLab.text = QZHLoaclString(@"talkTwo");
        cell.tipLab.text = QZHLoaclString(@"talkTwoTip");
    }
    cell.selectBtn.tag = row;
    [cell.selectBtn addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];

    if (self.selectIndex != row) {
        cell.selectBtn.selected = YES;
    }else{
        cell.selectBtn.selected = NO;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
 
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
   
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 80;
    }else{
        return 80;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section{
    view.tintColor = QZHKIT_COLOR_LEADBACK;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

}


#pragma mark --lazy

- (TuyaSmartHome *)home{
    if (!_home) {
        self.home =[TuyaSmartHome homeWithHomeId:self.homeModel.homeId];
    }
    return _home;
}

- (void)selectAction:(UIButton *)sender{

    if (sender.tag == 0) {
        self.selectIndex = 1;
    }else{
        self.selectIndex = 0;
    }
    [self.qzTableView reloadData];
}
- (UILabel *)tipLab{
    if (!_tipLab) {
        _tipLab = [[UILabel alloc] init];
        _tipLab.font = QZHKIT_FONT_LISTCELL_DESCRIBE_TITLE;
        _tipLab.textColor = QZHKIT_Color_BLACK_26;
        _tipLab.numberOfLines = 0;
        _tipLab.text = QZHLoaclString(@"talkTip");
    }
    return  _tipLab;
}
@end
