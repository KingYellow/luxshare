//
//  PerInfoPicCell.m
//  DDSample
//
//  Created by 黄振 on 2020/4/2.
//  Copyright © 2020 KingYellow. All rights reserved.
//

#import "PerInfoPicCell.h"

@implementation PerInfoPicCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = QZH_KIT_Color_WHITE_100;

        [self creatSubViews];
    }
    return self;
}

- (void)creatSubViews {
    [self.contentView addSubview:self.IMGView];
    [self.contentView addSubview:self.nameLab];

    [self.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView);
        make.left.mas_equalTo(QZHKIT_MARGIN_LEFT_LISTCELL_TEXT);

      }];
    [self.IMGView mas_makeConstraints:^(MASConstraintMaker *make) {
         make.right.mas_equalTo(-QZHKIT_MARGIN_RIGHT_LISTCELL_IMAGE);
        make.height.width.mas_equalTo(60);
         make.centerY.mas_equalTo(self.nameLab);
     }];
   
}
#pragma mark -lazy
-(UILabel *)nameLab{
    if (!_nameLab) {
        _nameLab = [[UILabel alloc] init];
        _nameLab.font = QZHKIT_FONT_LISTCELL_MAIN_TITLE;
        _nameLab.textColor = QZHKIT_Color_BLACK_87;
        _nameLab.text = @"道达信息";
    }
    return  _nameLab;
}

-(UIImageView *)IMGView{
    if (!_IMGView) {
        _IMGView = [[UIImageView alloc] init];
        _IMGView.contentMode = UIViewContentModeScaleToFill;
        QZHViewRadius(_IMGView, QZHSIZE_HEIGHT_LISTCELL_IMAGE/2);
        _IMGView.image = [UIImage imageNamed:@"banner2.jpeg"];
    }
    return _IMGView;
}

-(void)setDic:(NSDictionary *)dic{
    
    
    self.nameLab.text = [NSString stringWithFormat:@"道达信息"];

}
- (void)setFrame:(CGRect)frame {

    frame.size.height -= QZHSIZE_HEIGHT_LISTCELL_SEPARATOR;
    [super setFrame:frame];
}

@end
