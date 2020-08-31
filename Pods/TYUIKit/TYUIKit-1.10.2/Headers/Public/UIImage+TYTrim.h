//
//  UIImage+TYTrim.h
//  TYUIKit
//
//  Created by TuyaInc on 2018/12/20.
//

#import <UIKit/UIKit.h>

@interface UIImage (TYTrim)

#pragma mark - Resize
/**
 [^zh]按比例缩放图片[$zh]
 [^en]resize image with scale[^en]
 */
- (UIImage *)ty_imageApplyingScale:(CGFloat)scale;
/**
[^zh]缩放图片到指定大小[$zh]
[^en]resize image[^en]
*/
- (UIImage *)ty_imageApplyingSize:(CGSize)newSize;
/**
[^zh]缩放图片到指定大小[$zh]
[^en]resize image with content mode[^en]
*/
- (UIImage *)ty_imageApplyingSize:(CGSize)newSize withContentMode:(UIViewContentMode)contentMode;

#pragma mark - Crop
/**
 [^zh]图片裁剪[$zh]
 [^en]crop image[$en]
 */
- (UIImage *)ty_imageApplyingCropRect:(CGRect)rect;

#pragma mark - Corner/Border
/**
 [^zh]为图片添加圆角[$zh]
 [^en]re-render image with corner[$en]
 */
- (UIImage *)ty_imageApplyingCornerRadius:(CGFloat)radius;
- (UIImage *)ty_imageApplyingCornerRadius:(CGFloat)radius withBorderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor;

#pragma mark - Rotation
/**
[^zh]水平翻转图片[$zh]
[^en]flip image horizontally[$en]
*/
- (UIImage *)ty_imageApplyingHorizontalFlip;
/**
[^zh]垂直翻转图片[$zh]
[^en]flip image vertically[$en]
*/
- (UIImage *)ty_imageApplyingVerticalFlip;

#pragma mark - TintColor
/**
 [^zh]修改图片颜色[$zh]
 [^en]re-render image with tint color[$en]
 */
- (UIImage *)ty_imageApplyingTintColor:(UIColor *)color;

#pragma mark - Alpha
/**
 [^zh]修改图片透明度[$zh]
 [^zh]re-render image with alpha[$zh]
 */
- (UIImage *)ty_imageApplyingAlpha:(CGFloat)alpha;



@end
