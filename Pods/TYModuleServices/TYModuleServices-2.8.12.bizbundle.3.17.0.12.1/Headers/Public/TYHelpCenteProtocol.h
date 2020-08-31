//
//  TYHelpCenteProtocol.h
//  TYModuleServices
//
//  Created by 陈立 on 2020/7/16.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol TYHelpCenteProtocol <NSObject>

@optional

/**
 zh^
 跳转到常见问题与反馈页面
 zh$

 en^
 jump to HelpCenter page
 en$
*/
- (void)gotoHelpCenter;

@end
