//
//  QZHUserModel.m
//  DDSample
//
//  Created by 黄振 on 2020/3/30.
//  Copyright © 2020 KingYellow. All rights reserved.
//

#import "QZHUserModel.h"

static QZHUserModel *model;

@implementation QZHUserModel

+ (QZHUserModel *)User {
    if (!model) {
        model = [QZHDataHelper readValueForKey:QZHKEY_USER];
    }
    
    return model;
}

+ (void)setModel:(QZHUserModel *)umodel {
    model = umodel;
}

+ (void)removeUserInfo {
    model = nil;
}
@end
