//
//  UIImageView+Exp.m
//  DDSample
//
//  Created by 黄振 on 2020/4/15.
//  Copyright © 2020 KingYellow. All rights reserved.
//

#import "UIImageView+Exp.h"

@implementation UIImageView (Exp)


- (void)exp_loadImageUrlString:(NSString *)urlString placeholder:(NSString *)placeholder{
    UIImage *placeholderImage = [UIImage imageNamed:placeholder];
    if ([urlString exp_Length] == 0) {
        if (placeholder) {
            self.image = placeholderImage;
        }
        return;
    }
    if (![urlString hasPrefix:@"https://"] && ![urlString hasPrefix:@"http://"]) {
        urlString = [QZHPicHost stringByAppendingString:urlString];
    }
    
    urlString = [urlString stringByReplacingOccurrencesOfString:@"//" withString:@"/"];
    urlString = [urlString stringByReplacingOccurrencesOfString:@"http:/" withString:@"http://"];
    urlString = [urlString stringByReplacingOccurrencesOfString:@"https:/" withString:@"https://"];
    NSURL *url = [NSURL URLWithString:urlString];
    
    QZHWS(weakSelf);
    [self yy_setImageWithURL:url placeholder:placeholderImage options:YYWebImageOptionSetImageWithFadeAnimation progress:nil transform:^UIImage * _Nullable(UIImage * _Nonnull image, NSURL * _Nonnull url) {
        CGSize size = image.size;
        CGFloat width = size.width;
        CGFloat height = size.height;
        if (width > 1000) {
            width = 1000;
            height = size.height*width/size.width;
        } else if (height > 1000) {
            height = 1000;
            width = size.width*height/size.height;
        }
        return [image yy_imageByResizeToSize:CGSizeMake(width, height) contentMode:UIViewContentModeScaleToFill];
    } completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
        if (image && image.size.width > 2) {
            weakSelf.image = image;
        }else{
            weakSelf.image = placeholderImage;
        }
    }];
    return;
}

@end
