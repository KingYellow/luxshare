//
//  zyyy_DateListView.m
//  日历
//
//  Created by yurong on 2017/7/26.
//  Copyright © 2017年 1. All rights reserved.
//

#import "zyyy_DateListView.h"
#import "zyyy_DateView.h"
#import "DateModel.h"
#import "animationLabel.h"
#import "UIColor+Hex.h"
#import "UIView+Frame.h"
#define IPHONEHIGHT(b) [UIScreen mainScreen].bounds.size.height*((b)/1334.0)
#define IPHONEWIDTH(a) [UIScreen mainScreen].bounds.size.width*((a)/750.0)


#define contentHeight IPHONEHIGHT(590)

#define dateViewTop IPHONEWIDTH(140)
#define dateViewHeight IPHONEHIGHT(480)

@interface zyyy_DateListView ()<UIScrollViewDelegate,zyyy_DateViewDelegate,UIGestureRecognizerDelegate>
{
    CGFloat width;
    CGFloat height;
    
    CGFloat contentWidth;
    zyyy_DateView *dateViewCurrent;
    zyyy_DateView *dateViewLast;
    zyyy_DateView *dateViewNext;
    
    animationLabel *visibleDateLabel;
}
@end
@implementation zyyy_DateListView
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([object isEqual:dateViewCurrent]&&[keyPath isEqualToString:@"selectedMonth"]) {
        visibleDateLabel.changeStr = [NSString stringWithFormat:@"%ld年%ld月",dateViewCurrent.selectedYear,dateViewCurrent.selectedMonth];
    }
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
        [self addGestureRecognizer:tap];
        tap.delegate = self;
    }
    return self;
}


#pragma mark -UIScroviewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    
    if (!scrollView.dragging) {
        return;
    }
    
        //手动执行禁用以后的日期
        if (scrollView.contentOffset.x>contentWidth&&dateViewCurrent.selectedMonth==[DateModel shareDateModel].month&&dateViewCurrent.selectedYear==[DateModel shareDateModel].year) {

            scrollView.scrollEnabled = NO;


        }else{
            NSLog(@"%f  %f ",scrollView.contentOffset.x,contentWidth);
            if (scrollView.contentOffset.x == 2*contentWidth) {
                //下月
                dateViewCurrent.selectedMonth+=1;
                dateViewLast.selectedMonth+=1;
                dateViewNext.selectedMonth+=1;
                dateViewCurrent.freeMonth = 7;
                [scrollView setContentOffset:CGPointMake(contentWidth, 0) animated:NO];
            }else if(scrollView.contentOffset.x == 0){
                //上月
                dateViewCurrent.selectedMonth-=1;
                dateViewLast.selectedMonth-=1;
                dateViewNext.selectedMonth-=1;
                dateViewCurrent.freeMonth = 7;

                [scrollView setContentOffset:CGPointMake(contentWidth, 0) animated:NO];
            }

        }
  
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    scrollView.scrollEnabled = YES;
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    scrollView.scrollEnabled = YES;
}
#pragma mark -zyyy_DateViewDelegate
-(void)selectedDic:(NSDictionary *)dic{
    NSLog(@"%@",dic);
    self.selectDateBlock(dic);
    [self dismiss];
}

-(void)iiiii{
     width = self.frame.size.width;
     height = self.frame.size.height;
     self.backgroundColor = QZHKIT_Color_BLACK_54;
     contentWidth = [NSString stringWithFormat:@"%0.0f",IPHONEWIDTH(55)*7+IPHONEWIDTH(24)*6+IPHONEWIDTH(12)*2].floatValue;
     
     UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, contentWidth, contentHeight)];
     contentView.backgroundColor = [UIColor colorWithHexString:@"efefef"];
    
     contentView.center = self.center;
     [self addSubview:contentView];
     QZHViewRadius(contentView, 15);
     
     CGFloat Topheight = IPHONEHIGHT(80);
     CGFloat visibleDateLabelWidth = IPHONEWIDTH(200);
     //年月月份
     visibleDateLabel = [[animationLabel alloc]initWithFrame:CGRectMake(0, 0, visibleDateLabelWidth, Topheight) labelStr:[NSString stringWithFormat:@"%ld年%ld月",[DateModel shareDateModel].year,[DateModel shareDateModel].month]];
     
     visibleDateLabel.center = CGPointMake(contentWidth/2, Topheight/2);
     
     [contentView addSubview:visibleDateLabel];
     //按钮
     
     CGFloat weekBtnBorderInset = IPHONEWIDTH(12);
     CGFloat weekBtnHorizentalInset = IPHONEWIDTH(24);
     CGFloat weekBtnSize = IPHONEWIDTH(55);
     //星期
     NSArray *weekArray = @[@"日",@"一",@"二",@"三",@"四",@"五",@"六"];
     for (int index = 0; index<7; index++) {
         UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(weekBtnBorderInset+index*(weekBtnHorizentalInset+weekBtnSize), Topheight, weekBtnSize, weekBtnSize)];
         btn.adjustsImageWhenHighlighted = NO;
         btn.titleLabel.font = [UIFont boldSystemFontOfSize:IPHONEWIDTH(24)];
         [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
         [btn setTitle:weekArray[index] forState:UIControlStateNormal];
         [contentView addSubview:btn];
     }
     
     
     _dateScroView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, dateViewTop, contentWidth, dateViewHeight)];
     _dateScroView.showsHorizontalScrollIndicator = NO;
     _dateScroView.pagingEnabled = YES;
     _dateScroView.contentSize = CGSizeMake(contentWidth*3, 0);
     _dateScroView.bounces = NO;
     _dateScroView.delegate = self;
     _dateScroView.contentOffset = CGPointMake(contentWidth, 0);
     [contentView addSubview:_dateScroView];
     
     dateViewLast = [[zyyy_DateView alloc]initWithFrame:CGRectMake(0, 0, contentWidth, dateViewHeight)];
     dateViewLast.selectedMonth = [DateModel shareDateModel].lastMonth;
     
     dateViewLast.isSelected = NO;
     [_dateScroView addSubview:dateViewLast];
     
     dateViewCurrent = [[zyyy_DateView alloc]initWithFrame:CGRectMake(contentWidth, 0, contentWidth, dateViewHeight)];
    dateViewCurrent.camera =self.camera;
    dateViewCurrent.freeMonth = [DateModel shareDateModel].month;
    
     dateViewCurrent.isSelected = YES;
     [dateViewCurrent addObserver:self forKeyPath:@"selectedMonth" options:NSKeyValueObservingOptionNew context:nil];
     dateViewCurrent.delegate = self;
     [_dateScroView addSubview:dateViewCurrent];
     
     dateViewNext = [[zyyy_DateView alloc]initWithFrame:CGRectMake(contentWidth*2, 0, contentWidth, dateViewHeight)];
     dateViewNext.isSelected = NO;
     dateViewNext.selectedMonth = [DateModel shareDateModel].nextMonth;
     [_dateScroView addSubview:dateViewNext];

}

- (void)dismiss{
    [self removeFromSuperview];
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer*)gestureRecognizer shouldReceiveTouch:(UITouch*)touch {

    if ([touch.view isDescendantOfView:self.dateScroView]) {
        return NO;
    }
    return YES;

}

@end
