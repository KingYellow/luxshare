//
//  TOTAImageView.m
//  DDSample
//
//  Created by 黄振 on 2020/4/16.
//  Copyright © 2020 KingYellow. All rights reserved.
//

#import "TOTAImageView.h"

@implementation TOTAImageView

-(instancetype)init{
    if (self = [super init]) {
        [self addSubview:self.placeLab];
        self.frame = CGRectMake(0, 0, 36, 36);
        [self.placeLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self);
        }];
    }
    return self;
}

- (void)exp_loadImageUrlString:(NSString *)urlString cornerStyle:(QZHImageViewCornerStyle) cornerStyle placeholder:(NSString *)placeholder labText:(NSString *)text textLength:(NSInteger)length{
    if (cornerStyle == QZHImageViewCornerTriangle) {
        [self.placeLab mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(0);
        }];
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(18, 0)];
        [path addLineToPoint:CGPointMake(0, 36)];
        [path addLineToPoint:CGPointMake(36, 36)];
        [path closePath];
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        shapeLayer.path = path.CGPath;
        self.layer.mask = shapeLayer;

        
    }else if(cornerStyle == QZHImageViewCornerCircle){
        QZHViewRadius(self, self.frame.size.width/2)
    }else if(cornerStyle == QZHImageViewCornerRadio){
        QZHViewRadius(self, 4.0)
    }
    
    UIImage *placeholderImage = [UIImage imageNamed:placeholder];
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
           weakSelf.image = [UIImage exp_imageScaleWithImage:image toByte:0];
           weakSelf.placeLab.hidden = YES;
       }else{
           weakSelf.image = placeholderImage;
           self.placeLab.text = text.length > length?[text substringToIndex:length]:text;
           self.placeLab.hidden = NO;
       }
    }];

    return;
}
#pragma lazy
-(UILabel *)placeLab{
    if (!_placeLab) {
        _placeLab = [[UILabel alloc] init];
        _placeLab.textColor = QZHKIT_Color_BLACK_54;
        _placeLab.font = QZHTEXT_FONT(16);
        _placeLab.text = @"";
        _placeLab.textAlignment = NSTextAlignmentCenter;
    }
    return _placeLab;
}
@end
