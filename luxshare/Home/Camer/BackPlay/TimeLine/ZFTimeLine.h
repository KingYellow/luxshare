//
//  ZFTimeLine.h
//  luxshare
//
//  Created by 黄振 on 2020/7/16.
//  Copyright © 2020 KingYellow. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef enum{
    ScaleTypeBig,           //大
    ScaleTypeSmall          //小
}ScaleType;                 //时间轴模式

@class ZFTimeLine;
@protocol ZFTimeLineDelegate <NSObject>
- (void)timeLine:(ZFTimeLine *)timeLine moveToDate:(NSString *)date;
@end

@interface ZFTimeLine : UIView
@property (nonatomic, assign) id<ZFTimeLineDelegate> delegate;
@property (copy, nonatomic)NSArray *dateArr;

//刷新,但不改变时间
-(void)refresh;
#pragma mark --- 刷新到到当前时间
- (void)refreshNow;
#pragma mark --- 移动到某时间
// date数据格式举例 20170815121020
- (void)moveToDate:(NSString *)date;

#pragma mark --- 获取时间轴指向的时间
//返回数据举例 20170815121020
-(NSString *)currentTimeStr;

//锁定 不可拖动
- (void)lockMove;

//解锁 可拖动
- (void)unLockMove;

@end

NS_ASSUME_NONNULL_END
