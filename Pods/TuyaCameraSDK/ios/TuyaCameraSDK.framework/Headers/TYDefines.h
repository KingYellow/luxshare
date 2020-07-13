//
//  TYDefines.h
//  TYCameraSdk
//
//  Created by Jim on 2018/3/14.
//  Copyright © 2018年 Tuya. All rights reserved.
//

#ifndef __TYDEFINES_H__
#define __TYDEFINES_H__

typedef struct tagTuyaVideoFrameInfo{
    int codecid;
    int nWidth;
    int nHeight;
    
    int nFrameRate;
    int nIsKeyFrame;
    char *sei;
    int nSeiSize;
    unsigned long long nTimeStamp;
    unsigned long long nDuration;
    unsigned long long nProgress;
}TuyaVideoFrameInfo;

typedef struct tagTuyaAudioFrameInfo{
    int codecid;
    int nChannelNum;
    int nSampleRate;
    int nBitWidth;
    unsigned long long nTimeStamp;
    unsigned long long nDuration;
    unsigned long long nProgress;
    bool bShowProgressOnly ;
}TuyaAudioFrameInfo;

typedef enum{
    kTuyaErrCode_NoErr                  =  0,       // 错误码 无错
    kTuyaErrCode_FragmentEnd            =  1,       // 错误码 片段播放结束通知
    kTuyaErrCode_ModuleNotInitialized   = -10000,   // 错误码 未初始化
    kTuyaErrCode_NotConnected           = -10001,   // 错误码 设备未连接
    kTuyaErrCode_SessionInvalid         = -10002,   // 错误码 无效的session
    kTuyaErrCode_TimeOut                = -10003,   // 错误码 超时
    kTuyaErrCode_ConnectionCancelled    = -10004,   // 错误码 连接被取消
    kTuyaErrCode_DeviceNotOnline        = -10006,   // 错误码 设备不在线
    kTuyaErrCode_InvalidCommand         = -20001,   // 错误码 无效的命令
    kTuyaErrCode_ParamsInvalid          = -20002,   // 错误码 无效的参数
    kTuyaErrCode_DataInvalid            = -20003,   // 错误码 无效的数据
    kTuyaErrCode_Interrupted            = -20004,   // 错误码 操作被中断
    kTuyaErrCode_OperationNotAllowed    = -20005,   // 错误码 操作不允许
    kTuyaErrCode_VersionNotSupported    = -20006,   // 错误码 当前app版本不支持该协议[需要升级app]
    kTuyaErrCode_Busy                   = -20007,   // 错误码 设备当前繁忙[例:对讲已被其他占用之类]
    kTuyaErrCode_OutOfMemory            = -20008,   // 错误码 内存不足
    kTuyaErrCode_DownloadFailed         = -30001,   // 错误码 下载文件失败
}TuyaErrCode;

typedef enum{
    kTuyaSessionStatus_Connected        =  0,       // 链接成功
    kTuyaSessionStatus_ConnectTimeout   = -3,       // 链接超时
    kTuyaSessionStatus_ClosedRemote     = -12,      // 链接断开
    kTuyaSessionStatus_ClosedTimeOut    = -13,      // 链接超时
    kTuyaSessionStatus_ClosedCalled     = -14,      // 链接关闭
}TuyaSessionStatus;

typedef enum{
    kTuyaVideoClarityProflow            = 0x1,      // 省流量
    kTuyaVideoClarityStandard           = 0x2,      // 标清
    kTuyaVideoClarityHigh               = 0x4,      // 高清
    kTuyaVideoClaritySuperHigh          = 0x8,      // 超清
    kTuyaVideoClarityAudioOnly          = 0xFFFF,   // 语音模式(只有语音没有视频)
}TuyaVideoClarityMode;

typedef enum{
    TY_VIDEO_CLARITY_PROFLOW            = 0x1,      // 省流量
    TY_VIDEO_CLARITY_STANDARD           = 0x2,      // 标清
    TY_VIDEO_CLARITY_HIGH               = 0x4,      // 高清
    TY_VIDEO_CLARITY_S_HIGH             = 0x8,      // 超清
    TY_VIDEO_CLARITY_SS_HIGH            = 0x10,     // 超超清
}TRANSFER_VIDEO_CLARITY_TYPE_E;

typedef enum{
    TY_VIDEO_OUTPUT_FORMAT_RAWDATA,                 // 视频裸流(H.264/H.265)
    TY_VIDEO_OUTPUT_FORMAT_YUV,                     // 解码后的数据
}TuyaVideoOutputFormat;

typedef enum{
    TY_AUDIO_OUTPUT_FORMAT_RAWDATA,                 // 音频裸流(G.711a/u/pcm/aac)
    TY_AUDIO_OUTPUT_FORMAT_PCM,                     // 解码后的数据
}TuyaAudioOutputFormat;

#endif // __TYDEFINES_H__
