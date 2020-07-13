//
//  CameraPlayView.h
//  luxshare
//
//  Created by 黄振 on 2020/7/11.
//  Copyright © 2020 KingYellow. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^buttontag)(NSInteger tag, BOOL selected);

@interface CameraPlayView : UIView
@property (strong, nonatomic)UIButton *playBtn;
@property (strong, nonatomic)UIButton *voiceBtn;
@property (strong, nonatomic)UIButton *definitionBtn;
@property (strong, nonatomic)UIButton *horizontalBtn;
@property (copy, nonatomic)buttontag buttonBlock;
@end

NS_ASSUME_NONNULL_END
