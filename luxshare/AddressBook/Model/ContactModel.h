//
//  ContactModel.h
//  DDSample
//
//  Created by 黄振 on 2020/4/7.
//  Copyright © 2020 KingYellow. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ContactModel : NSObject

@property (nonatomic,strong) NSString *spell;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *english;
@property (nonatomic,strong) NSString *chinese;
@property (nonatomic,strong) NSString *abbr;
@property (nonatomic,strong) NSString *code;

@property (nonatomic,strong) NSString *pinyin;//拼音

- (instancetype)initWithDic:(NSDictionary *)dic;
@end

NS_ASSUME_NONNULL_END
