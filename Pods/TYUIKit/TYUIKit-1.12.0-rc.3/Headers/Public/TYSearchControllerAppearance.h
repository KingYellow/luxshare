//
//  TYSearchControllerAppearance.h
//  TYUIKit
//
//  Created by TuyaInc on 2019/2/11.
//

#import <Foundation/Foundation.h>

#import "TYSearchBarAppearance.h"
#import "TYSearchTableCustomProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface TYSearchControllerAppearance : NSObject

@property (nonatomic, strong) TYSearchBarAppearance *searchBarAppearance;

@property (nonatomic) UIEdgeInsets searchBarBoundsInsets;

@property (nonatomic, strong) Class<TYSearchTableCustomProtocol> searchTableClass;
@property (nonatomic, strong) UIColor *searchTableBackgroundColor;

+ (instancetype)appearance;

@end

NS_ASSUME_NONNULL_END
