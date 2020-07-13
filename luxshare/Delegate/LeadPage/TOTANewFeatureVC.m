//
//  TOTANewFeatureVC.m
//  DDSample
//
//  Created by 黄振 on 2020/4/3.
//  Copyright © 2020 KingYellow. All rights reserved.
//

#import "TOTANewFeatureVC.h"
#import "NewFeatureCell.h"

@interface TOTANewFeatureVC ()
@property (nonatomic, copy) NSArray *datas;
@property (nonatomic, strong) UIPageControl *pageCon;
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UIButton *enterBtn;
@end
@implementation TOTANewFeatureVC

- (instancetype)init{
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc]init];
    if (self=[super initWithCollectionViewLayout:layout]) {
        UICollectionViewFlowLayout *fl = [[UICollectionViewFlowLayout alloc]init];
        fl.itemSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
        fl.minimumLineSpacing = 0;
        fl.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        self.collectionView.collectionViewLayout = fl;
    }
    return self;

}
- (NSArray *)datas
{
    if (_datas == nil) {
        
        _datas = @[@"1",@"2",@"3"];
    }
    
    return _datas;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectionView.backgroundColor = QZHKIT_COLOR_LEADBACK;
    [self initPageControl];

    [self.collectionView registerClass:[NewFeatureCell class] forCellWithReuseIdentifier:QZHCELL_REUSE_TEXT];
    self.collectionView.pagingEnabled = YES;
    self.collectionView.bounces = NO;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
}
- (void)initPageControl{
    //添加page
    [self.view addSubview:self.pageCon];
    
    [self.pageCon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.collectionView);
        make.bottom.mas_equalTo(-QZHHeightTabbar - 160);
    }];

}
#pragma mark -- lazy
-(UIPageControl *)pageCon{
    if (!_pageCon) {
        UIPageControl *page = [[UIPageControl alloc]init];
        page.numberOfPages = self.datas.count;
        page.currentPage = 0;
        page.currentPageIndicatorTintColor = QZHKIT_COLOR_SKIN;
        page.pageIndicatorTintColor = QZH_KIT_Color_WHITE_100;
        page.jk_size = CGSizeMake(12, 12);
       _pageCon = page;
    }
    return _pageCon;
    
}

#pragma mark <UICollectionViewDataSource>


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.datas.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NewFeatureCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:QZHCELL_REUSE_TEXT forIndexPath:indexPath];
    
    NSString *iconName = self.datas[indexPath.row];

    cell.IMGView.image = [UIImage imageNamed:iconName];
    
    [cell.enterBtn addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
    
    if (indexPath.row == 2) {
        cell.enterBtn.hidden = NO;
    }else{
        cell.enterBtn.hidden = YES;
    }

    cell.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1.0];
    
    return cell;
    
}


-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{

    CGFloat offsetX = scrollView.contentOffset.x;

    NSInteger page = (offsetX + 5) /QZH_SCREEN_WIDTH;
    
    self.pageCon.currentPage = page ;
}
- (void)loginAction {

    [QZHROOT_DELEGATE setVC];

}


@end
