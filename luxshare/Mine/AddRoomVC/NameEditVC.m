//
//  NameEditVC.m
//  DDSample
//
//  Created by 黄振 on 2020/4/2.
//  Copyright © 2020 KingYellow. All rights reserved.
//

#import "NameEditVC.h"
#import "JSAddOtherCollectionViewCell.h"

@interface NameEditVC ()<UITextFieldDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic,strong) UICollectionView * mineCollection;

@property (nonatomic,strong) NSArray * infoArr;
@property (strong, nonatomic)UIButton *rightBtn;
@end

@implementation NameEditVC
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = QZHKIT_COLOR_LEADBACK;
    self.navigationItem.title = QZHLoaclString(@"room_addOtherRoom");
    [self initConfig];
}
- (void)initConfig{
    [self exp_navigationBarTextWithColor:QZHKIT_COLOR_NAVIBAR_TITLE font:QZHKIT_FONT_TABBAR_TITLE];
    [self exp_navigationBarColor:QZHKIT_COLOR_NAVIBAR_BACK hiddenShadow:NO];
    self.rightBtn = [self exp_addRightItemTitle:QZHLoaclString(@"save") itemIcon:@""];
    [self.rightBtn setTitleColor:QZH_KIT_Color_WHITE_30 forState:UIControlStateNormal];
    self.rightBtn.enabled = NO;
    
    self.rightBtn.titleLabel.font = QZHTEXT_FONT(16);
    [self createSubviews];
}
- (void)createSubviews{
    
    [self.view addSubview:self.nameField];
    UILabel *lab = [[UILabel alloc] init];
    lab.text = QZHLoaclString(@"suggest");
    lab.textColor = QZHKIT_Color_BLACK_54;
    lab.font = QZHTEXT_FONT(14);
    [self.view addSubview:lab];
    self.nameField.text = self.titleName;
    [self.view addSubview:self.mineCollection];
    _infoArr = @[@"客厅",@"主卧",@"次卧",@"餐厅",@"厨房",@"书房",@"玄关",@"阳台",@"儿童房",@"衣帽间"];
    [self.nameField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(20);
        make.height.mas_equalTo(60);
    }];
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(20);
        make.top.mas_equalTo(self.nameField.mas_bottom);
        make.height.mas_equalTo(40);
    }];
    [self.mineCollection mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(lab.mas_bottom);
        make.bottom.mas_equalTo(-QZHHeightBottom);
    }];
    
}
-(UITextField *)nameField{
    if (!_nameField) {
        _nameField = [[UITextField alloc] init];
        _nameField.textColor = QZHKIT_Color_BLACK_87;
        _nameField.font = QZHTEXT_FONT(18);
        _nameField.backgroundColor = QZH_KIT_Color_WHITE_100;
        _nameField.clearButtonMode = UITextFieldViewModeWhileEditing;
        [_nameField exp_setContentInset:UIEdgeInsetsMake(0, 15, 0, 15)];
        _nameField.placeholder = QZHLoaclString(@"member_max25");
        _nameField.jk_maxLength = 25;
        _nameField.delegate = self;
        [_nameField addTarget:self action:@selector(valueChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _nameField;
}
#pragma  mark -- action
- (void)valueChange:(UITextField *)textfield{
    NSLog(@"sss%@",textfield.text);
    if ([textfield.text isEqualToString:@""]) {
        [self.rightBtn setTitleColor:QZH_KIT_Color_WHITE_30 forState:UIControlStateNormal];
        self.rightBtn.enabled = NO;
    }else{
        [self.rightBtn setTitleColor:QZH_KIT_Color_WHITE_100 forState:UIControlStateNormal];
        self.rightBtn.enabled = YES;
    }
}

-(void)exp_rightAction{
    if (self.selectBlock) {
        self.selectBlock(self.nameField.text);
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self addHomeRoom];
    }
}
- (void)addHomeRoom {
    QZHWS(weakSelf)
    [self.home addHomeRoomWithName:self.nameField.text success:^{
        
        [QZHNotification postNotificationName:QZHNotificationKeyK1 object:nil];
        NSLog(@"add room success");
        weakSelf.refresh();
        [[QZHHUD HUD] textHUDWithMessage:QZHLoaclString(@"handleSuccess") afterDelay:0.5];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.navigationController popViewControllerAnimated:YES];

        });
    } failure:^(NSError *error) {
        [[QZHHUD HUD] textHUDWithMessage:error.userInfo[@"NSLocalizedDescription"] afterDelay:0.5];
    }];
}
#pragma mark -- uicollection
- (UICollectionView *)mineCollection{
    if (!_mineCollection) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.minimumLineSpacing = 10;
        layout.minimumInteritemSpacing = 10;
        layout.sectionInset = UIEdgeInsetsMake(15, 5, 2, 15);
        _mineCollection = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 100, self.view.frame.size.width,self.view.frame.size.height) collectionViewLayout:layout];
        _mineCollection.delegate = self;
        _mineCollection.dataSource = self;
        _mineCollection.showsHorizontalScrollIndicator = YES;
        _mineCollection.showsVerticalScrollIndicator = YES;
        _mineCollection.scrollEnabled = YES;
        _mineCollection.backgroundColor = QZHKIT_COLOR_LEADBACK;
        
        [_mineCollection registerClass:[JSAddOtherCollectionViewCell class] forCellWithReuseIdentifier:@"kReuseIdentifier0"];
        SEL sel = NSSelectorFromString(@"_setRowAlignmentsOptions:");
        if ([_mineCollection.collectionViewLayout respondsToSelector:sel]) {
            ((void(*)(id,SEL,NSDictionary*))objc_msgSend)(_mineCollection.collectionViewLayout,sel,
                                                          @{@"UIFlowLayoutCommonRowHorizontalAlignmentKey":@(NSTextAlignmentLeft),
                                                            @"UIFlowLayoutLastRowHorizontalAlignmentKey" : @(NSTextAlignmentLeft),
                                                            @"UIFlowLayoutRowVerticalAlignmentKey" : @(NSTextAlignmentCenter)});
            
        }
    }
    return _mineCollection;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
   
    return _infoArr.count;
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    //高度计算 建议放在model进行
    CGFloat itemHeight  = [self calculateStrwidthWithStr:_infoArr[indexPath.row] Font:[UIFont systemFontOfSize:18]];
   
    return CGSizeMake(itemHeight+40 , 50.0);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    JSAddOtherCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"kReuseIdentifier0" forIndexPath:indexPath];
    
    
    cell.titleLabel.text = _infoArr[indexPath.row];
    return cell;
}

-(CGFloat )collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 5;
}

- (float) calculateStrwidthWithStr:(NSString *)str Font: (UIFont *) font
{
    CGRect textRect = [str boundingRectWithSize:CGSizeMake(MAXFLOAT, font.pointSize)
                                        options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                     attributes:@{NSFontAttributeName:font}
                                        context:nil];
    
    return ceil(textRect.size.width);
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self.rightBtn setTitleColor:QZH_KIT_Color_WHITE_100 forState:UIControlStateNormal];
    self.rightBtn.enabled = YES;
    self.nameField.text = self.infoArr[indexPath.row];
}
@end
