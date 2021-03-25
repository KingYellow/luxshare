//
//  CameraPlayView.h
//  luxshare
//
//  Created by 黄振 on 2020/7/11.
//  Copyright © 2020 KingYellow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecordProgressView.h"
#import "CamerGestureView.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^Playbuttontag)(UIButton *sender, BOOL selected);

@interface CameraPlayView : UIView
@property (strong, nonatomic)UIButton *playBtn;
@property (strong, nonatomic)UIButton *voiceBtn;
@property (strong, nonatomic)UIButton *definitionBtn;
@property (strong, nonatomic)UIButton *horizontalBtn;
@property (copy, nonatomic)Playbuttontag buttonBlock;
@property (strong, nonatomic)UIImageView *playPreGif;
@property (strong, nonatomic)UIImageView *wifiIMG;
@property (strong, nonatomic)UIImageView *batteryIMG;
@property (strong, nonatomic)RecordProgressView *recordProgressView;
@property (strong, nonatomic)RecordProgressView *talkProgressView;
@property (strong, nonatomic)UIButton *videoRecordBtn;
@property (strong, nonatomic)UIButton *videoTalkBtn;
@property (strong, nonatomic)UIButton *videoPhotoBtn;
@property (strong, nonatomic)CamerGestureView *camerGestureView;
@end

NS_ASSUME_NONNULL_END
