//
//  PhotosVC.m
//  luxshare
//
//  Created by 黄振 on 2020/7/11.
//  Copyright © 2020 KingYellow. All rights reserved.
//

#import "PhotosVC.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "QZHMessageCell.h"
#import "PhotosListVC.h"
#import "VideoListVC.h"

@interface PhotosVC ()<UIPageViewControllerDataSource,UIPageViewControllerDelegate>
@property (strong, nonatomic)NSArray *arrVcs;
@property (strong, nonatomic)NSArray *arrBtn;
@property (strong, nonatomic)UIView *bottomView;
@property (strong, nonatomic)UIPageViewController *pageVc;
@property (assign, nonatomic)NSInteger oldSelectIndex;
@property (assign, nonatomic)NSInteger currentIndex;
@property (strong, nonatomic)UIView *titleView;
@property (strong, nonatomic)UILabel *titleLab;

@property (strong, nonatomic)PhotosListVC *photoVC;
@property (strong, nonatomic)VideoListVC *videoVC;
@property (strong, nonatomic)UIButton *leftBtn;
@property (strong, nonatomic)UIButton *rightBtn;
@property (strong, nonatomic)UIView *topHandleView;
@property (strong, nonatomic)UILabel *topNumLab;
@property (strong, nonatomic)UIView *bottomHandleView;
@property (strong, nonatomic)NSArray *deleteArr;
@property (strong, nonatomic)UIButton *btn;
@property (strong, nonatomic)UIScrollView *scrollView;
@property (assign, nonatomic)BOOL isEditing;
@end


@implementation PhotosVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initConfig];
    self.isEditing = NO;
}
- (void)initConfig{
    self.view.backgroundColor = QZHKIT_COLOR_LEADBACK;
    self.navigationItem.title = @"相册管理";
    [self exp_navigationBarTextWithColor:QZHKIT_COLOR_NAVIBAR_TITLE font:QZHKIT_FONT_TABBAR_TITLE];
    [self exp_navigationBarColor:QZHKIT_COLOR_NAVIBAR_BACK hiddenShadow:NO];
    [self creatSubViews];
    self.currentIndex = 0;
    [self UIConfig];
}
- (void)UIConfig{
    [self loadVcs];
    
    [self.view addSubview:self.topHandleView];
    [self.view addSubview:self.bottomHandleView];
    [self.topHandleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
        make.height.mas_equalTo(60);
    }];
    [self.bottomHandleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(0);
        make.height.mas_equalTo(60);
    }];
}
//添加控制器
-(void)loadVcs{
QZHWS(weakSelf)
    self.photoVC = [[PhotosListVC alloc] init];
    self.photoVC.selecctResultBlock = ^(NSArray * _Nonnull selectArr, BOOL isall) {
        if (selectArr.count > 0) {
            weakSelf.topHandleView.hidden = NO;
            weakSelf.bottomHandleView.hidden = NO;
            weakSelf.scrollView.scrollEnabled = NO;
            weakSelf.isEditing = YES;

            weakSelf.deleteArr = selectArr;
            weakSelf.topNumLab.text = [NSString stringWithFormat:@"%lu个已选定",(unsigned long)selectArr.count];
            weakSelf.btn.selected = isall;
            if (weakSelf.currentIndex == 1) {
              
            }
        }else{
            weakSelf.topHandleView.hidden = YES;
            weakSelf.bottomHandleView.hidden = YES;
            weakSelf.scrollView.scrollEnabled = YES;
            weakSelf.isEditing = NO;
        }

    };


    self.videoVC = [[VideoListVC alloc] init];
    
    self.videoVC.selecctResultBlock = ^(NSArray * _Nonnull selectArr, BOOL isall) {
        if (selectArr.count > 0) {
            weakSelf.topHandleView.hidden = NO;
            weakSelf.bottomHandleView.hidden = NO;
            weakSelf.scrollView.scrollEnabled = NO;
            weakSelf.isEditing = YES;
            weakSelf.deleteArr = selectArr;
            weakSelf.topNumLab.text = [NSString stringWithFormat:@"%ld个已选定",selectArr.count];
            weakSelf.btn.selected = isall;

            if (weakSelf.currentIndex == 1) {
              
            }
        }else{
            weakSelf.topHandleView.hidden = YES;
            weakSelf.bottomHandleView.hidden = YES;
            weakSelf.scrollView.scrollEnabled = YES;
            weakSelf.isEditing = NO;
        }

    };

    self.arrVcs = [NSArray arrayWithObjects:self.videoVC,self.photoVC ,  nil];
    
    self.arrBtn = [NSArray arrayWithObjects:self.leftBtn, self.rightBtn, nil];
    
    self.pageVc = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];

    [self.pageVc setViewControllers:@[self.arrVcs[0]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    self.pageVc.delegate = self;
    self.pageVc.dataSource = self;
    
    self.pageVc.view.frame = CGRectMake(0, 60 * QZHScaleWidth, QZHScreenWidth, QZHScreenHeight - 60 * QZHScaleWidth);
    [self addChildViewController:self.pageVc];
    [self.pageVc didMoveToParentViewController:self];
    [self.view addSubview:self.pageVc.view];
    
        [self.pageVc.view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[UIScrollView class]]) self.scrollView = (UIScrollView *)obj;
    
        }];
        if(self.scrollView)
        {
        //新添加的手势，起手势锁的作用
            self.scrollView.scrollEnabled = YES;

        }
}
//点击按钮事件
#pragma mark ----按钮点击事件
-(void)btnAction:(UIButton *)sender{
    sender.selected = YES;
    self.currentIndex = sender.tag - 888;
    if (self.oldSelectIndex == self.currentIndex) {
        
    }else{
        UIViewController *vc = self.arrVcs[self.currentIndex];
        if (self.oldSelectIndex > self.currentIndex) {
            [self.pageVc setViewControllers:@[vc] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:^(BOOL finished) {
                
            }];
        }else{
            [self.pageVc setViewControllers:@[vc] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:^(BOOL finished) {
                
            }];
        }

        self.oldSelectIndex = self.currentIndex;
        [UIView animateWithDuration:0.25 animations:^{
            self.bottomView.frame = CGRectMake(self.currentIndex * QZHScreenWidth/2, 57* QZHScaleWidth, QZHScreenWidth/2, 3* QZHScaleWidth);
        }];
    }
}
//DataSource方法
#pragma mark 返回上一个ViewController对象
-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController{
    
    NSInteger nowIndex = [self.arrVcs indexOfObject:viewController];
    if (nowIndex == 0) {
        return nil;
    }else{
        return self.arrVcs[nowIndex - 1];
    }
}

#pragma mark 返回下一个ViewController对象
-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController{
    NSInteger nowIndex = [self.arrVcs indexOfObject:viewController];
    if (nowIndex == self.arrVcs.count - 1) {
        return nil;
    }else{
        return self.arrVcs[nowIndex + 1];
    }
}
//代理方法
-(void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed{
    //previousViewControllers:上一个控制器
    if (!completed) {
        return;
    }
    NSLog(@"previousViewControllers == %@", previousViewControllers.lastObject);
    UIViewController *vc = previousViewControllers.firstObject;
    NSInteger previousIndex = [self.arrVcs indexOfObject:vc];
    if (previousIndex == self.currentIndex) {
        
    }else{
        
        self.oldSelectIndex = self.currentIndex;
        [UIView animateWithDuration:0.25 animations:^{
            self.bottomView.frame = CGRectMake(self.currentIndex * QZHScreenWidth/2, 57* QZHScaleWidth, QZHScreenWidth/2, 3* QZHScaleWidth);
        }];

    }
}

-(void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers{
    //pendingViewControllers:下一个控制器
    NSLog(@"pendingViewControllers === %@", pendingViewControllers);
    self.currentIndex = [self.arrVcs indexOfObject:pendingViewControllers.firstObject];
}
-(UIView *)titleView{
    if (!_titleView) {
        _titleView = [[UIView alloc] init];
        [_titleView addSubview:self.bottomView];
        self.bottomView.frame = CGRectMake(0, 57 * QZHScaleWidth, QZHScreenWidth/2, 3*QZHScaleWidth);
    }
    return _titleView;
}
-(UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = QZHKIT_COLOR_SKIN;
    }
    return _bottomView;
}
- (void)creatSubViews {
    [self.view addSubview:self.titleView];
    [self.titleView addSubview:self.leftBtn];
    [self.titleView addSubview:self.rightBtn];
    
    [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
        make.height.mas_equalTo(60 * QZHScaleWidth);
    }];
    [self.leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(QZHScreenWidth/2);
        make.height.mas_equalTo(60 * QZHScaleWidth);
        make.left.top.mas_equalTo(0);
    }];

    [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(QZHScreenWidth/2);
        make.height.mas_equalTo(60 * QZHScaleWidth);
        make.right.top.mas_equalTo(0);

    }];
    
}
#pragma mark -lazy

-(UIButton *)leftBtn{
    if (!_leftBtn) {
        _leftBtn = [[UIButton alloc] init];
        [_leftBtn setTitle:@"视频" forState:UIControlStateNormal];
        _leftBtn.titleLabel.font = QZHKIT_FONT_LISTCELL_BIG_TITLE;
        [_leftBtn setTitleColor:QZHKIT_Color_BLACK_87 forState:UIControlStateNormal];
        [_leftBtn setImage:QZHLoadIcon(@"ic_all_video") forState:UIControlStateNormal];
        _leftBtn.tag = 888;
        [_leftBtn jk_setImagePosition:0 spacing:15];
        [_leftBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftBtn;
}
-(UIButton *)rightBtn{
    if (!_rightBtn) {
        _rightBtn = [[UIButton alloc] init];
        [_rightBtn setTitle:@"图片" forState:UIControlStateNormal];
        _rightBtn.titleLabel.font = QZHKIT_FONT_LISTCELL_BIG_TITLE;
        [_rightBtn setTitleColor:QZHKIT_Color_BLACK_87 forState:UIControlStateNormal];
        [_rightBtn setImage:QZHLoadIcon(@"ic_all_photo_n") forState:UIControlStateNormal];
        [_rightBtn jk_setImagePosition:0 spacing:15];
        _rightBtn.tag = 889;
        [_rightBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];

    }
    return _rightBtn;
}

-(UIView *)topHandleView{
    if (!_topHandleView) {
        _topHandleView = [[UIView alloc] init];
        _topHandleView.backgroundColor = UIColor.whiteColor;
        _topHandleView.hidden = YES;
        [_topHandleView addSubview:self.topNumLab];
        [self.topNumLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(_topHandleView);
            make.left.mas_equalTo(15);
        }];
        
        self.btn  = [[UIButton alloc] init];
        [self.btn  setTitle:@"全部选中" forState:UIControlStateNormal];
        [self.btn  setTitle:@"取消全选" forState:UIControlStateSelected];

        self.btn.titleLabel.font = QZHKIT_FONT_LISTCELL_SUB_TITLE;
        [self.btn  setTitleColor:QZHKIT_Color_BLACK_87 forState:UIControlStateNormal];
        [self.btn  addTarget:self action:@selector(allSelectAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.topHandleView addSubview:self.btn ];
      
        [self.btn  mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(_topHandleView);
            make.right.mas_equalTo(-15);
            make.width.mas_equalTo(80);
            make.height.mas_equalTo(30);
        }];
    }
    return _topHandleView;
}
-(UIView *)bottomHandleView{
    if (!_bottomHandleView) {
        _bottomHandleView = [[UIView alloc] init];
        _bottomHandleView.backgroundColor = UIColor.whiteColor;
        _bottomHandleView.hidden = YES;
        UIButton *btn = [[UIButton alloc] init];
        [btn setTitle:@"取消" forState:UIControlStateNormal];
        btn.titleLabel.font = QZHKIT_FONT_LISTCELL_SUB_TITLE;
        [btn setTitleColor:QZHKIT_Color_BLACK_87 forState:UIControlStateNormal];
        [self.bottomHandleView addSubview:btn];
        [btn addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];

        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(_bottomHandleView);
            make.left.mas_equalTo(15);
            make.width.mas_equalTo(80);
            make.height.mas_equalTo(30);
        }];
        UIButton *deleteBtn = [[UIButton alloc] init];

         [deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
          deleteBtn.titleLabel.font = QZHKIT_FONT_LISTCELL_SUB_TITLE;
          [deleteBtn setTitleColor:QZHKIT_Color_BLACK_87 forState:UIControlStateNormal];
          [self.bottomHandleView addSubview:deleteBtn];
        [deleteBtn addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];

          [deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
              make.centerY.mas_equalTo(_bottomHandleView);
              make.right.mas_equalTo(-15);
              make.width.mas_equalTo(80);
              make.height.mas_equalTo(30);
          }];
    }
    return _bottomHandleView;
}
- (UILabel *)topNumLab{
    if (!_topNumLab) {
        _topNumLab = [[UILabel alloc] init];
        _topNumLab.textColor = QZHKIT_Color_BLACK_87;
        _topNumLab.font = QZHKIT_FONT_LISTCELL_SUB_TITLE;
    }
    return _topNumLab;
}
- (void)allSelectAction:(UIButton *)sender{
    sender.selected = !sender.selected;
    if (self.currentIndex == 1) {
        [self.photoVC selectAllVideosOrPhotos:sender.selected];
    }else{
        [self.videoVC selectAllVideosOrPhotos:sender.selected];
    }
    
}
- (void)cancelAction:(UIButton *)sender{
    self.topHandleView.hidden = YES;
    self.bottomHandleView.hidden = YES;
    self.scrollView.scrollEnabled = YES;
    self.isEditing = NO;
    if (self.currentIndex == 1) {
        [self.photoVC selectAllVideosOrPhotos:NO];
    }else{
        [self.videoVC selectAllVideosOrPhotos:NO];
    }

}
- (void)deleteAction:(UIButton *)sender{
    NSMutableArray *arr = [NSMutableArray array];
    for (HXPhotoModel * model in self.deleteArr) {
        [arr addObject:model.asset];
    }
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        [PHAssetChangeRequest deleteAssets:arr];

    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        if (success) {
           dispatch_async(dispatch_get_main_queue(), ^{
               // UI更新代码
               self.topHandleView.hidden = YES;
               self.bottomHandleView.hidden = YES;
               self.scrollView.scrollEnabled = YES;
               self.isEditing = NO;
               if (self.currentIndex == 1) {
                    [self.photoVC getphotosList];
               }else{
                   [self.videoVC getphotosList];
               }
               
            });

        }
    }];
    

}
@end
