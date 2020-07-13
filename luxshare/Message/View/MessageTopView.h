//
//  MessageTopView.h
//  luxshare
//
//  Created by 黄振 on 2020/6/30.
//  Copyright © 2020 KingYellow. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MessageTopView : UIView
@property (strong, nonatomic)UILabel *nameLab;
@property (strong, nonatomic)UIButton *normalBtn;
@property (strong, nonatomic)UIButton *selectBtn;

+ (MessageTopView *)initmessagetopViewName:(NSString *)name;
@end

NS_ASSUME_NONNULL_END
