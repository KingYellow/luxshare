//
//  TYTabBarCustomButton.h
//  TYModuleManager
//
//  Created by TuyaInc on 2019/1/8.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TYTabBarCustomButton : UIButton

@property (nonatomic) CGPoint ty_centerOffset;
@property (nonatomic, strong) UIImage *ty_hitMask; /**< 用来处理异形点击区域，hitMask上透明度>85%的点可以响应点击 */

@end

NS_ASSUME_NONNULL_END
