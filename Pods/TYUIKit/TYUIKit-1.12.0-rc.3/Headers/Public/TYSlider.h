//
//  TYSlider.h
//  TuyaSmart
//
//  Created by 冯晓 on 16/1/19.
//  Copyright © 2016年 Tuya. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TYSlider;

@protocol TYSliderDelegate <NSObject>

@required
- (void)onSliderValueChanged:(TYSlider *)slider;
- (void)onSlidingComplete:(TYSlider *)slider;

@end

@interface TYSlider : UISlider

@property (nonatomic, weak) id <TYSliderDelegate> delegate;
@property (nonatomic, assign) float step;
@property (nonatomic, strong) UIImage *minimumTrackImage;
@property (nonatomic, strong) UIImage *maximumTrackImage;
@property (nonatomic, strong) UIImage *thumbImage;
@property (nonatomic, assign) CGFloat trackHeight;

- (void)resizeTrackImageView;
- (void)removeAllTrackImage;

@end
