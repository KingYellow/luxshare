//
//  NETResultVC.m
//  luxshare
//
//  Created by 黄振 on 2020/7/9.
//  Copyright © 2020 KingYellow. All rights reserved.
//

#import "NETResultVC.h"
#import "SGQRCode.h"
#import "ProgressVC.h"

@interface NETResultVC ()
@property (strong, nonatomic)UILabel *titleLab;
@property (strong, nonatomic)UIImageView *indicatorIMG;
@property (strong, nonatomic)UIButton *submitBtn;

@end

@implementation NETResultVC


- (void)viewDidLoad {
    [super viewDidLoad];

    [self initConfig];
    
}
- (void)initConfig{
    self.view.backgroundColor = QZHKIT_COLOR_LEADBACK;
    self.navigationItem.title = QZHLoaclString(@"device_addNewDevice");
    [self exp_navigationBarTextWithColor:QZHKIT_COLOR_NAVIBAR_TITLE font:QZHKIT_FONT_TABBAR_TITLE];
    [self exp_navigationBarColor:QZHKIT_COLOR_NAVIBAR_BACK hiddenShadow:NO];
    [self UIConfig];
    
    if (!self.isSuccess) {
        self.titleLab.text = QZHLoaclString(@"device_addFailer");
        self.indicatorIMG.image = QZHLoadIcon(@"ty_adddevice_ok");
    }

}
- (void)UIConfig{
    [self.view addSubview:self.submitBtn];
    [self.view addSubview:self.titleLab];
    [self.view addSubview:self.indicatorIMG];
    self.indicatorIMG.image = QZHLoadIcon(@"");
    
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.view);
    }];

    
    [self.indicatorIMG mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.titleLab.mas_top).offset(-20);
        make.width.height.mas_equalTo(60);
    }];

  
    [self.submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);

        make.height.mas_equalTo(50); make.bottom.mas_equalTo(self.view).offset(-QZHHeightBottom -30);
    }];
    QZHViewRadius(self.submitBtn,25);
    
}

-(UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.font = QZHKIT_FONT_LISTCELL_BIG_TITLE;
        _titleLab.textColor = QZHKIT_Color_BLACK_87;
        _titleLab.textAlignment = NSTextAlignmentCenter;
        _titleLab.text = QZHLoaclString(@"device_addSuccess");

    }
    return _titleLab;
}


-(UIButton *)submitBtn{
    if (!_submitBtn) {
        _submitBtn = [[UIButton alloc] init];
        [_submitBtn setTitle:QZHLoaclString(@"finish") forState:UIControlStateNormal];
        [_submitBtn addTarget:self action:@selector(submitAction:) forControlEvents:UIControlEventTouchUpInside];
        [_submitBtn exp_buttonState:QZHButtonStateEnable];
    }
    return _submitBtn;
}
- (UIImageView *)indicatorIMG{
    if (!_indicatorIMG) {
        _indicatorIMG = [[UIImageView alloc] init];
    }
    return _indicatorIMG;
}

#pragma mark -- wifi

- (void)submitAction:(UIButton *)sender{
//    HomeVC *home = (HomeVC *)self.navigationController.childViewControllers[0];
    [self.navigationController popToRootViewControllerAnimated:YES];
}



@end
