//
//  UIImage+TYLayer.h
//  TYUIKit
//
//  Created by TuyaInc on 2018/11/27.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (TYLayer)

+ (UIImage *)ty_imageWithLayer:(CALayer *)layer;
+ (UIImage *)ty_imageWithView:(UIView *)view;

@end

NS_ASSUME_NONNULL_END
