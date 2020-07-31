//
//  UIButton+Exp
//  exp
//
//  Created by 米翊米 on 2017/8/29.
//  Copyright © 2017年 🐨🐨🐨. All rights reserved.
//

#import "UIButton+Exp.h"
#import "UIColor+Grade.h"

@implementation UIButton (Image)

///加载本地图片
- (void)exp_loadImage:(NSString *)defaultString {
    UIImage *defaultImage = [UIImage imageNamed:defaultString];
    
    [self setImage:defaultImage forState:UIControlStateNormal];
}

///加载网络图片
- (void)exp_loadImageUrlString:(NSString *)urlString placeholder:(NSString *)placeholder {
    if ([urlString exp_Length] == 0) {
        if (placeholder) {
            [self setImage:[UIImage imageNamed:placeholder] forState:UIControlStateNormal];
        }
        return;
    }
    if (![urlString hasPrefix:@"https://"] && ![urlString hasPrefix:@"http://"]) {
        urlString = [QZHPicHost stringByAppendingString:urlString];
    }
    urlString = [urlString stringByReplacingOccurrencesOfString:@"//" withString:@"/"];
    urlString = [urlString stringByReplacingOccurrencesOfString:@"http:/" withString:@"http://"];
    urlString = [urlString stringByReplacingOccurrencesOfString:@"https:/" withString:@"https://"];
    
    QZHWS(weakSelf)
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf yy_setImageWithURL:[NSURL URLWithString:urlString] forState:UIControlStateNormal placeholder:[UIImage imageNamed:placeholder]];
    });
}

///加载网络图片
- (void)exp_loadImageUrlString:(NSString *)urlString placeholder:(NSString *)placeholder size:(CGSize)size {
    UIImage *placeholderImage = [[UIImage imageNamed:placeholder] jk_imageScaledToSize:size];
    if ([urlString exp_Length] == 0) {
        if (placeholder) {
            [self setImage:placeholderImage forState:UIControlStateNormal];
        }
        return;
    }
    if (![urlString hasPrefix:@"https://"] && ![urlString hasPrefix:@"http://"]) {
        urlString = [QZHPicHost stringByAppendingString:urlString];
    }
    urlString = [urlString stringByReplacingOccurrencesOfString:@"//" withString:@"/"];
    urlString = [urlString stringByReplacingOccurrencesOfString:@"http:/" withString:@"http://"];
    urlString = [urlString stringByReplacingOccurrencesOfString:@"https:/" withString:@"https://"];
    
    QZHWS(weakSelf)
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf yy_setImageWithURL:[NSURL URLWithString:urlString] forState:UIControlStateNormal placeholder:placeholderImage options:YYWebImageOptionSetImageWithFadeAnimation completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
            if (image) {
                image = [image yy_imageByResizeToSize:size contentMode:UIViewContentModeScaleAspectFill];
                image = [image yy_imageByRoundCornerRadius:size.width/2];
                [weakSelf setImage:image forState:UIControlStateNormal];
            }
        }];
    });
}

///加载网络背景图片
- (void)exp_loadBackImageUrlString:(NSString *)urlString placeholder:(NSString *)placeholder {
    if ([urlString exp_Length] == 0) {
        if (placeholder) {
            [self setBackgroundImage:[UIImage imageNamed:placeholder] forState:UIControlStateNormal];
        }
        return;
    }
    if (![urlString hasPrefix:@"https://"] && ![urlString hasPrefix:@"http://"]) {
        urlString = [QZHApiHost stringByAppendingString:urlString];
        urlString = [urlString stringByReplacingOccurrencesOfString:@"//" withString:@"/"];
    }
    [self yy_setBackgroundImageWithURL:[NSURL URLWithString:urlString] forState:UIControlStateNormal placeholder:[UIImage imageNamed:placeholder]];
}

- (void)exp_buttonState:(QZHButtonState)state {
    if (state == QZHButtonStateEnable) {
        self.userInteractionEnabled = YES;
        [self setTitleColor:QZH_KIT_Color_WHITE_70 forState:UIControlStateNormal];
        self.backgroundColor = [UIColor jk_gradientFromColor:UIColorFromHex(0x828B22) toColor:QZHKIT_COLOR_SKIN withWidth:self.frame.size.width];
    } else {
        self.userInteractionEnabled = NO;
        [self setTitleColor:QZHKIT_Color_BLACK_54 forState:UIControlStateNormal];
        self.backgroundColor = QZHKIT_Color_BLACK_26;
    }
}

@end
