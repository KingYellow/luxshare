//
//  CountrySelectView.m
//  luxshare
//
//  Created by 黄振 on 2020/6/26.
//  Copyright © 2020 KingYellow. All rights reserved.
//

#import "CountrySelectView.h"

@implementation CountrySelectView
- (instancetype)init{
    if (self = [super init]) {
        self.backgroundColor = QZH_KIT_Color_WHITE_100;
        [self creatSubViews];
    }
    return self;
}

+ (CountrySelectView *)creatSelectView{
    
   CountrySelectView *view  = [[CountrySelectView alloc] init];
    return view;
}

- (void)creatSubViews {
    [self addSubview:self.nameLab];
    [self addSubview:self.describeLab];
    UIImageView *img = [[UIImageView alloc] init];
    img.image = [UIImage imageNamed:@""];
    [self addSubview:img];
     
    [self.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.left.mas_equalTo(20);
     }];
    [img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(30);
        make.right.mas_equalTo(-20);
     }];
    [self.describeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(img.mas_left).offset(-5);
        make.centerY.mas_equalTo(self.nameLab);
    }];

    
}
#pragma mark -lazy
-(UILabel *)nameLab{
    if (!_nameLab) {
        _nameLab = [[UILabel alloc] init];
        _nameLab.font = QZHKIT_FONT_LISTCELL_MAIN_TITLE;
        _nameLab.textColor = QZHKIT_Color_BLACK_87;
        _nameLab.text = QZHLoaclString(@"member_country");
    }
    return  _nameLab;
}
-(UILabel *)describeLab{
    if (!_describeLab) {
        _describeLab = [[UILabel alloc] init];
        _describeLab.font = QZHKIT_FONT_LISTCELL_SUB_TITLE;
        _describeLab.textColor = QZHKIT_Color_BLACK_87;
        _describeLab.text = [QZHCommons languageOfTheDeviceSystem] == LanguageChinese?@"中国 +86":@"China +86";
        _describeLab.textAlignment = NSTextAlignmentRight;
    }
    return  _describeLab;
}


@end
