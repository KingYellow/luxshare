//
//  TuyaSmartVideoImageView.h
//  TYCameraLibrary
//
//  Created by 傅浪 on 2018/6/12.
//

#import <UIKit/UIKit.h>
#import <TuyaSmartCameraBase/TuyaSmartCameraBase.h>

@interface TuyaSmartVideoImageView : UIView<TuyaSmartVideoViewType>

@property (nonatomic, assign) BOOL scaleToFill;

@property (nonatomic, strong) UIImage *image;

- (void)tuya_setScaled:(float)scaled;

- (void)tuya_setOffset:(CGPoint)offset;

- (void)tuya_clear;

- (UIImage *)screenshot;

@end
