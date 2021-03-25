//
//  TYTextView.h
//  TYFoundationKit
//
//  Created by TuyaInc on 2019/5/16.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TYTextView : UITextView

@property (nonatomic, strong) NSString *placeholder;
@property (nonatomic, strong) NSAttributedString *attributedPlaceholder;

- (CGRect)placeholderRectForBounds:(CGRect)bounds;

@end

NS_ASSUME_NONNULL_END
