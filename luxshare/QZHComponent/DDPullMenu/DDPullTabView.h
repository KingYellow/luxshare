//
//  DDPullTabView.h
//  DDSample
//
//  Created by 黄振 on 2020/3/25.
//  Copyright © 2020 KingYellow. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol QZFilterTableViewDelegate <NSObject>

@optional
// 选中筛选项触发
- (void)chooseFilterItem:(NSString *)item;

@end

@interface DDPullTabView : UITableView

@property (nonatomic,weak) id<QZFilterTableViewDelegate> chooseDelegate;
// 对外提供设置能力,显示当前选中cell
@property (nonatomic,copy) NSString *selectedItem;

@property (nonatomic,strong) NSArray *dataArray;

- (void)dismiss;

@end

