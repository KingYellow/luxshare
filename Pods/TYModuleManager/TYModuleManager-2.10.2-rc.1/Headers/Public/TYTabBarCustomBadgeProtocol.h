//
//  TYTabBarCustomBadgeProtocol.h
//  TYModuleManager
//
//  Created by TuyaInc on 2018/12/7.
//

#import <Foundation/Foundation.h>

@class TYTabItemAttribute;

@protocol TYTabBarCustomBadgeProtocol <NSObject>

@required
- (void)ty_setBadgeValue:(NSString *)value withItemAttribute:(TYTabItemAttribute *)attr;

@optional
@property (nonatomic) CGPoint originLocation;   /**< badge左上在barButton上的 比例位置 */
@property (nonatomic) CGSize offset;    /**< 在originLocation基础上偏移 */


@end

