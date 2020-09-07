//
//  UIViewController+Exp.m
//  DDSample
//
//  Created by 黄振 on 2020/3/30.
//  Copyright © 2020 KingYellow. All rights reserved.
//

#import "UIViewController+Exp.h"

@implementation UIViewController (Exp)

+ (void)load {
    [super load];
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method viewWillDisappear = class_getInstanceMethod(self, @selector(customViewWillDisappear:));
        Method viewDidAppear = class_getInstanceMethod(self, @selector(customViewDidAppear:));
        
        Method customViewWillDisappear = class_getInstanceMethod(self, @selector(viewWillDisappear:));
        Method customViewDidAppear = class_getInstanceMethod(self, @selector(viewDidAppear:));
        method_exchangeImplementations(viewWillDisappear, customViewWillDisappear);
        method_exchangeImplementations(viewDidAppear, customViewDidAppear);
    });
}

- (void)customViewDidAppear:(BOOL)animated {
    [self customViewDidAppear:animated];
    
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    if (self.navigationController.childViewControllers.count == 1) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    } else {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
    QZHWS(weakSelf);
    [self jk_backButtonTouched:^(UIViewController *vc) {
        [weakSelf exp_leftAction];
    }];
//    self.navigationController.navigationBar.layer.shadowOffset = CGSizeMake(0, 5);
//    self.navigationController.navigationBar.layer.shadowOpacity = 0.2;
//    self.navigationController.navigationBar.layer.shadowColor = QZHColorBlack.CGColor;
}

- (void)customViewWillDisappear:(BOOL)animated {
    [self customViewWillDisappear:animated];
    
    if ([NSStringFromClass(self.class) isEqualToString:@"UICompatibilityInputViewController"]) {
        return;
    }
    if ([NSStringFromClass(self.class) isEqualToString:@"UIInputWindowController"]) {
        return;
    }
    if ([NSStringFromClass(self.class) isEqualToString:@"UISystemKeyboardDockController"]) {
        return;
    }
    
    [[QZHHUD HUD] hiddenHUD];
}

/**
 设置透明导航栏
 */
- (void)exp_navigationBarTrans {
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self exp_navigationBarTextWithColor:QZHKIT_COLOR_NAVIBAR_TITLE font:QZHKIT_FONT_NAVIBAR_TITLE];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.tintColor = QZHKIT_COLOR_NAVIBAR_TITLE;
    
//    self.navigationController.delegate = self;
}

/**
 设置导航栏颜色

 @param color 颜色
 @param show 是否隐藏阴影
 */
- (void)exp_navigationBarColor:(UIColor *)color hiddenShadow:(BOOL)show {
    self.navigationController.navigationBar.translucent = NO;
    if (color) {
        [self.navigationController.navigationBar setBarTintColor:color];
    } else {
        [self.navigationController.navigationBar setBackgroundImage:QZHLoadIcon(QZHICON_NAVI_BACK) forBarMetrics:UIBarMetricsDefault];
    }
    self.navigationController.navigationBar.tintColor = QZHKIT_COLOR_NAVIBAR_TITLE;
    [self exp_navigationBarTextWithColor:QZHKIT_COLOR_NAVIBAR_TITLE font:QZHKIT_FONT_NAVIBAR_TITLE];
//    [self exp_navigationBarShadowHidden:show];
    
//    self.navigationController.delegate = self;
}

/**
 设置导航栏文字颜色、字体大小

 @param color 颜色
 @param font 字体大小
 */
- (void)exp_navigationBarTextWithColor:(UIColor *)color font:(UIFont *)font {
    if (!color) {
        color = QZHKIT_COLOR_NAVIBAR_TITLE;
    }
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: color, NSFontAttributeName: font}];
}

/**
 隐藏导航栏阴影
 */
- (void)exp_navigationBarShadowHidden:(BOOL)hidden {
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
    UIImageView *shadow = self.navigationController.navigationBar.subviews.firstObject.subviews.lastObject;
    shadow.hidden = hidden;
}

/**
 添加导航栏

 @return UINavigationController
 */
- (UIViewController *)exp_addNavigation {
    UINavigationController *naviCtrl = [[UINavigationController alloc] initWithRootViewController:self];
    return naviCtrl;
}

/**
 隐藏底部栏
 
 @return vc
 */
- (UIViewController *)exp_hiddenTabBar {
    self.hidesBottomBarWhenPushed = YES;
    
    return self;
}

/**
 添加左边item
 
 @return 左边按钮
 */
- (UIButton *)exp_addLeftItemTitle:(NSString *)title itemIcon:(NSString *)icon {
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, 164, 44)];
    button.titleLabel.font = QZHKIT_FONT_NAVIBAR_ITEM_TITLE;
    
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [button setTitleColor:QZHKIT_COLOR_NAVIBAR_ITEM forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:self action:@selector(exp_leftAction) forControlEvents:UIControlEventTouchUpInside];
    if (!icon) {
        [button setImage:QZHLoadIcon(QZHICON_BACK_ITEM) forState:UIControlStateNormal];
    } else {
        [button setImage:QZHLoadIcon(icon) forState:UIControlStateNormal];
    }
    button.imageView.contentMode = UIViewContentModeScaleAspectFill;
    button.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = item;
    return button;
}

/**
 添加右边item
 
 @return 右边按钮
 */
- (UIButton *)exp_addRightItemTitle:(NSString *)title itemIcon:(NSString *)icon {
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 44)];

    if (title.length> 3) {
        button.frame = CGRectMake(0, 0, 180, 44);
    }
    button.titleLabel.font = QZHKIT_FONT_NAVIBAR_ITEM_TITLE;
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [button setTitleColor:QZH_KIT_Color_WHITE_100 forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:self action:@selector(exp_rightAction) forControlEvents:UIControlEventTouchUpInside];
    [button setImage:QZHLoadIcon(icon) forState:UIControlStateNormal];
    button.imageView.contentMode = UIViewContentModeScaleAspectFill;
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = item;
    return button;
}

- (void)exp_leftAction {
    if (self.navigationController.childViewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    if (self.navigationController.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
        return;
    }
}

- (void)exp_rightAction {
    
}

- (void)exp_statusBarStyle:(UIBarStyle)barStyle {
    [self.navigationController.navigationBar setBarStyle:barStyle];
}

/// 下拉刷新
- (void)refreshHandler {
    
}

/// 上拉加载
- (void)loadMoreHandler {
    
}

@end
