//
//  QZHToolMacro.h
//  MYM
//
//  Created by 米翊米 on 2018/6/5.
//  Copyright © 2018年 米翊米. All rights reserved.
//

#import <UIKit/UIKit.h>

// --------------------------Screen----------------------
//屏幕宽度
#define QZHScreenWidth             [UIScreen mainScreen].bounds.size.width
//屏幕高度
#define QZHScreenHeight            [UIScreen mainScreen].bounds.size.height

//不同机型与iPhone6屏幕的比例
#define QZHScaleWidth           QZHScreenWidth/375.0
#define QZHScaleHeight          QZHScreenHeight/667.0

//是否是iPhone X
#define QZHiPhoneX               (QZHScreenHeight>=812 ? YES:NO)
// --------------------------Screen-------------------------


// --------------------------const height----------------------
//状态栏高度
#define QZHHeightStatusBar         [UIApplication sharedApplication].statusBarFrame.size.height
//顶部高度(导航栏+状态栏)
#define QZHHeightTop               (QZHHeightStatusBar + QZHHeightNavigationBar)
//底部高度
#define QZHHeightBottom            (QZHiPhoneX ? 34.0:0.0)
//选项卡高度
#define QZHHeightTabbar            49.0
//导航栏高度
#define QZHHeightNavigationBar     44.0
//无底部栏导航栏高度
#define QZHHeightNOBar             (QZHScreenHeight-QZHHeightBottom-QZHHeightTabbar-QZHHeightTop)
//无底部栏高度
#define QZHHeightNOTabBar          (QZHScreenHeight-QZHHeightBottom-QZHHeightTop)

//用于uitableview在group模式下的header和footer高度为0时
#define QZHHeightZero              0.00001
// --------------------------const height-------------------------


// --------------------------application----------------------
//获取主窗体Delegate
#define QZHMainDelegate            ((AppDelegate *)([UIApplication sharedApplication].delegate))
//获取主窗体Window
#define QZHMainWindow              [UIApplication sharedApplication].keyWindow

//weak self
#define QZHWS(weakSelf)               __weak __typeof(&*self)weakSelf = self;
//strong self
#define QZHST(strongSelf) if (!weakSelf) return; __strong typeof(&*weakSelf) strongSelf = weakSelf;

//class转string
#define QZHObjClassToString(className) NSStringFromClass([className class])
//字符串格式化
#define QZHObjStringFormat(f, ...)    [NSString stringWithFormat:f, ##__VA_ARGS__]
// --------------------------application-------------------------

// --------------------------code define----------------------
#define QZHLoadIcon(name)   [UIImage imageNamed:name]
//设置 view 边框
#define QZHViewBorder(View,Width, Color)\
[View.layer setBorderWidth:(Width)];\
[View.layer setBorderColor:[Color CGColor]];

//设置 view 圆角
#define QZHViewRadius(View, Radius)\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES];

///延时执行
NS_INLINE void Dispatch_After(CGFloat time, dispatch_block_t block) {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), block);
}

//debug模式下打印日志
#ifndef __OPTIMIZE__
#define NSLog(fmt, ...) NSLog((@"File: %s\n" "Func: %s >> " "Line: %d\n" "Log: " fmt), __FILE__, __FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define NSLog(...) {}
#endif
// --------------------------code define-------------------------

// --------------------------font----------------------
//UIFontWeightUltraLight  - 超细字体
//UIFontWeightThin  - 纤细字体
//UIFontWeightLight  - 亮字体
//UIFontWeightRegular  - 常规字体
//UIFontWeightMedium  - 介于Regular和Semibold之间
//UIFontWeightSemibold  - 半粗字体
//UIFontWeightBold  - 加粗字体
//UIFontWeightHeavy  - 介于Bold和Black之间
//UIFontWeightBlack  - 最粗字体(理解)

#define QZHFontScale                              (QZHScreenWidth/375.0)

//系统文字大小
#define QZHTEXT_FONT(s)                            [UIFont systemFontOfSize:s*QZHFontScale]

//Regular文字大小
#define QZHTEXT_FONTRegular(s)                     [UIFont systemFontOfSize:s*QZHFontScale weight:UIFontWeightRegular]

//Medium文字大小
#define QZHTEXT_FONTMedium(s)                      [UIFont systemFontOfSize:s*QZHFontScale weight:UIFontWeightMedium]

//Semibold文字大小
#define QZHTEXT_FONTSemibold(s)                    [UIFont systemFontOfSize:s*QZHFontScale weight:UIFontWeightSemibold]

//Bold文字大小
#define QZHTEXT_FONTBold(s)                        [UIFont systemFontOfSize:s*QZHFontScale weight:UIFontWeightBold]

//name为字体名称
#define QZHTEXT_FONTName(n, s)                     [UIFont fontWithName:n size:s*QZHFontScale]
// --------------------------font-------------------------


// --------------------------基本颜色----------------------
//RGB
#define RGB(r,g,b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1]
//RGBA
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]

//16进制
#define UIColorFromHex(s) [UIColor colorWithRed:(((s & 0xFF0000) >> 16))/255.0 green:(((s &0xFF00) >>8))/255.0 blue:((s &0xFF))/255.0 alpha:1.0]
#define UIColorFromHexA(s, a) [UIColor colorWithRed:(((s & 0xFF0000) >> 16))/255.0 green:(((s &0xFF00) >>8))/255.0 blue:((s &0xFF))/255.0 alpha:a]

//基本颜色
#define QZHColorWhite       [UIColor whiteColor]
#define QZHColorClear       [UIColor clearColor]
#define QZHColorBlack       [UIColor blackColor]
#define QZHColorGray        [UIColor grayColor]
#define QZHColorDarkGray    [UIColor darkGrayColor]
#define QZHColorLightGray   [UIColor lightGrayColor]
#define QZHColorRed         [UIColor redColor]
#define QZHColorGreen       [UIColor greenColor]
#define QZHColorBlue        [UIColor blueColor]
#define QZHColorYellow      [UIColor yellowColor]
// --------------------------基本颜色-------------------------


// --------------------------block----------------------

//通用block
typedef void(^QZHResultBlock)(id data);

// --------------------------block-------------------------
