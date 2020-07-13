//
//  BWTopMenuView.m
//  BWTopMenuView
//
//  Created by syt on 2019/12/9.
//  Copyright © 2019 syt. All rights reserved.
//

#import "BWTopMenuView.h"


@interface BWTopMenuView ()

@property (nonatomic, strong) UIButton *selectButton;
@property (nonatomic, strong) UIView *indicatorView;
@property (nonatomic, strong) NSMutableArray *buttonArray;

@end
/**
 按钮之间的间距
 */
static CGFloat const btnSpace = 10.0;
/**
 指示器的高度
 */
static CGFloat const lineH = 2.0;
/**
 形变的度数
 */
//static CGFloat const radio = 1.0;

@implementation BWTopMenuView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColor.whiteColor;
        self.showsHorizontalScrollIndicator = NO;
        self.bounces = NO;
        self.defaultColor = UIColor.blackColor;
        self.selectColor = QZHKIT_COLOR_SKIN;
        self.lineColor = UIColor.redColor;
    }
    return self;
}



#pragma mark - setter方法
- (void)setSelectColor:(UIColor *)selectColor
{
    _selectColor = selectColor;
}

- (void)setDefaultColor:(UIColor *)defaultColor
{
    _defaultColor = defaultColor;
}

- (void)setLineColor:(UIColor *)lineColor
{
    _lineColor = lineColor;
}


- (void)setTitleArray:(NSArray *)titleArray
{
    _titleArray = titleArray;
    CGFloat bw_x = 0.0;
    CGFloat bw_y = 0;
    CGFloat bw_h = 44;
    for(UIView *view in [self subviews])
    {
        [view removeFromSuperview];
    }
    if (titleArray.count > 0) {
        for (int i = 0; i < titleArray.count; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            NSString *title = [NSString stringWithFormat:@"%@", titleArray[i]];
            [button setTitle:title forState:UIControlStateNormal];
            [button setTitleColor:self.defaultColor forState:UIControlStateNormal];
            [button setTitleColor:self.selectColor forState:UIControlStateSelected];
            button.titleLabel.font = QZHKIT_FONT_LISTCELL_MAIN_TITLE;
            button.tag = i + 888;
            CGSize size = [self sizeWithText:title font:QZHKIT_FONT_LISTCELL_MAIN_TITLE maxSize:CGSizeMake(k_Screen_Width, MAXFLOAT)];
            CGFloat bw_w = size.width + btnSpace * 2;
            button.frame = CGRectMake(bw_x, bw_y, bw_w, bw_h);
            bw_x += bw_w;
            [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            if (i == 0) {
                button.selected = YES;
                self.selectButton = button;
            }
            [self addSubview:button];
            [self.buttonArray addObject:button];
        }
        // 计算ScrollView的宽度，设置contentSize
        CGFloat scrollWid = CGRectGetMaxX(self.subviews.lastObject.frame);
        self.contentSize = CGSizeMake(scrollWid, self.Bw_height);
        UIButton *button = self.subviews.firstObject;
        self.indicatorView.backgroundColor = self.lineColor;
        self.indicatorView.Bw_height = lineH;
        self.indicatorView.Bw_y = 46;
        self.indicatorView.Bw_width = button.Bw_width - 2 * btnSpace;
        self.indicatorView.Bw_centerX = button.Bw_centerX;
        [self addSubview:_indicatorView];
        

    }
}

#pragma mark - buttonAction
- (void)buttonAction:(UIButton *)button
{
    [self setButton:button];
    // 让选中的按钮调整位置
    [self setSelectButtonCenter:button];
    if (self.titleButtonClick) {
        self.titleButtonClick(button.tag, button);
    }
}

// 设置选中按钮的状态以及指示器的位置等
- (void)setButton:(UIButton *)button
{
    self.selectButton.selected = NO;
//    self.selectButton.transform = CGAffineTransformIdentity;
    
    button.selected = YES;
//    button.transform = CGAffineTransformMakeScale(radio, radio);
    self.selectButton = button;
    
    [UIView animateWithDuration:.3f animations:^{
        self.indicatorView.Bw_width = button.Bw_width - 2 * btnSpace;
        self.indicatorView.Bw_centerX = button.Bw_centerX;
    }];
   
}



- (void)setSelectButtonCenter:(UIButton *)centerButton
{
    CGFloat offsetX = centerButton.Bw_centerX - k_Screen_Width / 2;
    CGFloat maxOffsetX = self.contentSize.width - k_Screen_Width + right_Width;
    if (offsetX < centerButton.Bw_width/2) {
        offsetX = 0;
    } else {
        if (offsetX > maxOffsetX) {
            offsetX = maxOffsetX;
        }
    }
    [self setContentOffset:CGPointMake(offsetX, 0) animated:YES];
}


- (void)setSelectButtonWithTag:(NSInteger)tag
{
    UIButton *button = self.buttonArray[tag];
    [self setButton:button];
    [self setSelectButtonCenter:button];
}




#pragma mark - 计算按钮的宽度
- (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize {
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}



#pragma mark - lazy loading

- (NSMutableArray *)buttonArray
{
    if (!_buttonArray) {
        _buttonArray = [NSMutableArray array];
    }
    return _buttonArray;
}

-(UIView *)indicatorView{
    if (!_indicatorView) {
        _indicatorView = [[UIView alloc] init];
    }
    return _indicatorView;
}


@end
