//
//  TYSmartSceneBizProtocol.h
//  TYModuleServices
//
//  Created by TuyaInc on 2019/3/7.
//

#import <Foundation/Foundation.h>

@class TuyaSmartSceneModel;

NS_ASSUME_NONNULL_BEGIN

@protocol TYSmartSceneBizProtocol <NSObject>

/**
zh^
获取场景列表，包括自动化和场景
zh$
en^
Get scene list
en$
@param homeId zh^ 家庭id zh$ en^ home id en$
 */
- (void)getSceneListWithHomeId:(long long)homeId withSuccess:(void(^)(NSArray <TuyaSmartSceneModel *> *scenes))success failure:(void(^)(NSError *error))failure;

@end

NS_ASSUME_NONNULL_END
