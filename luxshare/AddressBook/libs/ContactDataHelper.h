//
//  ContactDataHelper.h
//  WeChatContacts-demo
//
//  Created by shen_gh on 16/3/12.
//  Copyright © 2016年 com.joinup(Beijing). All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  格式化联系人列表
 */

@interface ContactDataHelper : NSObject
///对所有联系人名字分组
+ (NSMutableArray *) getFriendListDataBy:(NSMutableArray *)array;
///获取联系人分各组联系人名字的首字母
+ (NSMutableArray *) getFriendListSectionBy:(NSMutableArray *)array;

@end
