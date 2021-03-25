//
//  MyCamera.h
//  IOTCamViewer
//
//  Created by Cloud Hsiao on 12/7/2.
//  Copyright (c) 2012年 TUTK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <IOTCamera/Camera.h>
#import <AVFoundation/AVFoundation.h>





typedef enum ChannelStatus{

    ChannelStatus_NONE              = CONNECTION_STATE_NONE,
    ChannelStatus_CONNECTING        = CONNECTION_STATE_CONNECTING,
    ChannelStatus_CONNECTED         = CONNECTION_STATE_CONNECTED,
    ChannelStatus_DISCONNECTED      = CONNECTION_STATE_DISCONNECTED,
    ChannelStatus_UNKNOWN_DEVICE    = CONNECTION_STATE_UNKNOWN_DEVICE,
    ChannelStatus_WRONG_PASSWORD    = CONNECTION_STATE_WRONG_PASSWORD,
    ChannelStatus_TIMEOUT           = CONNECTION_STATE_TIMEOUT,
    ChannelStatus_UNSUPPORTED       = CONNECTION_STATE_UNSUPPORTED,
    ChannelStatus_CONNECT_FAILED    = CONNECTION_STATE_CONNECT_FAILED

} ChannelStatus;

@protocol MyCameraDelegate;

@interface MyCamera : Camera <CameraDelegate>
{
    
    //目前連線的channel
    NSInteger lastChannel;
    
    NSInteger remoteNotifications;
    NSMutableArray *arrayStreamChannel;
    NSString *viewAcc;

    NSString *viewPwd;
	
	BOOL bIsSupportTimeZone;
	int nGMTDiff;
	NSString* strTimeZone;
    
    BOOL bIsSyncOnCloud;
    BOOL bisAddFromCloud;
    
    //是否支援多Camera
    BOOL isSupportMultiStream;
}

@property (nonatomic, weak)   id<MyCameraDelegate>  delegateMyCamera;
@property (readonly)            NSInteger           remoteNotifications;
@property (nonatomic, assign)   BOOL                bIsSupportTimeZone;
@property (nonatomic, assign)   BOOL                bIsSyncOnCloud;
@property (nonatomic, assign)   BOOL                bisAddFromCloud;
@property (nonatomic, assign)   int                 nGMTDiff;
@property (nonatomic, copy)     NSString            * strTimeZone;
@property (nonatomic, assign)   BOOL                isWrongPassword;
@property (nonatomic, assign)   NSInteger           qvgaLevel;

@property (nonatomic, strong)   NSString            *dev_nickname;
@property (nonatomic, strong)   NSString            *dev_name;
@property (nonatomic, strong)   NSString            *dev_pwd;
@property (nonatomic, assign)   NSInteger           sdcard_format;
@property (nonatomic, assign)   NSInteger           lastChannel;
@property (nonatomic, assign)   NSInteger           tpnsInterval;
@property (nonatomic, assign)   NSInteger           audio_format;
@property (nonatomic, assign)   NSInteger           wakeup;
@property (nonatomic, strong)   NSString            *snapshot;
@property (nonatomic, assign)   NSInteger           isSync;
@property (nonatomic, copy)     NSString            *viewAcc;
@property (nonatomic, copy)     NSString            *viewPwd;
@property (nonatomic, assign)   NSInteger           dev_type;
//是否支援多Camera
@property (nonatomic, assign)   BOOL                isSupportMultiStream;

//存放多channel的位置,NSNumber
@property (nonatomic, strong)   NSMutableDictionary *slotPositionDic; // value:Channel key:position

// for dropbox feature
@property (assign) BOOL isSupportDropbox;
@property (assign) BOOL isLinkDropbox;

- (id)initWithName:(NSString *)name viewAccount:(NSString *)viewAcc viewPassword:(NSString *)viewPwd;
- (void)start:(NSInteger)channel;
- (void)start4EventPlayback:(NSInteger)channel;
- (void)setRemoteNotification:(NSInteger)type EventTime:(long)time;
- (void)clearRemoteNotifications;
- (NSArray *)getSupportedStreams;
- (BOOL)getAudioInSupportOfChannel:(NSInteger)channel;
- (BOOL)getAudioOutSupportOfChannel:(NSInteger)channel;
- (BOOL)getPanTiltSupportOfChannel:(NSInteger)channel;
- (BOOL)getEventListSupportOfChannel:(NSInteger)channel;
- (BOOL)getPlaybackSupportOfChannel:(NSInteger)channel;
- (BOOL)getWiFiSettingSupportOfChannel:(NSInteger)channel;
- (BOOL)getMotionDetectionSettingSupportOfChannel:(NSInteger)channel;
- (BOOL)getRecordSettingSupportOfChannel:(NSInteger)channel;
- (BOOL)getFormatSDCardSupportOfChannel:(NSInteger)channel;
- (BOOL)getVideoFlipSupportOfChannel:(NSInteger)channel;
- (BOOL)getEnvironmentModeSupportOfChannel:(NSInteger)channel;
- (BOOL)getMultiStreamSupportOfChannel:(NSInteger)channel;
- (NSInteger)getAudioOutFormatOfChannel:(NSInteger)channel;
- (BOOL)getVideoQualitySettingSupportOfChannel:(NSInteger)channel;
- (BOOL)getDeviceInfoSupportOfChannel:(NSInteger)channel;
- (BOOL)getTimeZoneSupportOfChannel:(NSInteger)channel;
- (void)setSync:(NSInteger)isSync;
- (void)setCloud:(NSInteger)isFromCloud;


+ (NSString*)getConnModeString:(NSInteger)connMode;

#pragma mark - Command Gets and Sets
- (void) commandGetAudioOutFormatWithChannel:(NSInteger)channel;
- (void) commandSetQVGAWithLevel:(NSInteger)level WithChannel:(NSInteger)channel;
- (void) commandGetQVGAWithChannel:(NSInteger)channel;
- (void) commandSetPasswordWithOld:(NSString *)oldPassword new:(NSString *)newPassword;
- (void) commandGetDeviceInfo;
- (void) commandGetWakeupSleepInfo;
- (void) commandCallReq;
- (void) commandCallResp;
- (void) commandGetRecordMode;
@end



@protocol MyCameraDelegate <NSObject>
@optional
- (void)camera:(MyCamera *)camera _didReceiveRemoteNotification:(NSInteger)eventType EventTime:(long)eventTime;
- (void)camera:(MyCamera *)camera _didReceiveRawDataFrame:(const char *)imgData VideoWidth:(NSInteger)width VideoHeight:(NSInteger)height;
- (void)camera:(MyCamera *)camera _didReceiveJPEGDataFrame:(const char *)imgData DataSize:(NSInteger)size;
- (void)camera:(MyCamera *)camera _didReceiveFrameInfoWithChannel:(NSInteger)channel videoWidth:(NSInteger)videoWidth VideoHeight:(NSInteger)videoHeight VideoFPS:(NSInteger)fps VideoBPS:(NSInteger)videoBps AudioBPS:(NSInteger)audioBps OnlineNm:(NSInteger)onlineNm FrameCount:(unsigned long)frameCount IncompleteFrameCount:(unsigned long)incompleteFrameCount;
- (void)camera:(MyCamera *)camera _didChangeSessionStatus:(NSInteger)status;
- (void)camera:(MyCamera *)camera _didChangeChannelStatus:(NSInteger)channel ChannelStatus:(NSInteger)status;
- (void)camera:(MyCamera *)camera _didReceiveIOCtrlWithType:(NSInteger)type Data:(const char*)data DataSize:(NSInteger)size;
- (void)CameraUpdateDecodedH264SampleBuffer: (CMSampleBufferRef)sampleBuffer;
- (void)camera:(Camera *)camera _didStartServerSuccess:(BOOL)isSuccess;
- (void)camera:(Camera *)camera _didStartListenSuccess:(BOOL)isSuccess;
- (void)camera:(Camera *)camera _didStartTalkSuccess:(BOOL)isSuccess ErrorCode:(NSInteger) errorCode;
- (void)camera:(Camera *)camera _didReceiveTimeStamp:(NSInteger)timeStamp;

// 将接收解码后的 PCM 数据抛给上层
- (void)camera:(Camera *)camera _didRecvAudioOutput:(NSData *)pcmData Channel:(int)channel;
// 将采集到的 PCM 数据抛给上层
- (void)camera:(Camera *)camera _didSendAudioOutput:(NSData *)audioData Length:(NSInteger)length Codec:(NSInteger)codec Channel:(NSInteger)channel;


@end

extern BOOL g_bDiagnostic;
