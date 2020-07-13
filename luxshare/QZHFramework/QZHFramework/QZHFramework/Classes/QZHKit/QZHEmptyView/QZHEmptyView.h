//
//  QZHEmptyView.h
//  QZHEmptyView
//
//  Created by nf on 2018/1/16.
//  Copyright © 2018年 QZHEmptyView. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "EasyEmptyPart.h"
#import "EasyEmptyConfig.h"
#import "EasyEmptyTypes.h"

@interface QZHEmptyView : UIView

+ (QZHEmptyView *)showEmptyInView:(UIView *)superview
                   item:(EasyEmptyPart *(^)(void))item ;

+ (QZHEmptyView *)showEmptyInView:(UIView *)superview
                   item:(EasyEmptyPart *(^)(void))item
                 config:(EasyEmptyConfig *(^)(void))config ;

+ (QZHEmptyView *)showEmptyInView:(UIView *)superview
                   item:(EasyEmptyPart *(^)(void))item
                 config:(EasyEmptyConfig *(^)(void))config
               callback:(emptyViewCallback)callback ;


+ (void)hiddenEmptyInView:(UIView *)superView ;
+ (void)hiddenEmptyView:(QZHEmptyView *)emptyView ;


@end
