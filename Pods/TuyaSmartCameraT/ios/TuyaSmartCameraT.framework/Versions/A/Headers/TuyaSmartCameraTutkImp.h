//
//  TuyaSmartCameraTutkImp.h
//  TYCameraLibrary
//
//  Created by 傅浪 on 2018/7/2.
//  Copyright © 2018 TuyaSmart. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TuyaSmartCameraBase/TuyaSmartCameraBase.h>

@interface TuyaSmartCameraTutkImp : NSObject <TuyaSmartCameraType, TuyaSmartCameraMaker>

@property (nonatomic, weak) id<TuyaSmartCameraDelegate> delegate;

@property (nonatomic, assign) BOOL isRecvFrame;

@property (nonatomic, assign) BOOL autoRender;

@property (nonatomic, strong) NSString *devId;

- (instancetype)initWithP2PId:(NSString *)p2pId password:(NSString*)pwd delegate:(id<TuyaSmartCameraDelegate>)delegate;

@end
