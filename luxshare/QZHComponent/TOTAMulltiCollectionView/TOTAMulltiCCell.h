//
//  TOTAMulltiCCell.h
//  DDSample
//
//  Created by 黄振 on 2020/4/17.
//  Copyright © 2020 KingYellow. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TOTAMulltiCCell : UICollectionViewCell<UICollectionViewDataSource,UICollectionViewDelegate>
@property (copy, nonatomic)UICollectionView *totaView;
@property (assign, nonatomic)NSInteger section;
@end

NS_ASSUME_NONNULL_END
