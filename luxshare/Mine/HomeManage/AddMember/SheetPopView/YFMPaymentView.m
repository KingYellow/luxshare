//
//  YFMPaymentView.m
//  YFMBottomPayView
//
//  Created by YFM on 2018/8/7.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import "YFMPaymentView.h"

#import "PayTopTableViewCell.h"
#import <Masonry.h>

// 动态获取屏幕宽高
#define KScreenHeight ([UIScreen mainScreen].bounds.size.height)
#define KScreenWidth  ([UIScreen mainScreen].bounds.size.width)

#define KColorFromRGB(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define LineColor                KColorFromRGB(0xefefef)
#define CColor                   KColorFromRGB(0x666666)
#define DColor                   KColorFromRGB(0x999999)
#define RemindRedColor           KColorFromRGB(0xF05F50)

@interface YFMPaymentView ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic ,strong) NSArray *dataArr;
@property (nonatomic ,strong) UITableView *tableView;
@property (nonatomic ,strong) UIViewController *vc;
@property (strong, nonatomic)UIView *backView;
@property (nonatomic ,copy) NSString *totalBalance;

@end

@implementation YFMPaymentView
- (instancetype)initTotalPay:(NSString *)totalBalance vc:(UIViewController *)vc dataSource:(NSArray *)dataSource{
    if (self = [super init]) {
        self.vc = vc;
        self.totalBalance = totalBalance;
        self.dataArr = dataSource;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];

    [self initPop];
}

- (void)initPop {
    self.view.backgroundColor = QZHKIT_Color_BLACK_54;
    CGFloat height = 120;
    height += self.dataArr.count * 60;
    UIView *v = [[UIView alloc] init];
    [self.view addSubview:v];
    [self.view addSubview:self.backView];
    [self.backView addSubview:self.tableView];
    [v mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(self.backView.mas_top);
    }];

    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(height);
        make.bottom.mas_equalTo(-QZHHeightBottom + 12);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];

//
    QZHViewRadius(self.tableView, 12);
//
//    self.popupController.navigationBarHidden = YES;
    [v addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundTap)]];
}
- (UIView *)backView{
    if (!_backView) {
        _backView = [[UIView alloc] init];
    }
    return _backView;
}

- (void)closeBlockView {
    [self backgroundTap];
}

- (void)backgroundTap  {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = QZHColorWhite;
        _tableView.tableFooterView = [UIView new];
        
        UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 50)];
        v.backgroundColor = [UIColor whiteColor];
    
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, KScreenWidth-90, 50)];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = [NSString stringWithFormat:QZHLoaclString(@"roleSetting")];
        label.font = QZHKIT_FONT_LISTCELL_MAIN_TITLE;
        label.textColor = QZHKIT_Color_BLACK_87;
        label.numberOfLines = 1;
        [v addSubview:label];
        
        _tableView.tableHeaderView = v;
    }
    return _tableView;
}

#pragma mark === 富文本设置字体

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellId = [NSString stringWithFormat:@"PayTopTableViewCell%ld",indexPath.row];
    PayTopTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[PayTopTableViewCell alloc]initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:cellId];
    }
    [self configCell:cell data:[self.dataArr objectAtIndex:indexPath.row] indexPath:indexPath];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.001;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.currentIndex = indexPath.row;
    [self.tableView reloadData];
    self.payType(self.currentIndex);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self backgroundTap];
    });
}


- (void)configCell:(PayTopTableViewCell *)cell data:(NSDictionary *)data indexPath:(NSIndexPath *)indexPath{
    NSString *str = data[@"title"];
    cell.titleLabel.text = str;
    cell.desLabel.text = data[@"tip"];
    if (self.currentIndex == indexPath.row) {
        cell.stateView.image =  [UIImage imageNamed:@"pay_selected"];
    }else{
        cell.stateView.image =  [UIImage imageNamed:@"pay_normal"];
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
