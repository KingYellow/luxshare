//
//  QZHTimeCell.m
//  luxshare
//
//  Created by 黄振 on 2020/8/6.
//  Copyright © 2020 KingYellow. All rights reserved.
//

#import "QZHTimeCell.h"

@implementation QZHTimeCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self creatSubViews];
    }
    return self;
}
- (void)creatSubViews{
    [self.contentView addSubview:self.timeLab];
    [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.contentView);
    }];
}

-(UILabel *)timeLab{
    if (!_timeLab) {
        _timeLab = [[UILabel alloc] init];
        _timeLab.textColor = UIColor.blackColor;
        _timeLab.font = QZHTEXT_FONTBold(25);
        _timeLab.textAlignment = NSTextAlignmentCenter;
        
    }
    return _timeLab;
}
@end
