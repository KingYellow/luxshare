//
//  TOTAMulltiCollectionView.m
//  DDSample
//
//  Created by 黄振 on 2020/4/17.
//  Copyright © 2020 KingYellow. All rights reserved.
//


#import "TOTAMulltiCollectionView.h"
#import "TOTAMulltiCCell.h"

@interface TOTAMulltiCollectionView()
@end

@implementation TOTAMulltiCollectionView
+ (TOTAMulltiCollectionView *)creatWithFrame:(CGRect)frame{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(frame.size.width, frame.size.height);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.minimumLineSpacing = 1;
    flowLayout.minimumInteritemSpacing = 0;
    TOTAMulltiCollectionView *view = [[TOTAMulltiCollectionView alloc] initWithFrame:frame collectionViewLayout:flowLayout];
    view.pagingEnabled = YES;
    view.backgroundColor = QZHKIT_COLOR_LEADBACK;
    return view;
}


@end
