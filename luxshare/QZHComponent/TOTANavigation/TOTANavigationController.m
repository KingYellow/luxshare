//
//  TOTANavigationController.m
//  DDSample
//
//  Created by 黄振 on 2020/4/21.
//  Copyright © 2020 KingYellow. All rights reserved.
//

#import "TOTANavigationController.h"
#import "TOTANavigationBar.h"
#import "UIViewController+TOTANavExp.h"
#import "TOTAUtils.h"
#import "UIView+EasyNavigationExt.h"

@interface TOTANavigationController ()<UINavigationControllerDelegate,UIGestureRecognizerDelegate>
@property (nonatomic,weak)id systemGestureTarget ;

@end

@implementation TOTANavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBar.hidden = YES;
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];

    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleDeviceOrientationDidChange:) name:UIDeviceOrientationDidChangeNotification object:nil
     ];
}

-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    // 移除全屏滑动手势
    if ([self.interactivePopGestureRecognizer.view.gestureRecognizers containsObject:self.systemGestureTarget]) {
        [self.interactivePopGestureRecognizer.view removeGestureRecognizer:self.systemGestureTarget];
    }
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (self.viewControllers.count > 0 ) {
           viewController.hidesBottomBarWhenPushed = YES;
       }
       
       viewController.currentNavBar = [[TOTANavigationBar alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH , NAV_HEIGHT)];
       
       kWeakSelf(self)
       if (self.viewControllers.count > 0) {
           UIImage *img =[UIImage imageNamed:@"nav_btn_back.png"] ;
           [viewController.currentNavBar addLeftButtonWithImage:img  clickCallBack:^(UIView *view) {
               [weakself popViewControllerAnimated:YES];
           }];
       }
       
       [viewController.view addSubview:viewController.currentNavBar];

       [super pushViewController:viewController animated:animated];

       
       TOTANavigationBar  *navView = self.topViewController.currentNavBar ;
       if (navView.width != self.topViewController.view.width) {
           navView.width = self.topViewController.view.width ;
       }
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return self.topViewController.statusBarStyle ;
}



- (void)pushViewControllerRetro:(UIViewController *)viewController {
    CATransition *transition = [CATransition animation];
    transition.duration = 1.25;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [self.view.layer addAnimation:transition forKey:nil];
    
    [self pushViewController:viewController animated:NO];
}

- (void)popViewControllerRetro {
    CATransition *transition = [CATransition animation];
    transition.duration = 0.25;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    [self.view.layer addAnimation:transition forKey:nil];
    
    [self popViewControllerAnimated:NO];
}

- (void)handleDeviceOrientationDidChange:(UIInterfaceOrientation)interfaceOrientation
{
    
    TOTANavigationBar  *navView = self.topViewController.currentNavBar ;
    if (nil == navView) {
        return ;
    }
    
    if (navView.width != self.topViewController.view.width) {
        navView.width = self.topViewController.view.width ;
    }
    [self setNeedsStatusBarAppearanceUpdate];
    
    //1.获取 当前设备 实例
    UIDevice *device = [UIDevice currentDevice] ;
    
    EasyLog(@" %@ = %@",NSStringFromCGRect(self.topViewController.view.frame) , NSStringFromCGRect(navView.frame));
    
    switch (device.orientation) {
        case UIDeviceOrientationUnknown: EasyLog(@"未知方向"); break;
            
        case UIDeviceOrientationFaceUp: EasyLog(@"屏幕朝上平躺"); break;
            
        case UIDeviceOrientationFaceDown:  EasyLog(@"屏幕朝下平躺");  break;
            
        case UIDeviceOrientationLandscapeLeft: EasyLog(@"屏幕向左横置");  break;
            
        case UIDeviceOrientationLandscapeRight: EasyLog(@"屏幕向右橫置"); break;
            
        case UIDeviceOrientationPortrait:  EasyLog(@"屏幕直立");  break;
            
        case UIDeviceOrientationPortraitUpsideDown: EasyLog(@"屏幕直立，上下位置调换了");  break;
            
        default: EasyLog(@"无法辨识"); break;
    }
    
}


#pragma mark - getter
//- (NSMutableDictionary *)navBarDictionary
//{
//    if (nil == _navBarDictionary) {
//        _navBarDictionary  = [NSMutableDictionary dictionaryWithCapacity:10];
//    }
//    return _navBarDictionary ;
//}

- (UIPanGestureRecognizer *)sideslipBackGesture
{
    if (nil == _sideslipBackGesture) {
        _sideslipBackGesture = [[UIPanGestureRecognizer alloc]init];
        _sideslipBackGesture.maximumNumberOfTouches = 1 ;
    }
    return _sideslipBackGesture ;
}
- (TOTACurrentBackGestureDelegate *)customBackGestureDelegate
{
    if (nil == _customBackGestureDelegate) {
        _customBackGestureDelegate = [[TOTACurrentBackGestureDelegate alloc]init];
        _customBackGestureDelegate.navController = self ;
        _customBackGestureDelegate.systemGestureTarget = self.systemGestureTarget ;
    }
    return _customBackGestureDelegate ;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
