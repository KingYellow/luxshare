//
//  TuyaSmartMessageListModel+EXP.m
//  luxshare
//
//  Created by 黄振 on 2020/7/2.
//  Copyright © 2020 KingYellow. All rights reserved.
//

#import "TuyaSmartMessageListModel+EXP.h"

static NSString *nameKey = @"nameKey"; //name的key



@implementation TuyaSmartMessageListModel (EXP)
-(void)setSelect:(NSString *)select{
    objc_setAssociatedObject(self, &nameKey, select, OBJC_ASSOCIATION_COPY);

}
- (NSString *)select{
    return objc_getAssociatedObject(self, &nameKey);
}
@end
