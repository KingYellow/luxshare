//
//  TYAlignLabel.h
//
//  Created by 尼奥 on 2020/11/1.
//

#import <UIKit/UIKit.h>

@class TYAlignLabelMaker;

typedef NS_ENUM(NSUInteger, TYAlignLabelType) {
    TYAlignLabelType_top = 1,    ///< 顶部对齐
    TYAlignLabelType_left,       ///< 左边对齐
    TYAlignLabelType_bottom,     ///< 底部对齐
    TYAlignLabelType_right,      ///< 右边对齐
    TYAlignLabelType_center      ///< 水平/垂直对齐
};

/// 链式调用
typedef TYAlignLabelMaker *(^TYAlignLabelMakerBlock)(void);

/// 非链式调用
typedef TYAlignLabelMaker *(^TYAlignLabelMakerTypeBlock)(TYAlignLabelType alignType);


@interface TYAlignLabel : UILabel
/**
 *  根据设置的对齐方式进行文本对齐
 *
 *  @param alignType 对齐block
 *  @discussion UILabel 本身不支持垂直居顶，通过重写 `textRectForBounds:limitedToNumberOfLines:` 来达成这种对齐方式
 *  @Example
 *
 *   [titleLabel textAlign:^(TYAlignLabelMaker *maker) {
 *      maker.top().center();
 *   }];
 */
-(void)textAlign:(void(^)(TYAlignLabelMaker *maker))alignType;

@end


@interface TYAlignLabelMaker : NSObject

/* 链式调用 */
-(TYAlignLabelMakerBlock)top;
-(TYAlignLabelMakerBlock)left;
-(TYAlignLabelMakerBlock)bottom;
-(TYAlignLabelMakerBlock)right;
-(TYAlignLabelMakerBlock)center;

/* 非链式调用 */
-(TYAlignLabelMakerTypeBlock)addAlignType;

@end


