//
//  Header.h
//  Pods
//
//  Created by Goko on 2018/7/6.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^DoneActionBlock)(NSString *changedName);

/// Family Management Service
@protocol TYFamilyProtocol <NSObject>

@optional

/// jump to Family Management ViewController
- (void)gotoFamilyManagement;

@end
