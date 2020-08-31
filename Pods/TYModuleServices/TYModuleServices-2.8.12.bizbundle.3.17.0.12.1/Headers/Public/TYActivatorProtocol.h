//
//  TYActivatorProtocol.h
//  TYModuleServices
//
//  Created by TuyaInc on 2018/4/13.
//

#ifndef TYActivatorProtocol_h
#define TYActivatorProtocol_h

typedef NS_ENUM(NSUInteger, TYActivatorCompletionNode) {
    TYActivatorCompletionNodeNormal
};

@protocol TYActivatorProtocol <NSObject>

/**
 * Start config
 */
- (void)gotoCategoryViewController;

/**
 *  Obtain device information after each device connection
 *  @param node completion node, default TYActivatorCompletionNodeNormal
 *  @param custionJump default false, set true for process not need to jump to de device panel
 */
- (void)activatorCompletion:(TYActivatorCompletionNode)node customJump:(BOOL)customJump completionBlock:(void (^)(NSArray * _Nullable deviceList))callback;

@end
#endif /* TYActivatorProtocol_h */
