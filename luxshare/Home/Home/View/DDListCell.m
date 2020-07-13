//
//  DDListCell.m
//  DDSample
//
//  Created by 黄振 on 2020/3/25.
//  Copyright © 2020 KingYellow. All rights reserved.
//

#import "DDListCell.h"

@implementation DDListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {

        [self makeSubViews];
    }
    return self;
}

- (void)makeSubViews {
    [self.contentView addSubview:self.IMGView];
    [self.contentView addSubview:self.priceLab];
    [self.contentView addSubview:self.weightLab];
    [self.contentView addSubview:self.timeLab];
     
     [self.IMGView mas_makeConstraints:^(MASConstraintMaker *make) {
         make.left.top.mas_equalTo(QZHKIT_MARGIN_LEFT_LISTCELL_IMAGE);
         make.width.height.mas_equalTo(QZHSIZE_HEIGHT_LISTCELL_IMAGE);

     }];
    [self.priceLab mas_makeConstraints:^(MASConstraintMaker *make) {
         make.top.mas_equalTo(QZHKIT_MARGIN_TOP_LISTCELL_TEXT);
        make.left.mas_equalTo(self.IMGView.mas_right).offset(QZHKIT_MARGIN_H_LISTCELL_IMAGE_AND_TEXT);
     }];
    [self.weightLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.IMGView.mas_right).offset(QZHKIT_MARGIN_H_LISTCELL_IMAGE_AND_TEXT);
        make.top.mas_equalTo(self.priceLab.mas_bottom).offset(QZHKIT_MARGIN_BOTTOM_LISTCELL_TEXT);
    }];
    [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-QZHKIT_MARGIN_RIGHT_LISTCELL_TEXT);
        make.bottom.mas_equalTo(self.weightLab.mas_bottom);
    }];
    
}
#pragma mark -lazy
-(UILabel *)priceLab{
    if (!_priceLab) {
        _priceLab = [[UILabel alloc] init];
        _priceLab.font = QZHKIT_FONT_LISTCELL_MAIN_TITLE;
        _priceLab.textColor = QZHKIT_Color_BLACK_87;
    }
    return  _priceLab;
}
-(UILabel *)weightLab{
    if (!_weightLab) {
        _weightLab = [[UILabel alloc] init];
        _weightLab.font = QZHKIT_FONT_LISTCELL_SUB_TITLE;
        _weightLab.textColor = QZHKIT_Color_BLACK_54;

    }
    return  _weightLab;
}
-(UILabel *)timeLab{
    if (!_timeLab) {
        _timeLab = [[UILabel alloc] init];
        _timeLab.font = QZHKIT_FONT_LISTCELL_TIME_TITLE;
        _timeLab.textColor = QZHKIT_Color_BLACK_26;
        _timeLab.text = @"2020.3.30";
    }
    return  _timeLab;
}
-(UIImageView *)IMGView{
    if (!_IMGView) {
        _IMGView = [[UIImageView alloc] init];
        _IMGView.contentMode = UIViewContentModeScaleToFill;
        _IMGView.image = [UIImage imageNamed:@"banner2.jpeg"];
    }
    return _IMGView;
}

-(void)setDic:(NSDictionary *)dic{
    
    
    self.priceLab.text = [NSString stringWithFormat:@"价格 %@ 元",dic[@"price"]];
    self.weightLab.text = [NSString stringWithFormat:@"重量 %@ Kg",dic[@"weight"]];

}
- (void)setFrame:(CGRect)frame {

    frame.size.height -= QZHSIZE_HEIGHT_LISTCELL_SEPARATOR;
    [super setFrame:frame];
}
@end
