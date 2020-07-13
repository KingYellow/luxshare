//
//  QZHMessageModel.h
//  luxshare
//
//  Created by 黄振 on 2020/7/2.
//  Copyright © 2020 KingYellow. All rights reserved.
//

#import <TuyaSmartMessageKit/TuyaSmartMessageKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QZHMessageModel : TuyaSmartMessageListModel

//编辑时是否被选中
@property (assign, nonatomic)BOOL isSelected;

@end

NS_ASSUME_NONNULL_END
