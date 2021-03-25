//
// TuyaSmartFeedbackModel.h
// TuyaSmartFeedbackKit
//
// Copyright (c) 2014-2021 Tuya Inc (https://developer.tuya.com)

typedef enum : NSUInteger {
    TuyaSmartFeedbackQuestion,
    TuyaSmartFeedbackAnswer,
} TuyaSmartFeedbackType;

@interface TuyaSmartFeedbackModel : NSObject

/// The feedback type.
@property (nonatomic, assign) TuyaSmartFeedbackType     type;

/// The time when the feedback opened.
@property (nonatomic, assign) NSTimeInterval            ctime;

/// The feedback ID.
@property (nonatomic, assign) NSUInteger                uniqueId;

/// The content of the feedback.
@property (nonatomic, strong) NSString                  *content;

@end
