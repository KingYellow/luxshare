//
//  OnLiveCell.m
//  luxshare
//
//  Created by 黄振 on 2020/7/7.
//  Copyright © 2020 KingYellow. All rights reserved.
//

#import "OnLiveCell.h"

@implementation OnLiveCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {

        [self creatSubViews];
        self.backgroundColor = QZHKIT_COLOR_LEADBACK;
    }
    return self;
}
- (void)creatSubViews{
    
}

@end
