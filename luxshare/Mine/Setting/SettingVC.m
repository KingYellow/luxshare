//
//  SettingVC.m
//  DDSample
//
//  Created by 黄振 on 2020/4/17.
//  Copyright © 2020 KingYellow. All rights reserved.
//

#import "SettingVC.h"
#import "TOTAMulltiCollectionView.h"
#import "TOTAMulltiCCell.h"

@interface SettingVC ()<UICollectionViewDelegate,UICollectionViewDataSource>

@end

@implementation SettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = QZHKIT_COLOR_LEADBACK;
    TOTAMulltiCollectionView *totaview = [TOTAMulltiCollectionView  creatWithFrame:CGRectMake(0, QZHNAVI_HEIGHT, QZHScreenWidth, QZHScreenHeight - QZHNAVI_HEIGHT)];
    [totaview registerClass:[TOTAMulltiCCell class] forCellWithReuseIdentifier:QZHIdentifierImage];

    totaview.delegate = self;
    totaview.dataSource = self;
    [self.view addSubview:totaview];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    TOTAMulltiCCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:QZHIdentifierImage forIndexPath:indexPath];
    cell.backgroundColor = QZHKIT_COLOR_LEADBACK;
    cell.section = indexPath.row;
    return cell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 3;
}
@end
