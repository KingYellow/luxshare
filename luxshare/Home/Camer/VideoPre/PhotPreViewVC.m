//
//  PhotPreViewVC.m
//  luxshare
//
//  Created by 黄振 on 2020/7/15.
//  Copyright © 2020 KingYellow. All rights reserved.
//

#import "PhotPreViewVC.h"

@interface PhotPreViewVC ()
@property (assign, nonatomic)BOOL isHor;
@property (strong, nonatomic)UIImageView *photoIMG;
@property (strong, nonatomic)UIButton *horizontalBtn;
@end

@implementation PhotPreViewVC

- (void)viewDidLoad {
    [super viewDidLoad];
   [self initConfig];
    [self layOutImage];
    if(self.model){
        [self.model requestImageWithOptions:nil targetSize:CGSizeMake(QZHScreenWidth, QZHScreenWidth *1080/1920) resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            self.photoIMG.image = result;
        }];
    }else{
        [self.photoIMG exp_loadImageUrlString:self.imgUrl placeholder:QZHICON_PLACEHOLDER];
    }

     
}
- (void)initConfig{
    self.view.backgroundColor = QZHKIT_COLOR_LEADBACK;
    self.navigationItem.title = @"相册图片";
    [self exp_navigationBarTextWithColor:QZHKIT_COLOR_NAVIBAR_TITLE font:QZHKIT_FONT_TABBAR_TITLE];
    [self exp_navigationBarColor:QZHKIT_COLOR_NAVIBAR_BACK hiddenShadow:NO];

}
- (void)layOutImage{
    [self.view addSubview:self.photoIMG];
    [self.photoIMG addSubview:self.horizontalBtn];
    self.horizontalBtn.backgroundColor = QZHKIT_Color_BLACK_54;
    QZHViewRadius(self.horizontalBtn, 15)
    self.photoIMG.frame = CGRectMake(0, 200 *QZHScaleWidth, QZHScreenWidth, QZHScreenWidth * 1080/1920);

    [self.horizontalBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.bottom.mas_equalTo(-15);
        make.width.height.mas_equalTo(30);
    }];
    
}
-(UIImageView *)photoIMG{
    if (!_photoIMG) {
        _photoIMG = [[UIImageView alloc] init];
        _photoIMG.userInteractionEnabled = YES;
    }
    return _photoIMG;
}
-(UIButton *)horizontalBtn{
    if (!_horizontalBtn) {
        _horizontalBtn = [[UIButton alloc] init];
        [_horizontalBtn setImage:QZHLoadIcon(@"ic_full_screen") forState:UIControlStateNormal];
        [_horizontalBtn setImage:QZHLoadIcon(@"ic_part_screen") forState:UIControlStateSelected];
        _horizontalBtn.tag = 3;
        [_horizontalBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _horizontalBtn;
}

- (void)buttonAction:(UIButton *)sender{
    sender.selected = !sender.selected;
    if (sender.selected) {
        [self.photoIMG removeFromSuperview];
        self.photoIMG.transform = CGAffineTransformMakeRotation(90*M_PI/180);
         CGAffineTransform transform = self.photoIMG.transform;
         transform = CGAffineTransformScale(transform, 1,1);
         self.photoIMG.transform = transform;
        self.photoIMG.frame = CGRectMake(0, 0, QZHScreenWidth, QZHScreenHeight);

        [self.navigationController.view addSubview:self.photoIMG];
      
    }else{
        
        [self.photoIMG removeFromSuperview];
        self.photoIMG.transform = CGAffineTransformMakeRotation(0*M_PI/90);
         CGAffineTransform transform = self.photoIMG.transform;
         transform = CGAffineTransformScale(transform, 1,1);
         self.photoIMG.transform = transform;
        [self.photoIMG removeFromSuperview];
        [self.view addSubview:self.photoIMG];
        self.photoIMG.center = self.view.center;
        self.photoIMG.frame = CGRectMake(0, 200 *QZHScaleWidth, QZHScreenWidth, QZHScreenWidth * 1080/1920);
    }
    
}
@end
