//
//  AnimationLabel.m
//  封装日历
//
//  Created by yurong on 2017/7/20.
//  Copyright © 2017年 yurong. All rights reserved.
//

#import "AnimationLabel.h"
#import "UIColor+Hex.h"
#import "UIView+Frame.h"

@interface AnimationLabel ()


@end
@implementation AnimationLabel

- (instancetype)initWithFrame:(CGRect)frame labelStr:(NSString *)labelStr
{
    self = [super initWithFrame:frame];
    if (self) {
        _changeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _changeLabel.text = labelStr;
        _changeStr = labelStr;
        _changeLabel.textAlignment = NSTextAlignmentCenter;
        _changeLabel.textColor = [UIColor colorWithHexString:@"6A6A6A"];
        _changeLabel.font = QZHKIT_FONT_LISTCELL_SUB_TITLE;
        [self addSubview:_changeLabel];
    }
    return self;
}


- (void)setChangeStr:(NSString *)changeStr{
    _changeStr = changeStr;
    QZHWS(weakSelf)
    [UIView animateWithDuration:0.3f animations:^{
        weakSelf.changeLabel.x = self.size.width;
        weakSelf.changeLabel.alpha = 0;
    }completion:^(BOOL finished) {
        weakSelf.changeLabel.alpha = 1;
        weakSelf.changeLabel.x = 0;
        weakSelf.changeLabel.text = changeStr;
//        weakSelf.changeStr = changeStr;
    }];
}

@end
