//
//  QZHHUD.m
//  MobileCustomerService
//
//  Created by 黄振 on 2017/9/5.
//  Copyright © 2017年 🐨🐨🐨. All rights reserved.
//

#import "QZHHUD.h"
#import "MBProgressHUD.h"
#import "QZHHUDImageView.h"

@interface QZHHUD ()

@property (nonatomic, strong) UIView *targetView;
@property (nonatomic, strong) MBProgressHUD *loadHUD;
@property (nonatomic, strong) MBProgressHUD *textHUD;


@end

@implementation QZHHUD

/**
 单例

 @return QZHHUD实例
 */
+ (QZHHUD *)HUD {
    static QZHHUD *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[QZHHUD alloc] init];
    });
    
    return instance;
}

- (void)setOffset:(CGPoint)offset {
    _offset = offset;
    if (offset.y == -9999) {
        _offset = CGPointMake(0, -50);
    }
}

- (void)setTextColor:(UIColor *)textColor {
    _textColor = textColor;
    
    if (!textColor) {
        _textColor = UIColor.blackColor;
    }
}

#pragma makr - 加载提示HUD

/**
 加载中HUD，使用系统activity
 */
- (void)loadingHUD {
    QZHWS(weakSelf);
    dispatch_async(dispatch_get_main_queue(), ^{
        weakSelf.loadHUD.mode = MBProgressHUDModeIndeterminate;
        weakSelf.loadHUD.label.text = nil;
        weakSelf.loadHUD.customView = nil;
        weakSelf.loadHUD.offset = weakSelf.offset;
        weakSelf.loadHUD.removeFromSuperViewOnHide = YES;
        weakSelf.loadHUD.delegate = [weakSelf exp_getCurrentVC];
        [weakSelf showHUD:weakSelf.loadHUD afterDelay:-1];
    });
}

/**
 加载中HUD

 @param imageNamed 自定义加载中图片
 */
//- (void)loadingHUDWithImage:(NSString *)imageNamed {
//    QZHWS(weakSelf);
//    dispatch_async(dispatch_get_main_queue(), ^{
////        weakSelf.loadHUD = [[MBProgressHUD alloc] initWithView:weakSelf.targetView];
//        weakSelf.loadHUD.mode = MBProgressHUDModeCustomView;
//        weakSelf.loadHUD.customView = [weakSelf gifViewWithLocal:imageNamed];
//        weakSelf.loadHUD.bezelView.color = [UIColor clearColor];
//        weakSelf.loadHUD.offset = weakSelf.offset;
//        weakSelf.loadHUD.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
//        weakSelf.loadHUD.label.text = nil;
//        weakSelf.loadHUD.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
//        weakSelf.loadHUD.removeFromSuperViewOnHide = YES;
//
//        weakSelf.loadHUD.delegate = [weakSelf exp_getCurrentVC];
//        [weakSelf showHUD:weakSelf.loadHUD afterDelay:-1];
//    });
//}

/**
 加载中HUD
 
 @param message 使用系统activity并显示的文字
 */
- (void)loadingHUDWithMessage:(NSString *)message {
    QZHWS(weakSelf);
    dispatch_async(dispatch_get_main_queue(), ^{
//        weakSelf.loadHUD = [[MBProgressHUD alloc] initWithView:weakSelf.targetView];
        weakSelf.loadHUD.mode = MBProgressHUDModeIndeterminate;
        weakSelf.loadHUD.label.text = message;
        weakSelf.loadHUD.offset = self.offset;
        weakSelf.loadHUD.customView = nil;
        weakSelf.loadHUD.removeFromSuperViewOnHide = YES;
        weakSelf.loadHUD.delegate = [weakSelf exp_getCurrentVC];
        [weakSelf showHUD:weakSelf.loadHUD afterDelay:-1];
    });
}

/**
 加载中HUD

 @param imageNamed 自定义图片
 @param message 同时显示的文字
 */
//- (void)loadingHUDWithImage:(NSString *)imageNamed message:(NSString *)message {
//    QZHWS(weakSelf);
//    dispatch_async(dispatch_get_main_queue(), ^{
////        weakSelf.loadHUD = [[MBProgressHUD alloc] initWithView:weakSelf.targetView];
//        weakSelf.loadHUD.mode = MBProgressHUDModeCustomView;
//        weakSelf.loadHUD.customView = [weakSelf gifViewWithLocal:imageNamed];
//        weakSelf.loadHUD.offset = self.offset;
//        weakSelf.loadHUD.label.text = message;
//        weakSelf.loadHUD.removeFromSuperViewOnHide = YES;
//        weakSelf.loadHUD.delegate = [weakSelf exp_getCurrentVC];
//        [weakSelf showHUD:weakSelf.loadHUD afterDelay:-1];
//    });
//}

#pragma mark - 文字提示信息HUD

/**
 纯文字提示HUD

 @param message 自定义文字提示
 */
- (QZHHUD *)textHUDWithMessage:(NSString *)message afterDelay:(NSTimeInterval)delay {
    QZHWS(weakSelf);
    dispatch_async(dispatch_get_main_queue(), ^{
        weakSelf.textHUD = [[MBProgressHUD alloc] initWithView:self.targetView];
        weakSelf.textHUD.mode = MBProgressHUDModeText;
        weakSelf.textHUD.label.textColor = weakSelf.textColor;
        weakSelf.textHUD.label.text = message;
        weakSelf.textHUD.label.numberOfLines = 0;
        weakSelf.textHUD.offset = weakSelf.offset;
        weakSelf.textHUD.removeFromSuperViewOnHide = YES;
        weakSelf.textHUD.delegate = [weakSelf exp_getCurrentVC];
        [weakSelf showHUD:weakSelf.textHUD afterDelay:delay];
    });
    
    return [QZHHUD HUD];
}

/**
 activity与文字提示HUD
 
 @param message 自定义文字提示
 */
- (QZHHUD *)textActivityWithMessage:(NSString *)message afterDelay:(NSTimeInterval)delay {
    QZHWS(weakSelf);
    dispatch_async(dispatch_get_main_queue(), ^{
        weakSelf.textHUD = [[MBProgressHUD alloc] initWithView:self.targetView];
        weakSelf.textHUD.mode = MBProgressHUDModeIndeterminate;
        weakSelf.textHUD.label.text = message;
        weakSelf.textHUD.label.numberOfLines = 0;
        weakSelf.textHUD.offset = weakSelf.offset;
        weakSelf.textHUD.removeFromSuperViewOnHide = YES;
        weakSelf.textHUD.delegate = [weakSelf exp_getCurrentVC];
        [weakSelf showHUD:weakSelf.textHUD afterDelay:delay];
    });
    
    return [QZHHUD HUD];
}

/**
 文字图片提示HUD

 @param imageNamed 自定义图片
 @param message 提示文字
 */
//- (QZHHUD *)textHUDWithImage:(NSString *)imageNamed message:(NSString *)message afterDelay:(NSTimeInterval)delay {
//    QZHWS(weakSelf);
//    dispatch_async(dispatch_get_main_queue(), ^{
//        weakSelf.textHUD = [[MBProgressHUD alloc] initWithView:self.targetView];
//        weakSelf.textHUD.mode = MBProgressHUDModeCustomView;
//        weakSelf.textHUD.offset = weakSelf.offset;
//        weakSelf.textHUD.customView = [weakSelf gifViewWithLocal:imageNamed];
//        weakSelf.textHUD.label.text = message;
//        weakSelf.textHUD.label.numberOfLines = 0;
//        weakSelf.textHUD.removeFromSuperViewOnHide = YES;
//        weakSelf.textHUD.delegate = [weakSelf exp_getCurrentVC];
//        [weakSelf showHUD:weakSelf.textHUD afterDelay:delay];
//    });
//    
//    return [QZHHUD HUD];
//}

/**
 显示HUD

 @param HUD 需要显示的HUD
 */
- (void)showHUD:(MBProgressHUD *)HUD afterDelay:(CGFloat)delay {
    if (!self.targetView) {
        return;
    }
    
    QZHWS(weakSelf);
    [weakSelf.targetView addSubview:HUD];
    [HUD showAnimated:YES];
    if (delay >= 0) {
        [HUD hideAnimated:YES afterDelay:delay];
    }
}

- (void)hiddenHUD {
    QZHWS(weakSelf);
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([weakSelf.loadHUD.delegate isEqual:[weakSelf exp_getCurrentVC]]) {
            [weakSelf.loadHUD hideAnimated:YES];
        }
        if ([weakSelf.textHUD.delegate isEqual:[weakSelf exp_getCurrentVC]]) {
            if (weakSelf.textHUD) {
                [weakSelf.textHUD hideAnimated:YES];
            }
        }
    });
}

- (void)forceHiddenHUD {
    QZHWS(weakSelf);
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf.loadHUD hideAnimated:YES];
        if (weakSelf.textHUD) {
            [weakSelf.textHUD hideAnimated:YES];
        }
    });
}

/**
 加载自定义图片

 @param named 本地图片名称
 @return 自定义HUD view
 */
//- (UIView *)gifViewWithLocal:(NSString *)named {
//    QZHHUDImageView *imageView = [[QZHHUDImageView alloc] initWithFrame:CGRectMake(0, 0, 120, 120)];
//    NSURL *path = [[NSBundle mainBundle]URLForResource:named withExtension:@"gif"];
//    YYImage * image = [YYImage imageWithContentsOfFile:path.path];
//    imageView.image = image;
//    imageView.clipsToBounds = YES;
//
//    return imageView;
//}

- (void)setQZHHUDFinish:(HudFinished)QZHHUDFinish {
    QZHWS(weakSelf);
    self.textHUD.completionBlock = ^{
        if (QZHHUDFinish) {
            QZHHUDFinish();
            weakSelf.textHUD.completionBlock = nil;
            weakSelf.QZHHUDFinish = nil;
        }
    };
}

#pragma makr - lazy init

- (UIView *)targetView {
    return [self exp_getCurrentVC].view;
}

- (MBProgressHUD *)loadHUD {
    
    if (!_loadHUD && self.targetView) {
        _loadHUD = [[MBProgressHUD alloc] initWithView:self.targetView];
        _loadHUD.minShowTime = 0.5;
    }

    return _loadHUD;
}

@end
