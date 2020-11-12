//
//  TYTabItemAttribute.h
//  TYModuleManager
//
//  Created by TuyaInc on 2018/8/23.
//

#import <Foundation/Foundation.h>

#import "TYTabBarCustomButton.h"
#import "TYTabBarCustomBadgeProtocol.h"

#define TYTabIndex_NotOnTab NSUIntegerMax

@interface TYTabItemAttribute : NSObject

@property (nonatomic, strong, readonly) Class moduleClass; /**< 自动填充 */

@property (nonatomic, strong) __kindof UIViewController *viewController;

/**
 只对config中的tabSelectModule下注册的tabItem生效
 一个module最多只能1个item默认选中，没有则默认第一个
 */
@property (nonatomic) BOOL defaultSelected;

@property (nonatomic, copy) NSString *itemTitle;
@property (nonatomic, strong) UIImage *normalImage;
@property (nonatomic, strong) UIImage *selectedImage;

@property (nonatomic, copy) NSString *badgeValue;
@property (nonatomic, strong) UIColor *badgeColor NS_AVAILABLE_IOS(10_0);
@property (nonatomic, strong) NSDictionary<NSAttributedString *, id> *badgeTextAttribute NS_AVAILABLE_IOS(10_0);

@property (nonatomic, copy) NSString *tag;

@property (nonatomic) UIEdgeInsets imageInsets;
@property (nonatomic) UIOffset titleOffset;


@property (nonatomic, strong) __kindof TYTabBarCustomButton *customButton;  /** 需要完全自定义tabBarButton时，实现此配置 */
@property (nonatomic, strong) __kindof UIView<TYTabBarCustomBadgeProtocol> *customBadgeView;   /**< 自定义角标 */

@property (nonatomic, copy) NSString *accessibilityIdentifier;

@property (nonatomic, readonly) NSUInteger tabIndex;   /**< tab上的下标 */

@end

