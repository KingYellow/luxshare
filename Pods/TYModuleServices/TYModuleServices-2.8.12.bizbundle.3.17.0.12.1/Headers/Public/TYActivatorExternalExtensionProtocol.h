//
//  TYActivatorExternalExtensionProtocol.h
//  TYModuleServices
//
//  Created by huangjj on 2020/7/2.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol TYActivatorExternalExtensionProtocol <NSObject>

/**
 *  Back action form category View Controller
 *  Need to implement when additional operations are needed
 */
- (BOOL)categoryViewControllerCustomBackAction;

@end


