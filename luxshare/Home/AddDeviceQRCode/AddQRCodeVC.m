//
//  AddQRCodeVC.m
//  luxshare
//
//  Created by 黄振 on 2020/7/4.
//  Copyright © 2020 KingYellow. All rights reserved.
//

#import "AddQRCodeVC.h"
#import "SetWIFIVC.h"
#import "UIImageView+Gif.h"

@interface AddQRCodeVC ()
@property (strong, nonatomic)UIImageView *indicatorIMG;
@property (strong, nonatomic)UILabel *titleLab;
@property (strong, nonatomic)UILabel *subLab;
@property (strong, nonatomic)UIButton *selectBtn;
@property (strong, nonatomic)UILabel *tipLab;
@property (strong, nonatomic)UIButton *submitBtn;
@end

@implementation AddQRCodeVC

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
    [self.indicatorIMG startPlayGifWithImages:@[@"ty_adddevice_lighting",@"ty_adddevice_light"]];

}
- (void)UIConfig{
    [self.view addSubview:self.submitBtn];
    [self.view addSubview:self.selectBtn];
    [self.view addSubview:self.tipLab];
    [self.view addSubview:self.indicatorIMG];
    [self.view addSubview:self.titleLab];
    [self.view addSubview:self.subLab];
    
    [self.indicatorIMG mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(20);
        make.width.height.mas_equalTo(220);
    }];
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(self.indicatorIMG.mas_bottom).offset(10);
    }];
    [self.subLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(self.titleLab.mas_bottom).offset(10);
        
            make.left.mas_equalTo(20);
            make.right.mas_equalTo(-20);
    }];
  
    [self.submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);

        make.height.mas_equalTo(50); make.bottom.mas_equalTo(self.view).offset(-QZHHeightBottom -30);
    }];
    
    [self.selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30);
        make.bottom.mas_equalTo(self.submitBtn.mas_top).offset(-40);
        make.width.height.mas_equalTo(30);
    }];
    [self.tipLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.selectBtn.mas_right).offset(10);
        make.centerY.mas_equalTo(self.selectBtn);
    }];
    QZHViewRadius( self.indicatorIMG,110);
    QZHViewRadius(self.submitBtn,25);
    
}
- (UIImageView *)indicatorIMG{
    if (!_indicatorIMG) {
        _indicatorIMG = [[UIImageView alloc] init];
    }
    return _indicatorIMG;
}
-(UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.font = QZHKIT_FONT_LISTCELL_MAIN_TITLE;
        _titleLab.textColor = QZHKIT_Color_BLACK_87;
        _titleLab.textAlignment = NSTextAlignmentCenter;
        _titleLab.text = QZHLoaclString(@"device_resetDevice");

    }
    return _titleLab;
}

-(UILabel *)subLab{
    if (!_subLab) {
        _subLab = [[UILabel alloc] init];
        _subLab.font = QZHKIT_FONT_LISTCELL_SUB_TITLE;
        _subLab.textColor = QZHKIT_Color_BLACK_87;
        _subLab.textAlignment = NSTextAlignmentCenter;
        _subLab.numberOfLines = 0;
        _subLab.text = QZHLoaclString(@"device_resetTip");
    }
    return _subLab;
}
-(UIButton *)selectBtn{
    if (!_selectBtn) {
        _selectBtn = [[UIButton alloc] init];
        [_selectBtn setImage:QZHLoadIcon(@"pay_normal") forState:UIControlStateNormal];
        [_selectBtn setImage:QZHLoadIcon(@"pay_selected") forState:UIControlStateSelected];
        [_selectBtn addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectBtn;
}

-(UILabel *)tipLab{
    if (!_tipLab) {
        _tipLab = [[UILabel alloc] init];
        _tipLab.font = QZHKIT_FONT_LISTCELL_SUB_TITLE;
        _tipLab.textColor = QZHKIT_Color_BLACK_87;
        _tipLab.numberOfLines = 2;
        _tipLab.text = [NSString stringWithFormat:@"%@%@%@",QZHLoaclString(@"device_doneTip1"),@"\n",QZHLoaclString(@"device_doneTip2")];
    }
    return _tipLab;
}
-(UIButton *)submitBtn{
    if (!_submitBtn) {
        _submitBtn = [[UIButton alloc] init];
        [_submitBtn setTitle:QZHLoaclString(@"nextstep") forState:UIControlStateNormal];
        [_submitBtn addTarget:self action:@selector(submitAction:) forControlEvents:UIControlEventTouchUpInside];
        [_submitBtn exp_buttonState:QZHButtonStateDisEnable];
    }
    return _submitBtn;
}
- (void)selectAction:(UIButton *)sender{
    sender.selected = !sender.selected;
    if (sender.selected) {
        [self.submitBtn exp_buttonState:QZHButtonStateEnable];
    }else{
        [self.submitBtn exp_buttonState:QZHButtonStateDisEnable];
    }
}
- (void)submitAction:(UIButton *)sender{
    SetWIFIVC *vc = [[SetWIFIVC alloc] init];
    vc.homemodel = self.homemodel;
    vc.isQRCode = YES;
    [self.navigationController pushViewController:vc animated:YES];
}


@end
