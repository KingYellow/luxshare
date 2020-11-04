//
//  AnimationLabel.h
//  封装日历
//
//  Created by yurong on 2017/7/20.
//  Copyright © 2017年 yurong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AnimationLabel : UIView
@property(nonatomic,copy)NSString *changeStr;
- (instancetype)initWithFrame:(CGRect)frame labelStr:(NSString *)labelStr;
@property(nonatomic,strong)UILabel *changeLabel;
@end
