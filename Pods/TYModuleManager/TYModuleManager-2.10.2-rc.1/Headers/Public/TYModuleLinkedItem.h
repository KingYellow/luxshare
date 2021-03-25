//
//  TYModuleLinkedItem.h
//  TYModuleManager
//
//  Created by zjutwhw on 2020/7/31.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TYModuleLinkedItem : NSObject

@property (nonatomic, strong) NSNumber *priority;
@property (nonatomic, strong) TYModuleLinkedItem *next;
@property (nonatomic, weak) id module;

/*
 说明：插入item到链表，按优先级大小排序
 */
+ (TYModuleLinkedItem *)insertItem:(TYModuleLinkedItem *)item toLinked:(TYModuleLinkedItem *)head;

/*
 说明：删除链表上可能已经释放的Module节点
 */
+ (TYModuleLinkedItem *)cleanNilInLinked:(TYModuleLinkedItem *)head;

@end

NS_ASSUME_NONNULL_END
