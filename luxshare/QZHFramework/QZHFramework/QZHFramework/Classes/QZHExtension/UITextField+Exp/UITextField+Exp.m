//
//  UITextField+Exp.m
//  Creditgo
//
//  Created by 米翊米 on 2018/8/17.
//  Copyright © 2018年 米翊米. All rights reserved.
//

#import "UITextField+Exp.h"
 #import <objc/runtime.h>

@implementation UITextField (Exp)

+ (void)load {
    [super load];
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method textRect = class_getInstanceMethod(self, @selector(textRectForBounds:));
        Method custTextRect = class_getInstanceMethod(self, @selector(custTextRectForBounds:));
        
        Method editRect = class_getInstanceMethod(self, @selector(editingRectForBounds:));
        Method custEditRect = class_getInstanceMethod(self, @selector(custEditingRectForBounds:));
        
        method_exchangeImplementations(textRect, custTextRect);
        method_exchangeImplementations(editRect, custEditRect);
    });
}

- (CGRect)custTextRectForBounds:(CGRect)bounds {
    CGRect rect = [self custTextRectForBounds:bounds];
    
    rect = CGRectMake(self.contentInset.left, self.contentInset.top, rect.size.width-self.contentInset.left-self.contentInset.right, rect.size.height-self.contentInset.top-self.contentInset.bottom);
    
    return rect;
}

- (CGRect)custEditingRectForBounds:(CGRect)bounds {
    CGRect rect = [self custEditingRectForBounds:bounds];
    
    rect = CGRectMake(self.contentInset.left, self.contentInset.top, rect.size.width-self.contentInset.left-self.contentInset.right, rect.size.height-self.contentInset.top-self.contentInset.bottom);
    
    return rect;
}

///设置UITextField的边距
- (void)exp_setContentInset:(UIEdgeInsets)contentInset {
    //给系统的类增加一个属性，然后保存起来
    objc_setAssociatedObject(self, @selector(custTextRectForBounds:), NSStringFromUIEdgeInsets(contentInset), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIEdgeInsets)contentInset {
    NSString *insetStr = objc_getAssociatedObject(self, @selector(custTextRectForBounds:));
    UIEdgeInsets inset = UIEdgeInsetsFromString(insetStr);
    
    return inset;
}

@end
