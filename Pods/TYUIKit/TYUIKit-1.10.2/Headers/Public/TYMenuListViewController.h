//
//  TYMenuListViewController.h
//  TYUIKit
//
//  Created by TuyaInc on 2019/12/5.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class TYMenuListViewController;

@protocol TYMenuListDataProtocol <NSObject>

@optional
- (NSString *)menuReusableCellIdentifier;

@end

@protocol TYMenuListCellProtocol <NSObject>

- (void)setupMenuWithData:(id)data;

@optional
+ (CGFloat)menuCellHeightForData:(id)data;
+ (NSString *)menuCellIdentifier;

@end

@protocol TYMenuListViewControllerDelegate <NSObject>

/**
 [^zh]当背景产生点击事件时回调[$zh]
 [^en]Callback when background is clicked[$en]
 */
- (void)ty_menuListBackgroundTapAction:(TYMenuListViewController *)menuListVC;

- (void)ty_menuList:(TYMenuListViewController *)menuListVC didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@end


@interface TYMenuListViewController : UIViewController

@property (nonatomic, weak) id<TYMenuListViewControllerDelegate> delegate;

@property (nonatomic, strong, readonly) UIView *backgroundView;
/**
 [^zh]menu view 和 indicator view 的父视图[$zh]
 [^en]parent view of menu view and indicator view[$en]
 */
@property (nonatomic, strong, readonly) UIView *containerView;

@property (nonatomic, strong) UITableView *menuView;

/**
 [^zh]自动调整menu view的高度，展示所有的cell[$zh]
 [^en]adjust the height of the menu view to display all the cells[$en]
 */
@property (nonatomic) BOOL automaticMenuHeight;

@property (nonatomic) NSArray<Class<TYMenuListCellProtocol>> *menuCellClassArr;
@property (nonatomic, copy) NSArray<id<TYMenuListDataProtocol>> *menuDataArr;

@property (nonatomic, strong) UIView *indicatorView;

/**
 [^zh]自动调整container view的锚点到indicator view的中心点[$zh]
 [^en]adjust the anchor point of the container view to the center point of the indicator view[$en]
 */
@property (nonatomic) BOOL makeAnchorPointFollowIndicator;

#pragma mark - StatusBar
@property (nonatomic) BOOL statusBarHidden;
@property (nonatomic) UIStatusBarStyle statusBarStyle;
@property (nonatomic) UIStatusBarAnimation statusBarAnimation;

@end

NS_ASSUME_NONNULL_END
