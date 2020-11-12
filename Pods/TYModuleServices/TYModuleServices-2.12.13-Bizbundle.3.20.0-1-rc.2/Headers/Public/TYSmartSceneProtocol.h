//
//  TYSmartSceneProtocol.h
//  TYSmartSceneModule
//
//  Created by huangmengfei on 2018/5/7.
//

#import <Foundation/Foundation.h>

@class TuyaSmartSceneModel;

@protocol TYSmartSceneProtocol <NSObject>

//新增自动化场景
- (void)addAutoScene:(void(^)(TuyaSmartSceneModel *secneModel, BOOL addSuccess))callback;

//编辑场景
- (void)editScene:(TuyaSmartSceneModel *)model;

@end
