//
//  QRCodeVC.m
//  luxshare
//
//  Created by 黄振 on 2020/7/6.
//  Copyright © 2020 KingYellow. All rights reserved.
//

#import "QRCodeVC.h"
#import "SGQRCode.h"
#import "ProgressVC.h"

@interface QRCodeVC ()<TuyaSmartActivatorDelegate>
@property (strong, nonatomic)UILabel *titleLab;
@property (strong, nonatomic)UILabel *subLab;
@property (strong, nonatomic)UIImageView *indicatorIMG;
@property (strong, nonatomic)UIButton *submitBtn;

@end

@implementation QRCodeVC


- (void)viewDidLoad {
    [super viewDidLoad];

    [self initConfig];

    
}
- (void)initConfig{
    self.view.backgroundColor = QZHColorWhite;
    self.navigationItem.title = QZHLoaclString(@"device_addNewDevice");
    [self exp_navigationBarTextWithColor:QZHKIT_COLOR_NAVIBAR_TITLE font:QZHKIT_FONT_TABBAR_TITLE];
    [self exp_navigationBarColor:QZHKIT_COLOR_NAVIBAR_BACK hiddenShadow:NO];
    [self UIConfig];

}
- (void)UIConfig{
    [self.view addSubview:self.submitBtn];
    [self.view addSubview:self.titleLab];
    [self.view addSubview:self.subLab];
    [self.view addSubview:self.indicatorIMG];

    self.indicatorIMG.image = [self generateQRCodeWithData:self.codeStr size:QZHScreenWidth - 60];
    
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(20);
    }];
    [self.subLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30);
        make.right.mas_equalTo(-30);
        make.top.mas_equalTo(self.titleLab.mas_bottom).offset(10);
    }];
    
    [self.indicatorIMG mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(self.subLab.mas_bottom).offset(20);
        make.width.height.mas_equalTo(QZHScreenWidth - 60);
    }];

    [self.submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);

        make.height.mas_equalTo(50);
        make.bottom.mas_equalTo(self.view).offset(-QZHHeightBottom -30);
    }];
    QZHViewRadius(self.submitBtn,25);
    [self.submitBtn exp_buttonState:QZHButtonStateEnable];

}
#pragma mark -- 生成二维码
- (UIImage *)generateQRCodeWithData:(NSString *)data size:(CGFloat)size {
    return [self generateQRCodeWithData:data size:size color:[UIColor blackColor] backgroundColor:[UIColor whiteColor]];
}
/**
 *  生成二维码
 *
 *  @param data     二维码数据
 *  @param size     二维码大小
 *  @param color    二维码颜色
 *  @param backgroundColor    二维码背景颜色
 */
- (UIImage *)generateQRCodeWithData:(NSString *)data size:(CGFloat)size color:(UIColor *)color backgroundColor:(UIColor *)backgroundColor {
    NSData *string_data = [data dataUsingEncoding:NSUTF8StringEncoding];
    // 1、二维码滤镜
    CIFilter *fileter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [fileter setValue:string_data forKey:@"inputMessage"];
    [fileter setValue:@"L" forKey:@"inputCorrectionLevel"];
    CIImage *ciImage = fileter.outputImage;
    // 2、颜色滤镜
//    CIFilter *color_filter = [CIFilter filterWithName:@"CIFalseColor"];
//    [color_filter setValue:ciImage forKey:@"inputImage"];
//    [color_filter setValue:[CIColor colorWithCGColor:color.CGColor] forKey:@"inputColor0"];
//    [color_filter setValue:[CIColor colorWithCGColor:backgroundColor.CGColor] forKey:@"inputColor1"];
    // 3、生成处理
    CIImage *outImage = fileter.outputImage;
    CGFloat scale = size / ciImage.extent.size.width;
    outImage = [outImage imageByApplyingTransform:CGAffineTransformMakeScale(scale, scale)];
    return [UIImage imageWithCIImage:outImage];
}

- (UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.font = QZHKIT_FONT_LISTCELL_BIG_TITLE;
        _titleLab.textColor = QZHKIT_Color_BLACK_87;
        _titleLab.textAlignment = NSTextAlignmentCenter;
        _titleLab.text = QZHLoaclString(@"qrcode_title");

    }
    return _titleLab;
}

- (UILabel *)subLab{
    if (!_subLab) {
        _subLab = [[UILabel alloc] init];
        _subLab.font = QZHKIT_FONT_LISTCELL_SUB_TITLE;
        _subLab.textColor = QZHKIT_Color_BLACK_87;
        _subLab.textAlignment = NSTextAlignmentCenter;
        _subLab.numberOfLines = 0;
        _subLab.text = QZHLoaclString(@"qrcode_subtitle");
    }
    return _subLab;
}

- (UIButton *)submitBtn{
    if (!_submitBtn) {
        _submitBtn = [[UIButton alloc] init];
        [_submitBtn setTitle:QZHLoaclString(@"qrcode_submit") forState:UIControlStateNormal];
        [_submitBtn addTarget:self action:@selector(submitAction:) forControlEvents:UIControlEventTouchUpInside];
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
//    [[TuyaSmartActivator sharedInstance] startConfigWiFi:TYActivatorModeQRCode ssid:self.ssid password:self.pwd token:self.token timeout:100];
//    [self.activator startConfigWiFi:TYActivatorModeQRCode ssid:self.wifi password:self.pw token:self.token timeout:100];

    ProgressVC *vc = [[ProgressVC alloc] init];
    vc.wifi = self.wifi;
    vc.pw = self.pw;
    vc.token = self.token;
    vc.actModel = TYActivatorModeQRCode;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)activator:(TuyaSmartActivator *)activator didReceiveDevice:(TuyaSmartDeviceModel *)deviceModel error:(NSError *)error
{

}

@end
