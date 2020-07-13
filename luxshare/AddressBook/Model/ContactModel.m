//
//  ContactModel.m
//  DDSample
//
//  Created by 黄振 on 2020/4/7.
//  Copyright © 2020 KingYellow. All rights reserved.
//

#import "ContactModel.h"
#import "NSString+Utils.h"

@implementation ContactModel
- (void)setName:(NSString *)name{
    if (name) {
        _name=name;
        _pinyin=_name.pinyin;
    }
}

- (instancetype)initWithDic:(NSDictionary *)dic{
    self =  [self initWithDic:dic];
    return self;
}
@end
