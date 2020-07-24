//
//  HomeVC.m
//  DDSample
//
//  Created by 黄振 on 2020/3/24.
//  Copyright © 2020 KingYellow. All rights reserved.
//

#import "HomeVC.h"
#import "BWTopMenuView.h"
#import "HomeSelectCell.h"
#import "QZHDefaultButtonCell.h"
#import "HomeDetailVC.h"
#import "AddHomeVC.h"
#import "YCXMenu.h"
#import "AddQRCodeVC.h"
#import "DeviceListVC.h"
#import "AddDeviceWifiVC.h"
#import "AddHomeVC.h"
#import "RoomManageVC.h"
#import "DeviceSettingVC.h"

@interface HomeVC ()<UITableViewDelegate,UITableViewDataSource,TuyaSmartHomeManagerDelegate,UIPageViewControllerDelegate,UIPageViewControllerDataSource,TuyaSmartHomeDelegate,UIGestureRecognizerDelegate>
@property (strong, nonatomic)UITableView *qzTableView;
@property (copy, nonatomic)NSMutableArray *listArr;
@property (strong, nonatomic)TuyaSmartHomeManager *magager;
@property (strong, nonatomic)BWTopMenuView *topBtnsView;
@property (strong, nonatomic)UIButton *leftBtn;
@property (strong, nonatomic)UIButton *rightBtn;
@property (strong, nonatomic)NSMutableArray *items;
@property (assign, nonatomic)NSInteger selectIndex;

@property (strong, nonatomic)NSArray *arrVcs;
@property (strong, nonatomic)NSMutableArray *arrBtn;
@property (strong, nonatomic)UIView *bottomView;
@property (strong, nonatomic)UIPageViewController *pageVc;
@property (assign, nonatomic)NSInteger oldSelectIndex;
@property (assign, nonatomic)NSInteger currentIndex;
@property (strong, nonatomic)TuyaSmartHome *currentHome;
@end

@implementation HomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.selectIndex = 0;
    [self initConfig];
    [self getHomeList];
    
    [QZHNotification addObserver:self selector:@selector(InfoChangeToUpdateList) name:QZHNotificationKeyK1 object:nil];
    
}
- (void)initConfig{
    self.view.backgroundColor = QZHKIT_COLOR_LEADBACK;
//    self.navigationItem.title     QZHLoaclString(@"home_manage");
    [self exp_navigationBarTextWithColor:QZHKIT_COLOR_NAVIBAR_TITLE font:QZHKIT_FONT_TABBAR_TITLE];
    [self exp_navigationBarColor:QZHKIT_COLOR_NAVIBAR_BACK hiddenShadow:NO];
    self.leftBtn = [self exp_addLeftItemTitle:@"home" itemIcon:@""];
    [self exp_addRightItemTitle:QZHLoaclString(@"device_addDevice") itemIcon:@""];
    [self UIConfig];

}
- (void)UIConfig{
    [self.view addSubview:self.topBtnsView];
    [self.view addSubview:self.rightBtn];
    
    [QZHROOT_DELEGATE.window addSubview:self.qzTableView];
    self.qzTableView.backgroundColor = QZHKIT_Color_BLACK_26;
    self.qzTableView.frame = self.navigationController.view.frame;
    self.qzTableView.hidden = YES;
    [self.topBtnsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(0);
        make.right.mas_equalTo(-60);
        make.height.mas_equalTo(50);
    }];
    [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.mas_equalTo(0);
        make.height.mas_equalTo(50);
        make.width.mas_equalTo(60);
    }];
    

}
-(void)exp_leftAction{
    [self.qzTableView reloadData];
    self.qzTableView.hidden = NO;
}
 -(void)exp_rightAction{
     
     
     ///监控网络状态
     [QZHReachability reachability:^(QZHNetworkStatus status, NSString *describe) {
         if (status == QZHNetworkStatusReachableViaWiFi) {
             //TODO: 有WIFI
             [YCXMenu setTintColor:QZHKIT_COLOR_SKIN];
             [YCXMenu setSelectedColor:QZH_KIT_Color_WHITE_70];
             if ([YCXMenu isShow]){
                 [YCXMenu dismissMenu];
             } else {
                 [YCXMenu showMenuInView:self.tabBarController.view fromRect:CGRectMake(self.navigationController.view.frame.size.width - 50, QZHNAVI_HEIGHT, 50, 0) menuItems:self.items selected:^(NSInteger index, YCXMenuItem *item) {
                     NSLog(@"%@ %ld",item,index);
                     if (item.tag == 100) {
                         AddQRCodeVC *vc = [[AddQRCodeVC alloc] init];
                         vc.homemodel = self.listArr[self.selectIndex];
                         [self.navigationController pushViewController:[vc exp_hiddenTabBar] animated:YES];
                     }
             
                     if (item.tag == 101) {
                          AddDeviceWifiVC *vc = [[AddDeviceWifiVC alloc] init];
                          vc.homemodel = self.listArr[self.selectIndex];
                          [self.navigationController pushViewController:[vc exp_hiddenTabBar] animated:YES];
                     }
                 }];
             }
         }else{
             UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"需要开启手机wifi网络连接,才能添加设备" preferredStyle:UIAlertControllerStyleAlert];
             UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                 
             }];
             [alertC addAction:action];
             [self presentViewController:alertC animated:NO completion:nil];
             
         }
     }];
     

}
//初始化
//添加控制器
-(void)loadVcs:(TuyaSmartHome *)home{
    QZHWS(weakSelf)
    NSMutableArray *vcArr = [NSMutableArray array];
    for (int i=0; i <= home.roomList.count; i++) {
        DeviceListVC *vc = [[DeviceListVC alloc] init];
        vc.updateDevice = ^{
            [weakSelf getHomeList];
        };
        vc.addDevice = ^{
            [weakSelf exp_rightAction];
        };

        if (i>0) {
            TuyaSmartRoomModel *roommodel = home.roomList[i - 1];
            NSMutableArray *deviceArr = [NSMutableArray array];

            for (TuyaSmartDeviceModel *dmodel in home.deviceList) {
                if (roommodel.roomId == dmodel.roomId) {
                    [deviceArr addObject:dmodel];
                }
            }

            vc.listArr = deviceArr;
        }else{
            
            NSMutableArray *Arr = [NSMutableArray arrayWithArray:home.deviceList];
            [Arr addObjectsFromArray:home.sharedDeviceList];
            vc.listArr = Arr;
        }
        vc.homeModel = home.homeModel;
        [vcArr addObject:vc];
    }
    
    
    self.arrVcs = [NSArray arrayWithArray:vcArr];

    self.pageVc = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    [self.pageVc setViewControllers:@[self.arrVcs[0]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    self.pageVc.delegate = self;
    self.pageVc.dataSource = self;
    self.pageVc.view.frame = CGRectMake(0, 50, QZHScreenWidth, QZHScreenHeight-50);
    [self addChildViewController:self.pageVc];
    [self.pageVc didMoveToParentViewController:self];
    [self.view addSubview:self.pageVc.view];
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
//        UIButton *btn_current = self.arrBtn[self.currentIndex];
//        UIButton *btn_old = self.arrBtn[previousIndex];
//        btn_old.selected = NO;
//        btn_current.selected = YES;
        
        self.oldSelectIndex = self.currentIndex;
        [UIView animateWithDuration:0.25 animations:^{
            [self.topBtnsView setSelectButtonWithTag:self.oldSelectIndex];
//            self.bottomView.frame = CGRectMake(self.currentIndex * 60, 40, 60, 2);
        }];

    }
}

-(void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers{
    //pendingViewControllers:下一个控制器
    NSLog(@"pendingViewControllers === %@", pendingViewControllers);
    self.currentIndex = [self.arrVcs indexOfObject:pendingViewControllers.firstObject];
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

- (void)romeListAction:(UIButton *)sender{
    
    RoomManageVC *vc = [[RoomManageVC alloc] init];
    vc.homeModel = self.currentHome.homeModel;
    [self.navigationController pushViewController:[vc exp_hiddenTabBar] animated:YES];
}
#pragma mark -tableView
-(UITableView *)qzTableView{
    if (!_qzTableView) {
        _qzTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [_qzTableView exp_tableViewDefault];
        _qzTableView.bounces = NO;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
        tap.delegate = self;
        [self.qzTableView addGestureRecognizer:tap];
        self.qzTableView.backgroundColor = QZHKIT_COLOR_LEADBACK;
        self.qzTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        UIView *head = [[UIView alloc] init];
        head.frame  = CGRectMake(0, 0, 0, QZHHeightStatusBar);
        _qzTableView.tableHeaderView = head;
        _qzTableView.delegate = self;
        _qzTableView.dataSource = self;
        [self.qzTableView registerClass:[HomeSelectCell class] forCellReuseIdentifier:QZHCELL_REUSE_TEXT];
        [self.qzTableView registerClass:[QZHDefaultButtonCell class] forCellReuseIdentifier:QZHCELL_REUSE_DEFAULT];

    }
    return _qzTableView;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (section == 0) {
        
        HomeSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:QZHCELL_REUSE_TEXT];
        TuyaSmartHomeModel *model = self.listArr[row];
        
        cell.nameLab.text = model.name;
        if (model.dealStatus == TYHomeStatusPending) {
            cell.statusLab.text = QZHLoaclString(@"home_memberstatus_pending");
        }else{
            cell.statusLab.text = @"";
        }
        if (self.selectIndex == row) {
            cell.selectBtn.selected = YES;
        }else{
            cell.selectBtn.selected = NO;
        }

        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    }else{
        QZHDefaultButtonCell *cell = [tableView dequeueReusableCellWithIdentifier:QZHCELL_REUSE_DEFAULT];
        cell.nameLab.text = QZHLoaclString(@"home_addHome");
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
    
    return section==0?self.listArr.count:1;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.00001;
}
-(void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section{
    view.tintColor = QZHKIT_COLOR_LEADBACK;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    QZHWS(weakSelf)
    if (section == 0) {
        TuyaSmartHomeModel *model = self.listArr[row];
        self.currentHome =[TuyaSmartHome homeWithHomeId:model.homeId];
        self.currentHome.delegate = self;
        if (model.dealStatus == TYHomeStatusPending) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:QZHLoaclString (@"home_pendrecive") message:[NSString stringWithFormat:@"%@\"%@\"%@",QZHLoaclString(@"home_pendTextfirst"),model.name,QZHLoaclString(@"home_pendTextsecond")] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *reject = [UIAlertAction actionWithTitle:QZHLoaclString(@"home_rejectJoin") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self initMemberList:model accept:NO];
            }];
            UIAlertAction *accept = [UIAlertAction actionWithTitle:QZHLoaclString(@"home_acceptPend") style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                [self initMemberList:model accept:YES];

            }];
            [alert addAction:reject];
            [alert addAction:accept];
            [self presentViewController:alert animated:YES completion:nil];
        
        }else{
            [self.currentHome getHomeDetailWithSuccess:^(TuyaSmartHomeModel *homeModel) {
                 NSMutableArray  *arrm = [NSMutableArray array];
                 [arrm addObject:@"所有设备"];
                 for (TuyaSmartRoomModel *room in self.currentHome.roomList) {
                     [arrm addObject:room.name];
                 }
                 [self.leftBtn setTitle:model.name forState:UIControlStateNormal];
                 self.selectIndex = row;
                 self.topBtnsView.titleArray = arrm;

                [self loadVcs:self.currentHome];
                 self.qzTableView.hidden = YES;
                 
             } failure:^(NSError *error) {
                    [[QZHHUD HUD] textHUDWithMessage:error.userInfo[@"NSLocalizedDescription"] afterDelay:0.5];
             }];
        }
 
    }else{
        self.qzTableView.hidden = YES;
        AddHomeVC *vc = [[AddHomeVC alloc] init];
        vc.refresh = ^{
            
        };
        [self.navigationController pushViewController:[vc exp_hiddenTabBar] animated:YES];

    }
    
}

#pragma mark --lazy

- (NSMutableArray *)items {
    if (!_items) {
        
        // set title
        YCXMenuItem *menuTitle = [YCXMenuItem menuTitle:@"Menu" WithIcon:nil];
        menuTitle.foreColor = [UIColor whiteColor];
        menuTitle.titleFont = [UIFont boldSystemFontOfSize:20.0f];
    
        //set item
        _items = [@[
                    [YCXMenuItem menuItem:@"二维码配网"
                                    image:nil
                                      tag:100
                                 userInfo:@{@"title":@"Menu"}],
                    [YCXMenuItem menuItem:@"热点配网"
                                    image:nil
                                      tag:101
                                 userInfo:@{@"title":@"Menu"}]
                    ] mutableCopy];
    }
    return _items;
}
- (NSMutableArray *)listArr{
    if (!_listArr) {
        _listArr = [NSMutableArray array];
 
    }
    return _listArr;
}
-(BWTopMenuView *)topBtnsView{
    if (!_topBtnsView) {
        _topBtnsView = [[BWTopMenuView alloc] init];
        QZHWS(weakSelf)
        _topBtnsView.titleButtonClick = ^(NSInteger tag, UIButton * _Nonnull button) {
            [weakSelf btnAction:button];
        };
    }
    return _topBtnsView;
}
- (UIButton *)rightBtn{
    if (!_rightBtn) {
        _rightBtn = [[UIButton alloc] init];
        [_rightBtn setImage:QZHLoadIcon(@"pay_normal") forState:UIControlStateNormal];
        [_rightBtn addTarget:self action:@selector(romeListAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightBtn;
}

#pragma mark -- action
- (void)getHomeList {
    QZHWS(weakSelf)
   self.magager = [TuyaSmartHomeManager new];
    self.magager.delegate = self;
    [self.magager getHomeListWithSuccess:^(NSArray<TuyaSmartHomeModel *> *homes) {
        
        [weakSelf.listArr removeAllObjects];
        [weakSelf.listArr addObjectsFromArray:homes];
        [weakSelf.qzTableView reloadData];
         TuyaSmartHomeModel *model = self.listArr[self.selectIndex];
         self.currentHome =[TuyaSmartHome homeWithHomeId:model.homeId];
         self.currentHome.delegate = self;

        [self.currentHome getHomeDetailWithSuccess:^(TuyaSmartHomeModel *homeModel) {
             
              NSMutableArray  *arrm = [NSMutableArray array];
             [arrm addObject:@"所有设备"];
              for (TuyaSmartRoomModel *room in self.currentHome.roomList) {
                  [arrm addObject:room.name];
              }
              [self.leftBtn setTitle:model.name forState:UIControlStateNormal];
              self.topBtnsView.titleArray = arrm;
            [self loadVcs:self.currentHome];
            
         } failure:^(NSError *error) {
                [[QZHHUD HUD] textHUDWithMessage:error.userInfo[@"NSLocalizedDescription"] afterDelay:0.5];
         }];


    } failure:^(NSError *error) {
        NSLog(@"get home list failure: %@", error);
    }];
}
//加入拒绝家庭邀请
- (void)initMemberList:(TuyaSmartHomeModel *)homemodel accept:(BOOL)isaccept {
    QZHWS(weakSelf)
    TuyaSmartHome *home = [TuyaSmartHome homeWithHomeId:homemodel.homeId];
    [home joinFamilyWithAccept:isaccept success:^(BOOL result) {
        [weakSelf getHomeList];
    } failure:^(NSError *error) {
        [[QZHHUD HUD] textHUDWithMessage:error.userInfo[@"NSLocalizedDescription"] afterDelay:0.5];
    }];
}

#pragma mark  --家庭代理
// 添加一个家庭
- (void)homeManager:(TuyaSmartHomeManager *)manager didAddHome:(TuyaSmartHomeModel *)home {
    self.selectIndex = 0;
    [self getHomeList];
}

// 删除一个家庭
- (void)homeManager:(TuyaSmartHomeManager *)manager didRemoveHome:(long long)homeId {
   
    self.selectIndex = 0;
    [self getHomeList];

}

// 家庭的信息更新，例如name
- (void)homeDidUpdateInfo:(TuyaSmartHome *)home {
    [self getHomeList];
}

// 我收到的共享设备列表变化
- (void)homeDidUpdateSharedInfo:(TuyaSmartHome *)home {
    
}

// 家庭下新增房间代理回调
- (void)home:(TuyaSmartHome *)home didAddRoom:(TuyaSmartRoomModel *)room {
    if (home == self.currentHome) {
        [self getHomeList];

    }else{
        
    }
}

// 家庭下删除房间代理回调
- (void)home:(TuyaSmartHome *)home didRemoveRoom:(long long)roomId {
    
      [self getHomeList];
}

// 房间信息变更，例如name
- (void)home:(TuyaSmartHome *)home roomInfoUpdate:(TuyaSmartRoomModel *)room {
    [self getHomeList];
}
// 添加设备
- (void)home:(TuyaSmartHome *)home didAddDeivice:(TuyaSmartDeviceModel *)device {
    if (home == self.currentHome) {
            [self getHomeList];
    }
}

// 删除设备
- (void)home:(TuyaSmartHome *)home didRemoveDeivice:(NSString *)devId {
    if (home == self.currentHome) {
            [self getHomeList];
    }
}

// 设备信息更新，例如name
- (void)home:(TuyaSmartHome *)home deviceInfoUpdate:(TuyaSmartDeviceModel *)device {
    [self getHomeList];
}
// MQTT连接成功
- (void)serviceConnectedSuccess {
    // 刷新当前家庭UI
}

- (void)InfoChangeToUpdateList{
    [self getHomeList];
}
- (void)dismiss{
    self.qzTableView.hidden = YES;
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer*)gestureRecognizer shouldReceiveTouch:(UITouch*)touch {

    if ([touch.view isMemberOfClass:[UITableView class]]) {
        return YES;
    }
    return NO;

}
@end