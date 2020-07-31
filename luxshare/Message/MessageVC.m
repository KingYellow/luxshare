//
//  MessageVC.m
//  luxshare
//
//  Created by 黄振 on 2020/6/27.
//  Copyright © 2020 KingYellow. All rights reserved.
//

#import "MessageVC.h"
#import "HomeMessageVC.h"
#import "WarningVC.h"
#import "NoticationVC.h"
#import "MessageSettingVC.h"

@interface MessageVC ()<UIPageViewControllerDelegate,UIPageViewControllerDataSource>
@property (strong, nonatomic)NSArray *arrVcs;
@property (strong, nonatomic)NSMutableArray *arrBtn;
@property (strong, nonatomic)UIView *bottomView;
@property (strong, nonatomic)UIPageViewController *pageVc;
@property (assign, nonatomic)NSInteger oldSelectIndex;
@property (assign, nonatomic)NSInteger currentIndex;
@property (strong, nonatomic)UIButton *rightBtn;
@property (strong, nonatomic)UIButton *setBtn;
@property (strong, nonatomic)UIView *titleView;
@property (strong, nonatomic)UILabel *titleLab;

@property (strong, nonatomic)HomeMessageVC *homeVc;
@property (strong, nonatomic)WarningVC *warningVc;
@property (strong, nonatomic)NoticationVC *notificationVc;

@end

@implementation MessageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self exp_navigationBarTextWithColor:QZHKIT_COLOR_NAVIBAR_TITLE font:QZHKIT_FONT_TABBAR_TITLE];
    self.view.backgroundColor = QZHColorWhite;
    [self exp_navigationBarTrans];
    [self exp_navigationBarColor:QZHKIT_COLOR_NAVIBAR_BACK hiddenShadow:NO];
    // Do any additional setup after loading the view.
    self.rightBtn =  [self exp_addRightItemTitle:QZHLoaclString(@"finish") itemIcon:@""];
//    self.setBtn =  [self exp_addRightItemTitle:@"" itemIcon:@"pay_normal"];
    [self.rightBtn setImage:QZHLoadIcon(@"pay_normal") forState:UIControlStateNormal];
    [self.rightBtn setImage:[UIImage new] forState:UIControlStateSelected];
    [self.rightBtn setTitle:@"" forState:UIControlStateNormal];
    [self.rightBtn setTitle:QZHLoaclString(@"finish") forState:UIControlStateSelected];
    self.navigationItem.title = @"编辑";
    [self loadVcs];
}

-(void)exp_rightAction{
    if (!self.rightBtn.selected) {
        MessageSettingVC *vc = [[MessageSettingVC alloc] init];
        [self.navigationController pushViewController:[vc exp_hiddenTabBar] animated:YES];
        
    }else{
        self.rightBtn.selected = !self.rightBtn.selected;
        self.navigationItem.titleView = self.titleView;
        if (self.oldSelectIndex == 0) {
            [self.warningVc rightAction];

        }else if (self.oldSelectIndex  == 1){
            [self.homeVc rightAction];
        }else{
            [self.notificationVc rightAction];
        }
    }

}

//初始化
//添加控制器
-(void)loadVcs{
    QZHWS(weakSelf)

    self.navigationItem.titleView = self.titleView;
    self.homeVc = [[HomeMessageVC alloc] init];
    self.homeVc.btnAction = ^(BOOL isselected) {
        weakSelf.navigationItem.titleView = weakSelf.titleLab;
        weakSelf.rightBtn.selected = YES;

    };
    self.warningVc = [[WarningVC alloc] init];
    self.warningVc.btnAction = ^(BOOL isselected) {
         weakSelf.navigationItem.titleView = weakSelf.titleLab;
         weakSelf.rightBtn.selected = YES;
     };
    self.notificationVc = [[NoticationVC alloc] init];
    self.notificationVc.btnAction = ^(BOOL isselected) {
         weakSelf.navigationItem.titleView = weakSelf.titleLab;
         weakSelf.rightBtn.selected = YES;
     };
    self.arrVcs = [NSArray arrayWithObjects:self.warningVc, self.homeVc,  self.notificationVc, nil];
    
    self.pageVc = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    [self.pageVc setViewControllers:@[self.arrVcs[0]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    self.pageVc.delegate = self;
    self.pageVc.dataSource = self;
    self.pageVc.view.frame = CGRectMake(0, 0, QZHScreenWidth, QZHScreenHeight);
    [self addChildViewController:self.pageVc];
    [self.pageVc didMoveToParentViewController:self];
    [self.view addSubview:self.pageVc.view];
}
//点击按钮事件
#pragma mark ----按钮点击事件
-(void)btnAction:(UIButton *)sender{
    sender.selected = YES;
    NSInteger newSelectIndex = sender.tag - 888;
    if (self.oldSelectIndex == newSelectIndex) {
        
    }else{
        UIViewController *vc = self.arrVcs[newSelectIndex];
        if (self.oldSelectIndex > newSelectIndex) {
            [self.pageVc setViewControllers:@[vc] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:^(BOOL finished) {
            }];
        }else{
            [self.pageVc setViewControllers:@[vc] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:^(BOOL finished) {
            }];
        }
        UIButton *btn_old = self.arrBtn[self.oldSelectIndex];
        btn_old.selected = NO;
        self.oldSelectIndex = newSelectIndex;
        [UIView animateWithDuration:0.25 animations:^{
            self.bottomView.frame = CGRectMake(newSelectIndex * 60, 40, 60, 2);
        }];
    }
}
//DataSource方法
#pragma mark 返回上一个ViewController对象
-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController{
    
    NSInteger nowIndex = [self.arrVcs indexOfObject:viewController];
    if (nowIndex == 0) {
        return nil;
    }else{
        return self.arrVcs[nowIndex - 1];
    }
}

#pragma mark 返回下一个ViewController对象
-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController{
    NSInteger nowIndex = [self.arrVcs indexOfObject:viewController];
    if (nowIndex == self.arrVcs.count - 1) {
        return nil;
    }else{
        return self.arrVcs[nowIndex + 1];
    }
}
//代理方法
-(void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed{
    //previousViewControllers:上一个控制器
    if (!completed) {
        return;
    }
    NSLog(@"previousViewControllers == %@", previousViewControllers.lastObject);
    UIViewController *vc = previousViewControllers.firstObject;
    NSInteger previousIndex = [self.arrVcs indexOfObject:vc];
    if (previousIndex == self.currentIndex) {
        
    }else{
        UIButton *btn_current = self.arrBtn[self.currentIndex];
        UIButton *btn_old = self.arrBtn[previousIndex];
        btn_old.selected = NO;
        btn_current.selected = YES;
        
        self.oldSelectIndex = self.currentIndex;
        [UIView animateWithDuration:0.25 animations:^{
            self.bottomView.frame = CGRectMake(self.currentIndex * 60, 40, 60, 2);
        }];

    }
}

-(void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers{
    //pendingViewControllers:下一个控制器
    NSLog(@"pendingViewControllers === %@", pendingViewControllers);
    self.currentIndex = [self.arrVcs indexOfObject:pendingViewControllers.firstObject];
}
/**
msgType    消息类型（1 - 告警，2 - 家庭，3 - 通知）
limit    每页请求数据数
offset    已请求到的消息总数
 */

- (UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.textColor = QZH_KIT_Color_WHITE_70;
        _titleLab.font = QZHKIT_FONT_NAVIBAR_TITLE;
        _titleLab.text = QZHLoaclString(@"edit");
    }
    return _titleLab;
}
-(UIView *)titleView{
    if (!_titleView) {

        self.titleView = [[UIView alloc] init];
        self.titleView.frame = CGRectMake(0, 0, 180, 44);
        
        NSArray *picarr = @[@"home_1",@"book_1",@"mine_1"];
        self.bottomView = [[UIView alloc] init];
        self.bottomView.backgroundColor = QZHColorYellow;
        self.bottomView.frame = CGRectMake(0, 40, 60, 2);
        [self.titleView addSubview:self.bottomView];
        
        self.arrBtn =[NSMutableArray array];
        for (int i=0; i<3; i++) {
            UIButton *b = [[UIButton alloc] init];
            [b setImage:QZHLoadIcon(picarr[i]) forState:UIControlStateNormal];
            [b setTitleColor:QZHColorRed forState:UIControlStateSelected];
            [b addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
            b.tag = 888 + i;
            b.frame = CGRectMake(60 * i, 0, 60, 40);
            [self.titleView addSubview:b];
            [self.arrBtn addObject:b];
        }
    }
    return _titleView;
}
-(UIButton *)setBtn{
    if (!_setBtn) {
        _setBtn = [[UIButton alloc] init];
        [_setBtn setImage:QZHLoadIcon(@"pay_normal") forState:UIControlStateNormal];
    }
    return _setBtn;
}
@end
