//
//  TOTAMulltiCCell.m
//  DDSample
//
//  Created by 黄振 on 2020/4/17.
//  Copyright © 2020 KingYellow. All rights reserved.
//
#define COLLECTIONVIEW_ITEM_WIDTH    60
#define COLLECTIONVIEW_ITEM_HEIGHT   60

#define COLLECTIONVIEW_ITEMS_NUMBER_H   3
#define COLLECTIONVIEW_ITEMS_NUMBER_V   3
#import "TOTAMulltiCCell.h"
#import "TOTACardCCell.h"


@implementation TOTAMulltiCCell
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self creatSubview];
        
    }
    return self;
}
- (void)creatSubview{
    [self.contentView addSubview:self.totaView];
    self.totaView.delegate = self;
    self.totaView.dataSource = self;
    [self.totaView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
}
- (UICollectionView *)totaView{
    if (!_totaView) {

        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake(QZHScreenWidth/3-1, QZHScreenWidth/3);
        flowLayout.minimumInteritemSpacing = 1;
        flowLayout.minimumLineSpacing = 1;
        _totaView = [[UICollectionView alloc] initWithFrame:self.frame collectionViewLayout:flowLayout];
        _totaView.backgroundColor = QZHKIT_COLOR_LEADBACK;
        [_totaView registerClass:[TOTACardCCell class] forCellWithReuseIdentifier:QZHIdentifierImage];
    }
    return _totaView;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    TOTACardCCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:QZHIdentifierImage forIndexPath:indexPath];
    cell.backgroundColor = [UIColor jk_randomColor];
    cell.titleLab.text = QZHObjStringFormat(@"第%ld个",self.section * 12 + indexPath.row);
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 12;
}


- (void)setSection:(NSInteger)section{
    _section = section;
    
}
@end
