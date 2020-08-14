//
//  HomeMessageVC.m
//  luxshare
//
//  Created by 黄振 on 2020/6/30.
//  Copyright © 2020 KingYellow. All rights reserved.
//

#import "HomeMessageVC.h"
#import "QZHMessageCell.h"

@interface HomeMessageVC ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic)UITableView *qzTableView;
@property (strong, nonatomic)NSMutableArray *modelArr;
@property (strong, nonatomic)MessageTopView *topView;
@property (strong, nonatomic)NSMutableArray *memberArr;
@property (strong, nonatomic)TuyaSmartHome *home;
@property (copy, nonatomic)NSMutableArray *listArr;
@property (strong, nonatomic)NSMutableArray *timeArr;
@property (strong, nonatomic)UIButton *rightBtn;
@property (assign, nonatomic)NSInteger page;
@property (strong, nonatomic)UIButton *deleteBtn;
@end

@implementation HomeMessageVC
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self checkNewMessage];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initConfig];
    [self resetArr];
    self.page = 0;
    [self getMessageList:self.page];
}
- (void)initConfig{
    self.view.backgroundColor = QZHKIT_COLOR_LEADBACK;
    [self exp_navigationBarTextWithColor:QZHKIT_COLOR_NAVIBAR_TITLE font:QZHKIT_FONT_TABBAR_TITLE];
    [self exp_navigationBarColor:QZHKIT_COLOR_NAVIBAR_BACK hiddenShadow:NO];

    [self UIConfig];
}
- (void)UIConfig{
    self.topView = [MessageTopView initmessagetopViewName:QZHLoaclString(@"home")];
    [self.topView.normalBtn addTarget:self action:@selector(setEditAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.topView.selectBtn addTarget:self action:@selector(setSelectAction:) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:self.topView];
    [self.view addSubview:self.qzTableView];
    [self.view addSubview:self.deleteBtn];
    [self.view bringSubviewToFront:self.deleteBtn];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(50);
    }];
     [self.qzTableView mas_makeConstraints:^(MASConstraintMaker *make) {
         make.edges.mas_equalTo(UIEdgeInsetsMake(50, 0, 0, 0 ));
     }];
    [self.deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(50);
    }];
}
-(void)rightAction{
    self.topView.normalBtn.hidden = NO;
    self.topView.selectBtn.hidden = YES;
    self.deleteBtn.hidden = YES;
    [self.qzTableView reloadData];

}
#pragma mark -tableView
-(UITableView *)qzTableView{
    QZHWS(weakSelf)
    if (!_qzTableView) {
        _qzTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [_qzTableView exp_tableViewDefault];
        self.qzTableView.backgroundColor = QZHKIT_COLOR_LEADBACK;
        self.qzTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _qzTableView.delegate = self;
        _qzTableView.dataSource = self;
        _qzTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            weakSelf.page = 0;
            [weakSelf.modelArr removeAllObjects];
            [weakSelf getMessageList:self.page];
        }];
        _qzTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            weakSelf.page++;
            [weakSelf getMessageList:weakSelf.page];
        }];
        [self.qzTableView registerClass:[QZHMessageCell class] forCellReuseIdentifier:QZHCELL_REUSE_TEXT];
    }
    return _qzTableView;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    TuyaSmartMessageListModel *model = self.listArr[section][row];
    
    QZHMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:QZHCELL_REUSE_TEXT];
    cell.nameLab.text = model.msgTypeContent;
    cell.contentLab.text = model.msgContent;

    cell.selectBtn.selected = [model.select boolValue];
    if (self.topView.selectBtn.hidden) {
        [cell.selectBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(0);
        }];
    }else{
        [cell.selectBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(20);
        }];
    }
    [cell.selectBtn addTarget:self action:@selector(selectBtn:) forControlEvents:UIControlEventTouchUpInside];
    cell.tagLab.text = model.dateTime;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
 
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.listArr.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.listArr.count > 0) {
        return  [self.listArr[section] count];

    }else{
        return 0;
    }
    
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NSString *dateStr = self.timeArr[section];

    UIView *view = [[UIView alloc] init];
    if ([dateStr containsString:@"-"]) {
        UILabel *lab = [[UILabel alloc] init];
        lab.text = [[dateStr componentsSeparatedByString:@"-"].firstObject stringByAppendingString:@"月"];
        lab.font = QZHKIT_FONT_LISTCELL_DESCRIBE_TITLE;
        lab.textColor = QZHKIT_Color_BLACK_54;
        lab.frame = CGRectMake(15, 20, 32, 20);
        [view addSubview:lab];
        UILabel *lab2 = [[UILabel alloc] init];
        lab2.text = [dateStr componentsSeparatedByString:@"-"].lastObject ;
        lab2.font = QZHKIT_FONT_LISTCELL_MAIN_TITLE;
        lab2.textColor = QZHKIT_Color_BLACK_87;
        lab2.frame = CGRectMake(47, 20, 80, 20);
        [view addSubview:lab2];
    }

    return view;

}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

     return 50;
}

-(void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section{
    view.tintColor = QZHKIT_COLOR_LEADBACK;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    QZHWS(weakSelf)

}
#pragma mark --lazy
- (NSMutableArray *)listArr{
    if (!_listArr) {
        _listArr = [NSMutableArray array];
    }
    return _listArr;
}
- (NSMutableArray *)modelArr{
    if (!_modelArr) {
        _modelArr = [NSMutableArray array];
    }
    return _modelArr;
}
- (NSMutableArray *)timeArr{
    if (!_timeArr) {
        _timeArr = [NSMutableArray array];
    }
    return _timeArr;
}
-(UIButton *)deleteBtn{
    if (!_deleteBtn) {
        _deleteBtn = [[UIButton alloc] init];
        [_deleteBtn setTitle:QZHLoaclString(@"delete") forState:UIControlStateNormal];
        _deleteBtn.titleLabel.font = QZHKIT_FONT_LISTCELL_MAIN_TITLE;
        _deleteBtn.backgroundColor = QZHKIT_COLOR_SKIN;
        _deleteBtn.hidden = YES;
        [_deleteBtn addTarget:self action:@selector(deleteMessage) forControlEvents:UIControlEventTouchUpInside];
        [self.deleteBtn addObserver:self forKeyPath:@"hidden" options:NSKeyValueObservingOptionNew context:@"hidden_button"];
    }
    return _deleteBtn;
}
//-(TuyaSmartHome *)home{
//    if (!_home) {
//        self.home =[TuyaSmartHome homeWithHomeId:self.homeModel.homeId];
//    }
//    return _home;
//}
- (void)resetArr{
    //其中modelarr为需要分类的数组，listArr为分好组的数组。

    //首先把原数组中数据的日期取出来放入timeArr

    [self.listArr removeAllObjects];
    [self.timeArr removeAllObjects];

    [self.modelArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {

        TuyaSmartMessageListModel *currentmodel = obj;

        NSString *time1 = currentmodel.dateTime;

        NSString *month1 = [[[[time1 componentsSeparatedByString:@" "] firstObject] componentsSeparatedByString:@"-"] objectAtIndex:1];

        NSString *day1=[[[[time1 componentsSeparatedByString:@" "] firstObject] componentsSeparatedByString:@"-"] objectAtIndex:2];
        if (day1.length == 1) {
            day1 = [@"0" stringByAppendingString:day1];
        }

        NSString *currentStr1=[NSString stringWithFormat:@"%@-%@",month1,day1];
        
        [self.timeArr addObject:currentStr1];

     }];

//使用asset把timeArr的日期去重

    NSSet *set = [NSSet setWithArray:self.timeArr];

    NSArray *userArray = [set allObjects];

    NSSortDescriptor *sd1 = [NSSortDescriptor sortDescriptorWithKey:nil ascending:NO];//yes升序排列，no,降序排列
    //按日期降序排列的日期数组

     NSArray *myary = [userArray sortedArrayUsingDescriptors:[NSArray arrayWithObjects:sd1, nil]];

    //此时得到的myary就是按照时间降序排列拍好的数组

    [self.timeArr removeAllObjects];
    [self.timeArr addObjectsFromArray:myary];
     //遍历myary把_titleArray按照myary里的时间分成几个组每个组都是空的数组

    [myary enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {

        NSMutableArray *arr=[NSMutableArray array];

        [self.listArr addObject:arr];

    }];

    //遍历_dataArray取其中每个数据的日期看看与myary里的那个日期匹配就把这个数据装到_titleArray 对应的组中

     [self.modelArr enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {

        TuyaSmartMessageListModel *currentmodel = obj;
         if (self.topView.selectBtn.selected) {
             currentmodel.select = @"1";
         }else{
             if (currentmodel.select) {

             }else{
                 currentmodel.select = @"0";

             }
         }

        NSString *time1 = currentmodel.dateTime;

         NSString *month1=[[[[time1 componentsSeparatedByString:@" "] firstObject] componentsSeparatedByString:@"-"] objectAtIndex:1];

         NSString *day1=[[[[time1 componentsSeparatedByString:@" "] firstObject] componentsSeparatedByString:@"-"] objectAtIndex:2];
         if (day1.length == 1) {
             day1 = [@"0" stringByAppendingString:day1];
         }

        NSString *currentStr1=[NSString stringWithFormat:@"%@-%@",month1,day1];

        for (NSString *str in myary)

        {
            if([str isEqualToString:currentStr1])

            {
                NSMutableArray *arr=[self.listArr objectAtIndex:[myary indexOfObject:str]];
                [arr addObject:currentmodel];
            }

        }
    }];
    
    [self.qzTableView reloadData];
}
#pragma mark -- action
//topview 的选择按钮
- (void)setSelectAction:(UIButton *)sender{
    sender.selected = !sender.selected;
    if (sender.selected) {
        [self allselected];
        self.deleteBtn.hidden = NO;
    }else{
        [self allunselected];
        self.deleteBtn.hidden = YES;
    }
    [self.qzTableView reloadData];

}
- (void)setEditAction:(UIButton *)sender{
    sender.hidden = YES;
    self.deleteBtn.hidden = ![self ishasselexted];
    self.topView.selectBtn.hidden = NO;
    self.btnAction(YES);
    [self.qzTableView reloadData];

}
//cell的选择按钮
- (void)selectBtn:(UIButton *)sender{
    
    sender.selected = !sender.selected;

    UITableViewCell *cell = (UITableViewCell *)sender.superview;
   NSIndexPath *index = [self.qzTableView indexPathForCell:cell];
    TuyaSmartMessageListModel *model = self.listArr[index.section][index.row];
    if (sender.selected) {
        model.select = @"1";
    }else{
        model.select = @"0";
    }
    self.deleteBtn.hidden = ![self ishasselexted];
    self.topView.selectBtn.selected = [self isallselexted];
    [self.qzTableView reloadData];

  
}

- (void)getMessageList:(NSInteger) page{
    QZHWS(weakSelf)
    [[TuyaSmartMessage new] getMessageListWithType:2 limit:10 offset:self.modelArr.count success:^(NSArray<TuyaSmartMessageListModel *> *list) {
        [weakSelf.modelArr addObjectsFromArray:list];
        [weakSelf resetArr];
        [weakSelf.qzTableView.mj_footer endRefreshing];
        [weakSelf.qzTableView.mj_header endRefreshing];
        
    } failure:^(NSError *error) {
        [[QZHHUD HUD] textHUDWithMessage:error.userInfo[@"NSLocalizedDescription"] afterDelay:0.5];
    }];
}
    ///消息类型（1 - 告警，2 - 家庭，3 - 通知）
-(void)deleteMessage{
    QZHWS(weakSelf)
    [[TuyaSmartMessage new] deleteMessageWithType:2 ids:[self deleteMessageIds] msgSrcIds:nil success:^{
        [[QZHHUD HUD] textHUDWithMessage:QZHLoaclString(@"handleSuccess") afterDelay:0.5];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (weakSelf.topView.selectBtn.selected && [self ishasselexted]) {
            }else{
                weakSelf.deleteBtn.hidden = YES;
            }
            [weakSelf.qzTableView.mj_header beginRefreshing];
        });
    } failure:^(NSError *error) {
           [[QZHHUD HUD] textHUDWithMessage:error.userInfo[@"NSLocalizedDescription"] afterDelay:0.5];
    }];
}

-(void)checkNewMessage{
    QZHWS(weakSelf)
    [[TuyaSmartMessage new] getLatestMessageWithSuccess:^(NSDictionary *result) {

        if ([result[@"family"] boolValue]) {
            [weakSelf.modelArr removeAllObjects];
            [weakSelf getMessageList:0];
        }
    } failure:^(NSError *error) {
       [[QZHHUD HUD] textHUDWithMessage:error.userInfo[@"NSLocalizedDescription"] afterDelay:0.5];
    }];
}
- (BOOL)isallselexted{
    
    for (NSArray *arr in self.listArr) {
        for (TuyaSmartMessageListModel *model in arr) {
            if ([model.select isEqualToString:@"0"]) {
                return NO;
            }
        }
    }

    return YES;
}
- (BOOL)ishasselexted{
    
    for (NSArray *arr in self.listArr) {
        for (TuyaSmartMessageListModel *model in arr) {
            if ([model.select isEqualToString:@"1"]) {
                return YES;
            }
        }
    }

    return NO;
}
- (void)allselected{
    for (NSArray *arr in self.listArr) {
        for (TuyaSmartMessageListModel *model in arr) {
            model.select = @"1";
        }
    }
}
- (void)allunselected{
    for (NSArray *arr in self.listArr) {
        for (TuyaSmartMessageListModel *model in arr) {
            model.select = @"0";
        }
    }
}

- (NSMutableArray *)deleteMessageIds{
    NSMutableArray *messagearr = [NSMutableArray array];
    for (NSArray *arr in self.listArr) {
        for (TuyaSmartMessageListModel *model in arr) {
            if ([model.select isEqualToString:@"1"]) {
                [messagearr addObject:model.msgId];
            }
        }
    }
    return messagearr;
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    UIButton *button = (UIButton *)object;
    if (self.deleteBtn == button && [@"hidden" isEqualToString:keyPath]) {
        if (self.deleteBtn.hidden == YES) {
            [self.qzTableView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(0);
            }];
        }else{
            [self.qzTableView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(-50);
            }];
        }
    }
}
@end
