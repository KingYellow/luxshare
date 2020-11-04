//
//  DoorbellVC.m
//  luxshare
//
//  Created by 黄振 on 2020/10/20.
//  Copyright © 2020 KingYellow. All rights reserved.
//

#import "DoorbellVC.h"
#import "CameraOnLiveVC.h"

@interface DoorbellVC ()
@property (strong, nonatomic)UIImageView *shotIMG;
@property (strong, nonatomic)UILabel *nameLab;
@property (strong, nonatomic)UILabel *tipLab;
@property (strong, nonatomic)UIButton *refuseBtn;
@property (strong, nonatomic)UIButton *answerBtn;
@end

@implementation DoorbellVC
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self exp_navigationBarTrans];

}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self exp_navigationBarTextWithColor:QZHKIT_COLOR_NAVIBAR_TITLE font:QZHKIT_FONT_TABBAR_TITLE];
    [self exp_navigationBarColor:QZHKIT_COLOR_NAVIBAR_BACK hiddenShadow:NO];
}
- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = QZHColorBlack;
    [self UICongfigs];
    TuyaSmartDevice *device = [[TuyaSmartDevice alloc] initWithDeviceId:self.eventInfo[@"devId"]];
    NSString *s = device.deviceModel.dps[@"154"];
    NSString *str;
    if (s) {
        str = [self stringFromHexString:s];
    }
    if (str) {
            [self.shotIMG exp_loadImageUrlString:str placeholder:QZHICON_BACK_ITEM];
    }
  
}
// 十六进制转换为普通字符串的。
- (NSString *)stringFromHexString:(NSString *)hexString {  //
     
    char *myBuffer = (char *)malloc((int)[hexString length] / 2 + 1);
    bzero(myBuffer, [hexString length] / 2 + 1);
    for (int i = 0; i < [hexString length] - 1; i += 2) {
        unsigned int anInt;
        NSString * hexCharStr = [hexString substringWithRange:NSMakeRange(i, 2)];
        NSScanner * scanner = [[NSScanner alloc] initWithString:hexCharStr];
        [scanner scanHexInt:&anInt];
        myBuffer[i / 2] = (char)anInt;
    }
    NSString *unicodeString = [NSString stringWithCString:myBuffer encoding:4];
    return unicodeString;
     
}

- (void) UICongfigs{
    [self.view addSubview:self.shotIMG];
    [self.view addSubview:self.nameLab];
    [self.view addSubview:self.tipLab];
    [self.view addSubview:self.refuseBtn];
    [self.view addSubview:self.answerBtn];
    
    [self.shotIMG mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(QZHHeightTop + 30);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo((QZHScreenWidth - 40) * 1080/1920);

    }];
    [self.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.shotIMG.mas_bottom).offset(20);

        make.height.mas_equalTo(30);
        make.left.right.mas_equalTo(0);
    }];
    [self.tipLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.nameLab.mas_bottom);
        make.height.mas_equalTo(20);
        make.left.right.mas_equalTo(0);
    }];
    
    [self.refuseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-QZHHeightBottom - 30);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(80);
        make.left.mas_equalTo(20);

    }];
    [self.answerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-QZHHeightBottom - 30);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(80);
        make.right.mas_equalTo(-20);

    }];
}

#pragma mark -- lazy

- (UIImageView *)shotIMG{
    if (!_shotIMG) {
        _shotIMG = [[UIImageView alloc] init];
        _shotIMG.image = QZHLoadIcon(@"sub");
    }
    return _shotIMG;
}
- (UILabel *)nameLab{
    if (!_nameLab) {
        _nameLab = [[UILabel alloc] init];
        _nameLab.textAlignment = NSTextAlignmentCenter;
        _nameLab.textColor = QZH_KIT_Color_WHITE_70;
        _nameLab.font = QZHKIT_FONT_LISTCELL_SUB_TITLE;
        _nameLab.text = @"doorbell";
    }
    return _nameLab;
}
- (UILabel *)tipLab{
    if (!_tipLab) {
        _tipLab = [[UILabel alloc] init];
        _tipLab.textAlignment = NSTextAlignmentCenter;
        _tipLab.textColor = QZH_KIT_Color_WHITE_70;
        _tipLab.font = QZHKIT_FONT_LISTCELL_SUB_TITLE;
        _tipLab.text = QZHLoaclString(@"waitingAnswerDoorbell");

    }
    return _tipLab;
}
- (UIButton *)refuseBtn{
    if (!_refuseBtn) {
        _refuseBtn = [[UIButton alloc] init];
        [_refuseBtn setImage:QZHLoadIcon(@"ic_doc_unread") forState:UIControlStateNormal];
        [_refuseBtn setTitle:QZHLoaclString(@"doorbellRefuse") forState:UIControlStateNormal];
        [_refuseBtn jk_setImagePosition:LXMImagePositionTop spacing:5.0];
        [_refuseBtn addTarget:self action:@selector(refuseToAnswerTheCall) forControlEvents:UIControlEventTouchUpInside];
    }
    return _refuseBtn;;
}

- (UIButton *)answerBtn{
    if (!_answerBtn) {
        _answerBtn = [[UIButton alloc] init];
        [_answerBtn setImage:QZHLoadIcon(@"ic_doc_already_read") forState:UIControlStateNormal];
        [_answerBtn setTitle:QZHLoaclString(@"doorbellAnswer") forState:UIControlStateNormal];
        [_answerBtn jk_setImagePosition:LXMImagePositionTop spacing:5.0];
        [_answerBtn addTarget:self action:@selector(answerTheCall) forControlEvents:UIControlEventTouchUpInside];

    }
    return _answerBtn;
}
#pragma mark -- action
- (void)refuseToAnswerTheCall{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
- (void)answerTheCall{

    CameraOnLiveVC *vc = [[CameraOnLiveVC alloc] init];
    TuyaSmartDevice *device = [[TuyaSmartDevice alloc] initWithDeviceId:self.eventInfo[@"devId"]];
    vc.deviceModel = device.deviceModel;
    vc.isDoorbellCall = YES;
    [self.navigationController pushViewController:vc animated:NO];
    
}
@end
