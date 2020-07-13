//
//  UITableView+Exp.m
//  exp
//
//  Created by 米翊米 on 2017/8/29.
//  Copyright © 2017年 🐨🐨🐨. All rights reserved.
//

#import "UITableView+Exp.h"
#import "NSObject+Exp.h"
#import "QZHToolMacro.h"

@implementation UITableView (Exp)

/**
 tableview default
 */
- (void)exp_tableViewDefault {
    [self exp_separatorHiddenNoneData];
    [self exp_cellAutoHeight];
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
    
    self.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.00001)];
    self.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.00001)];
    
    if (@available(iOS 11.0, *)) {
        self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        self.estimatedSectionHeaderHeight = 0;
        self.estimatedSectionFooterHeight = 0;
        self.sectionFooterHeight = 0;
        self.sectionHeaderHeight = 0;
        self.estimatedRowHeight = 100;
    } else {
        [self exp_getCurrentVC].automaticallyAdjustsScrollViewInsets = NO;
    }
}

/**
 footerView
 */
- (void)exp_tableViewFooterView {
    self.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, QZHScreenWidth, QZHHeightBottom)];
}

/**
 隐藏多余分割线
 */
- (void)exp_separatorHiddenNoneData {
    self.tableFooterView = [UIView new];
}

/**
 左边距为0
 */
- (void)exp_separatorZero {
    self.separatorInset = UIEdgeInsetsZero;
    self.layoutMargins = UIEdgeInsetsZero;
    self.preservesSuperviewLayoutMargins = false;
}

/**
 隐藏分割线
 */
- (void)exp_separatorHidden {
    self.separatorStyle = UITableViewCellSelectionStyleNone;
}

/**
 自动计算cell高度
 */
- (void)exp_cellAutoHeight {
    
    self.rowHeight = UITableViewAutomaticDimension;
    self.estimatedRowHeight = 100;
}

/**
 初始化从xib

 @param nibName xib名称
 @param identifier 重用标识符
 */
- (void)exp_initCellFromNib:(NSString *)nibName identifier:(NSString *)identifier {
    [self registerNib:[UINib nibWithNibName:nibName bundle:nil] forCellReuseIdentifier:identifier];
}

/**
 初始化从class
 
 @param className class名称
 @param identifier 重用标识符
 */
- (void)exp_initCellFromClass:(NSString *)className identifier:(NSString *)identifier {
    [self registerClass:NSClassFromString(className) forCellReuseIdentifier:identifier];
}

///注册表头表尾class
- (void)exp_initHeaderFooterViewFromClass:(NSString *)className identifier:(NSString *)identifier {
    [self registerClass:NSClassFromString(className) forHeaderFooterViewReuseIdentifier:identifier];
}

///注册表头表尾xib
- (void)exp_initHeaderFooterViewFromXib:(NSString *)nibName identifier:(NSString *)identifier {
    [self registerNib:[UINib nibWithNibName:nibName bundle:nil] forHeaderFooterViewReuseIdentifier:identifier];
}

///按照section圆角
- (void)exp_groupRadius:(CGFloat)radius space:(CGFloat)space backColor:(UIColor *)backColor shadowColor:(UIColor *)shadowColor selectedBackColor:(UIColor *)selectColor willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    // 设置cell的背景色为透明，如果不设置这个的话，则原来的背景色不会被覆盖
    cell.backgroundColor = UIColor.clearColor;
    cell.contentView.backgroundColor = UIColor.clearColor;
    
    // 创建shapeLayer
    CAShapeLayer *viewlayer = [[CAShapeLayer alloc] init];
    CAShapeLayer *shadowLayer1 = [[CAShapeLayer alloc] init];
    CAShapeLayer *shadowLayer2 = [[CAShapeLayer alloc] init];
    CAShapeLayer *backgroundLayer = [[CAShapeLayer alloc] init];
    
    // 创建一个可变的图像Path句柄，该路径用于保存绘图信息
    CGMutablePathRef pathRef = CGPathCreateMutable();
    CGMutablePathRef pathRef1 = CGPathCreateMutable();
    CGMutablePathRef pathRef2 = CGPathCreateMutable();
    
    // 第一个参数,是整个 cell 的 bounds, 第二个参数是距左右两端的距离,第三个参数是距上下两端的距离
    CGRect bounds = CGRectInset(cell.bounds, space, 0);
    NSInteger rows = [self numberOfRowsInSection:indexPath.section];
    NSInteger row = indexPath.row;
    // 圆角弧度半径
    CGFloat cornerRadius = radius;
    
    if (rows == 1) {
        CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMidY(bounds));
        CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds), CGRectGetMidX(bounds), CGRectGetMinY(bounds), cornerRadius);
        CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
        CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds), CGRectGetMidX(bounds), CGRectGetMaxY(bounds), cornerRadius);
        CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds), CGRectGetMinX(bounds), CGRectGetMidY(bounds), cornerRadius);
        CGPathAddLineToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMidY(bounds));
    } else {
        if (row == 0) {
            CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds));
            CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds), CGRectGetMidX(bounds), CGRectGetMinY(bounds), cornerRadius);
            CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
            CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds));
        } else if (row == rows-1) {
            CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds));
            CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds), CGRectGetMidX(bounds), CGRectGetMaxY(bounds), cornerRadius);
            CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
            CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds));
        } else {
            CGPathAddRect(pathRef, nil, bounds);
            CGPathMoveToPoint(pathRef1, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds));
            CGPathAddLineToPoint(pathRef1, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds));
            CGPathMoveToPoint(pathRef2, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds));
            CGPathAddLineToPoint(pathRef2, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds));
        }
    }
    
    viewlayer.path = pathRef;
    backgroundLayer.path = pathRef;
    shadowLayer1.path = pathRef;
    if (row > 0 && row < rows-1) {
        shadowLayer1.path = pathRef1;
        shadowLayer2.path = pathRef2;
    }
    CFRelease(pathRef);
    CFRelease(pathRef1);
    CFRelease(pathRef2);
    viewlayer.fillColor = backColor.CGColor;
    
    // view大小与cell一致
    UIView *roundView = [[UIView alloc] initWithFrame:bounds];
    [roundView.layer insertSublayer:viewlayer atIndex:0];
    roundView.backgroundColor = UIColor.clearColor;
    cell.backgroundView = roundView;
    
    if (shadowColor) {
        shadowLayer1.fillColor = [UIColor clearColor].CGColor;
        shadowLayer1.shadowColor = shadowColor.CGColor;
        shadowLayer1.shadowRadius = 3;
        shadowLayer1.shadowOpacity = 1;
        shadowLayer1.lineWidth = 1;
        shadowLayer1.strokeColor = backColor.CGColor;
        if (row == 0) {
            shadowLayer1.shadowOffset = CGSizeMake(0, 1);
        } else if (row == rows-1) {
            shadowLayer1.shadowOffset = CGSizeMake(0, 2);
        } else {
            shadowLayer1.shadowOffset = CGSizeMake(0, 0);
        }
        
        shadowLayer2.fillColor = [UIColor clearColor].CGColor;
        shadowLayer2.shadowColor = shadowColor.CGColor;
        shadowLayer2.shadowRadius = 3;
        shadowLayer2.shadowOpacity = 1;
        shadowLayer2.lineWidth = 1;
        shadowLayer2.strokeColor = backColor.CGColor;
        shadowLayer2.shadowOffset = CGSizeMake(0, 0);
        
        [roundView.layer insertSublayer:shadowLayer1 atIndex:0];
        [roundView.layer insertSublayer:shadowLayer2 atIndex:0];
    }
    
    UIView *selectedBackgroundView = [[UIView alloc] initWithFrame:bounds];
    selectedBackgroundView.backgroundColor = UIColor.clearColor;
    if (selectColor) {
        backgroundLayer.fillColor = selectColor.CGColor;
    } else {
        backgroundLayer.fillColor = UIColor.lightGrayColor.CGColor;
    }
    [selectedBackgroundView.layer insertSublayer:backgroundLayer atIndex:0];
    cell.selectedBackgroundView = selectedBackgroundView;
}

- (void)exp_refreshAtIndexSection:(NSInteger)section{
    //局部section刷新
    NSIndexSet * nd=[[NSIndexSet alloc]initWithIndex:section];
    [self reloadSections:nd withRowAnimation:UITableViewRowAnimationNone];

}

- (void)exp_refreshAtIndexSection:(NSInteger)section Row:(NSInteger)row;{

    //局部cell刷新
    NSIndexPath *te=[NSIndexPath indexPathForRow:row inSection:section];
    [self reloadRowsAtIndexPaths:[NSArray arrayWithObjects:te,nil] withRowAnimation:UITableViewRowAnimationNone];
}
@end
