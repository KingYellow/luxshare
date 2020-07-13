//
//  DDPullMenuView.h
//  DDSample
//
//  Created by 黄振 on 2020/3/25.
//  Copyright © 2020 KingYellow. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// tableView cell 类型的筛选
typedef void (^FilterBlock)(NSArray<NSString *> *filters);

@interface DDPullMenuView : UIView

/// 下拉tableView datasource
@property (nonatomic, strong) NSArray<NSArray *> *dataArrays;

/// 是否展示
@property (nonatomic,readonly, assign) BOOL isShow;

/// 创建实例 with block
+ (instancetype)conditionFilterViewWithListCount:(NSInteger)listCount FilterBlock:(FilterBlock)filterBlock;

/// 更新显示三个小标题
- (void)updateFilterTableTitleWithTitleArray:(NSArray<NSString*> *)titleArray;

/// 消失
- (void)dismiss;

@end

NS_ASSUME_NONNULL_END
