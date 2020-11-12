//
//  TYTabBarControllerDataSource.h
//  TYModuleTabbar
//
//  Created by TuyaInc on 2018/8/23.
//

#import <Foundation/Foundation.h>

#import "TYTabItemAttribute.h"

@protocol TYTabBarControllerDataSource <NSObject>

@required
- (NSArray<TYTabItemAttribute *> *)ty_tabItemAttributes;

@end
