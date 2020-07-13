//
//  UITableView+FooterHide.h
//  DDSample
//
//  Created by 黄振 on 2020/4/16.
//  Copyright © 2020 KingYellow. All rights reserved.
//


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITableView (FooterHide)
/**是否开启<数据不满一页的话就自动隐藏下面的mj_footer>功能*/
@property(nonatomic, assign) BOOL autoHideMjFooter;
@end

NS_ASSUME_NONNULL_END
