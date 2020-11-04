//
//  UIImageView+Gif.h
//  luxshare
//
//  Created by 黄振 on 2020/7/29.
//  Copyright © 2020 KingYellow. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImageView (Gif)
@property (strong, nonatomic)dispatch_source_t timer;
- (void)startPlayGifWithImages:(NSArray *)imgArr;
- (void)stopGif;
@end

NS_ASSUME_NONNULL_END
