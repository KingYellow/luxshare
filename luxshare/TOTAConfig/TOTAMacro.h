//
//  DDMacro.h
//  DDSample
//
//  Created by 黄振 on 2020/3/24.
//  Copyright © 2020 KingYellow. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#ifndef DDMacro_h
#define DDMacro_h
#define QZH_TuyaSmartUser    [TuyaSmartUser sharedInstance]

//不同机型与375*670屏幕的比例
#define QZH_SCREEN_WIDTH             [UIScreen mainScreen].bounds.size.width
#define QZH_SCREEN_HEIGHT            [UIScreen mainScreen].bounds.size.height

#define QZH_WIDTH_SCALE          QZHScreenWidth/375.0
#define QZH_HEIGHT_SCALE          QZHScreenHeight/667.0
#define QZH_SCREEN_SCALE          [UIScreen mainScreen].scale

//----------------------------------------
//主代理
#define QZHROOT_DELEGATE         ((AppDelegate *)[UIApplication sharedApplication].delegate)
//通知中心
#define QZH_NOTIFICATION_CENTER [NSNotificationCenter defaultCenter]

//statusbar高度
#define QZHSTATUSBAR_HEIGHT [[UIApplication sharedApplication] statusBarFrame].size.height

//navibar高度
#define QZHNAVI_HEIGHT [[UIApplication sharedApplication] statusBarFrame].size.height + 44


// --------------------------color-------------------------------
//主色
#define QZHKIT_COLOR_SKIN                 UIColorFromHex(0x228B22)

#define QZHKIT_COLOR_SKIN_AlPHA                UIColorFromHexA(0x228B22,0.5)


//辅色

//导航栏
#define QZHKIT_COLOR_NAVIBAR_BACK          QZHKIT_COLOR_SKIN
#define QZHKIT_COLOR_NAVIBAR_TITLE         QZHColorWhite
#define QZHKIT_COLOR_NAVIBAR_ITEM          QZHColorBlack
//tabbar
#define QZHKIT_COLOR_TABBAR_BACK           UIColorFromHex(0xFFFFFF)
#define QZHKIT_COLOR_TABBAR_TITLE_NORMAL    UIColorFromHex(0x4A4A4A)
#define QZHKIT_COLOR_TABBAR_TITLE_SELECTED  QZHKIT_COLOR_SKIN

//文本颜色黑色：[87% 普通文字] [54% 减淡文字] [26% 禁用状态/提示文字] [12% 分隔线]
#define QZHKIT_Color_BLACK_87 UIColorFromHexA(0x000000, 0.87)
#define QZHKIT_Color_BLACK_70 UIColorFromHexA(0x000000, 0.7)
#define QZHKIT_Color_BLACK_54 UIColorFromHexA(0x000000, 0.54)
#define QZHKIT_Color_BLACK_26 UIColorFromHexA(0x000000, 0.26)
#define QZHKIT_Color_BLACK_12 UIColorFromHexA(0x000000, 0.12)
#define QZHKIT_Color_BLACK_0 UIColorFromHexA(0x000000, 0.01)


//文本颜色白色：[100% 普通文字] [70% 减淡文字] [30% 禁用状态/提示文字] [12% 分隔线]
#define QZH_KIT_Color_WHITE_100 UIColorFromHexA(0xffffff, 1)
#define QZH_KIT_Color_WHITE_70 UIColorFromHexA(0xffffff, 0.7)
#define QZH_KIT_Color_WHITE_30 UIColorFromHexA(0xffffff, 0.3)
#define QZH_KIT_Color_WHITE_12 UIColorFromHexA(0xffffff, 0.12)


//页面背景色
#define QZHKIT_COLOR_LEADBACK             UIColorFromHex(0xefefef)

//阴影颜色
#define QZHKIT_COLOR_SHADOW               UIColorFromHexA(0x000000, 0.1)

//透明
#define QZHKit_COLOR_TRANSPARENCY        UIColorFromHexA(0x000000, 0)
// --------------------------color-------------------------------



// --------------------------font-------------------------------
//navi导航字体大小
#define QZHKIT_FONT_NAVIBAR_TITLE          QZHTEXT_FONTMedium(18)
#define QZHKIT_FONT_NAVIBAR_ITEM_TITLE      QZHTEXT_FONT(16)

//tabbar字体大小
#define QZHKIT_FONT_TABBAR_TITLE           QZHTEXT_FONT(18)

//ListCellcell字体大小
#define QZHKIT_FONT_LISTCELL_BIG_TITLE       QZHTEXT_FONT(20)
#define QZHKIT_FONT_LISTCELL_MAIN_TITLE       QZHTEXT_FONT(18)
#define QZHKIT_FONT_LISTCELL_SUB_TITLE            QZHTEXT_FONT(16)
#define QZHKIT_FONT_LISTCELL_DESCRIBE_TITLE       QZHTEXT_FONT(14)
#define QZHKIT_FONT_LISTCELL_TIME_TITLE           QZHTEXT_FONT(12)

// --------------------------font-------------------------------

// --------------------------size-------------------------------

//ListCell图片大小
#define QZHSIZE_HEIGHT_LISTCELL_IMAGE             60
#define QZHSIZE_WIDTH_LISTCELL_IMAGE              60
//LISTCELL 间距
#define QZHSIZE_HEIGHT_LISTCELL_SEPARATOR          1


// --------------------------size-------------------------------

// --------------------------margin-------------------------------
//ListCell图片边距
#define QZHKIT_MARGIN_LEFT_LISTCELL_IMAGE              15
#define QZHKIT_MARGIN_RIGHT_LISTCELL_IMAGE              15

#define QZHKIT_MARGIN_TOP_LISTCELL_IMAGE             15
#define QZHKIT_MARGIN_BOTTOM_LISTCELL_IMAGE            15

//ListCell文本边距
#define QZHKIT_MARGIN_LEFT_LISTCELL_TEXT              15
#define QZHKIT_MARGIN_RIGHT_LISTCELL_TEXT              15
#define QZHKIT_MARGIN_TOP_LISTCELL_TEXT             15
#define QZHKIT_MARGIN_BOTTOM_LISTCELL_TEXT            15

//ListCell文本和图片水平间距
#define QZHKIT_MARGIN_H_LISTCELL_IMAGE_AND_TEXT              15
//ListCell文本和图片垂直间距
#define QZHKIT_MARGIN_V_LISTCELL_IMAGE_AND_TEXT              15

//图片加载失败  显示文字长度
#define QZHKIT_LENGTH_TEXT_NOIMAGE              10



// --------------------------margin-------------------------------
static NSString * const BATTERY_PRODUCT_ID = @"b4hq7aoy4m4ciabx";
static NSString * const AC_PRODUCT_ID= @"u3ctgwxzrovkuamh";


//第一次安装app记录时使用
static NSString * const QZHKKEY_FIRST_INSTALL = @"QZHKeyFirstInstall";
//用户数据
static NSString * const QZHKEY_USER = @"QZHKeyUser";
//设备deviceserver
static NSString * const QZHKEY_TOKEN = @"QZHKeyToken";
//设备devicetoken
static NSString * const QZHKEY_DEVICE_TOKEN = @"QZHKeyDeviceToken";
//系统设置是否开启推送
static NSString * const QZHKEY_PUSHOPEN = @"QZHKeyPushOpen";

//cell重用标识
static NSString * const QZHCELL_REUSE_TEXT = @"QZHReuseCellText";
static NSString * const QZHCELL_REUSE_IMAGE = @"QZHReuseCellimage";
static NSString * const QZHCELL_REUSE_DEFAULT = @"QZHReuseCellDefult";
static NSString * const QZHCELL_REUSE_FIELD = @"QZHReuseCellField";


//占位图
static NSString * const QZHICON_PLACEHOLDER = @"icon_empty_pld";

//头像占位图
static NSString * const QZHICON_HEAD_PLACEHOLDER = @"mine";

//导航栏返回按钮图标
static NSString * const QZHICON_BACK_ITEM = @"nav_btn_back";

//导航栏背景图片
static NSString * const QZHICON_NAVI_BACK = @"xxx";

//头像名称
static NSString * const QZHICON_HEADPIC = @"xxx";


// NSLocalizedString(key, comment) 本质
// NSlocalizeString 第一个参数是内容,根据第一个参数去对应语言的文件中取对应的字符串，第二个参数将会转化为字符串文件里的注释，可以传nil，也可以传空字符串@""。
#define QZHLoaclString(key) [[NSBundle mainBundle] localizedStringForKey:(key) value:@"" table:nil]

///本地化语言
//#define QZHLoaclString(key)         (\
//{ \
//    NSString *language = [[self jk_currentLanguage] componentsSeparatedByString:@"-"].firstObject; \
//    NSString *path = [[NSBundle mainBundle]pathForResource:@"pt-BR" ofType:@"lproj"]; \
//    NSBundle *bundle = [NSBundle bundleWithPath:path]; \
//    if ([language isEqualToString:@"pt"]) { \
//        path = [[NSBundle mainBundle]pathForResource:@"pt-BR" ofType:@"lproj"]; \
//        bundle = [NSBundle bundleWithPath:path]; \
//    } \
//    NSLocalizedStringWithDefaultValue(key, @"Localizable", bundle, key, nil); \
//})

static NSString * const QZHTUYATIMERALARM = @"alarmTimer";


#endif /* DDMacro_h */
