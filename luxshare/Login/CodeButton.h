//
//  CodeButton.h
//  DDSample
//
//  Created by 黄振 on 2020/3/24.
//  Copyright © 2020 KingYellow. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  命名 --变化的block块
 */
@class CodeButton;
typedef NSString *(^DidChangBlock)(CodeButton *countDownBtn,int second);
/**
 *  命名--完成的Block块
 */

typedef NSString *(^DidFinshBlock)(CodeButton *countDownBtn,int second);
/**
 *  name
 */

typedef void(^TouchDownBlock)(CodeButton *countDownBtn,NSInteger tag);

@interface CodeButton : UIButton


/**
 *  变化
 */
@property (nonatomic, copy) DidChangBlock didChangBlock;


/**
 *  完成
 */
@property (nonatomic, copy) DidFinshBlock didFinshBlock;


/**
 *  name
 */
@property (nonatomic, copy) TouchDownBlock touchDownBlock;


- (void)addToucheHandler:(TouchDownBlock)touchHandler;


- (void)didChangBlock:(DidChangBlock)changBlock;


- (void)didFinshBlock:(DidFinshBlock)finshBlock;

/**
 *  开始
 */

- (void)startWithSecond:(int)totalSecond;

/**
 *  停止
 */

- (void)stop;

@end

