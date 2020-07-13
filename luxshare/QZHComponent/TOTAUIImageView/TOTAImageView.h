//
//  TOTAImageView.h
//  DDSample
//
//  Created by 黄振 on 2020/4/16.
//  Copyright © 2020 KingYellow. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TOTAImageView : UIImageView

@property (copy, nonatomic)UILabel *placeLab;

/// 加载图片失败时候显示文字效果
/// @param urlString  图片链接
/// @param placeholder  占位图
/// @param text  要显示的文字
/// @param length  要显示的文字长度


- (void)exp_loadImageUrlString:(NSString *)urlString cornerStyle:(QZHImageViewCornerStyle) cornerStyle placeholder:(NSString *)placeholder labText:(NSString *)text textLength:(NSInteger)length;
@end

NS_ASSUME_NONNULL_END
