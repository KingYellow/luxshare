//
//  QZHCodeButton.m
//  MQMedical
//
//  Created by 米翊米 on 2017/12/14.
//  Copyright © 2017年 🐨🐨🐨. All rights reserved.
//

#import "QZHCodeButton.h"

@interface QZHCodeButton ()

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger timeVal;
@property (nonatomic, strong) NSString *title;

@end

@implementation QZHCodeButton

- (QZHCodeButton *)codeActionWithTimeVal:(NSInteger)timeVal {
    self.userInteractionEnabled = NO;
    self.selected = YES;
    self.timeVal = timeVal;
    self.title = self.titleLabel.text;
    
    if (!self.timer) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(flashTime) userInfo:nil repeats:YES];
        [self.timer fire];
    }
    __weak __typeof(&*self)weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (weakSelf.codeAction) {
            weakSelf.codeAction(NO);
        }
    });
    
    return self;
}

- (void)flashTime {
    self.timeVal -= 1;
    if (self.timeVal > 0) {
        [self setTitle:[NSString stringWithFormat:@"%li s", (long)self.timeVal] forState:UIControlStateNormal];
    } else {
        [self stopAction];
    }
}

- (void)stopAction {
    [self setTitle:self.title forState:UIControlStateNormal];
    self.selected = NO;
    [self.timer invalidate];
    self.timer = nil;
    self.userInteractionEnabled = YES;
    if (self.codeAction) {
        self.codeAction(YES);
    }
}

@end
