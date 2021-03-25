//
//  CountrySelectView.h
//  luxshare
//
//  Created by 黄振 on 2020/6/26.
//  Copyright © 2020 KingYellow. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CountrySelectView : UIView
@property (copy, nonatomic)UILabel *nameLab;
@property (copy, nonatomic)UILabel *describeLab;

+ (CountrySelectView *)creatSelectView;

@end

NS_ASSUME_NONNULL_END
