//
//  NSString+Filter.h
//  luxshare
//
//  Created by 黄振 on 2021/3/2.
//  Copyright © 2021 KingYellow. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Filter)
+ (BOOL)exp_isEqualToReplacementString:(NSString *)string;
@end

NS_ASSUME_NONNULL_END
