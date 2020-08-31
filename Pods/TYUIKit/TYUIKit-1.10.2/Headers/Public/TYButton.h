//
//  TYButton.h
//  TYUIKit
//
//  Created by TuyaInc on 2019/7/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    TYButtonImageLocationLeft,  ///< [^zh]图片在左侧[$zh] [^en]the image is on the left[$en]
    TYButtonImageLocationRight, ///< [^zh]图片在右侧[$zh] [^en]the image is on the right[$en]
    TYButtonImageLocationTop,   ///< [^zh]图片在上方[$zh] [^en]the image is on the top[$en]
    TYButtonImageLocationBottom ///< [^zh]图片在下方[$zh] [^en]the image is on the bottom[$en]
} TYButtonImageLocation;


@interface TYButton : UIButton

/*
 [^zh]图片相对按钮的位置[$zh]
 [^zh]position of the image relative to the button[$zh]
 */
@property (nonatomic) TYButtonImageLocation ty_imageLocation;

/*
 [^zh]图片和标题的间距[$zh]
 [^en]space between image and title[$en]
 */
@property (nonatomic) CGFloat ty_imageTitleSpace;

- (void)ty_setBackgroundColor:(UIColor *)color forState:(UIControlState)state;
- (UIColor *)ty_backgroundColorForState:(UIControlState)state;

@end

NS_ASSUME_NONNULL_END
