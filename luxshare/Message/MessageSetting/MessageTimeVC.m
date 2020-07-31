//
//  MessageTimeVC.m
//  luxshare
//
//  Created by 黄振 on 2020/7/27.
//  Copyright © 2020 KingYellow. All rights reserved.
//

#import "MessageTimeVC.h"
#import "BRDatePickerView.h"
#import "SettingDefaultCell.h"
#import "WeekSelectVC.h"

@interface MessageTimeVC ()<UIPickerViewDelegate,UIPickerViewDataSource>
@property (strong, nonatomic)UIPickerView *leftPicker;
@property (strong, nonatomic)UIPickerView *rightPicker;
@property (strong, nonatomic)UILabel *leftTimeLab;
@property (strong, nonatomic)UILabel *rightTimeLab;
@property (copy, nonatomic)NSMutableArray *hourArr;
@property (copy, nonatomic)NSMutableArray *minArr;
@property (strong, nonatomic)NSString *leftHour;
@property (strong, nonatomic)NSString *leftMin;
@property (strong, nonatomic)NSString *rightHour;
@property (strong, nonatomic)NSString *rightMin;
@property (strong, nonatomic)NSString *weekDays;
@property (strong, nonatomic)SettingDefaultCell *cell;
@property (strong, nonatomic)NSArray *listArr;
@end

@implementation MessageTimeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getWeekDays];
    [self initConfig];
}
- (void)initConfig{
    self.view.backgroundColor = QZHKIT_COLOR_LEADBACK;
    self.navigationItem.title = QZHLoaclString(@"setting_setting");
    [self exp_navigationBarTextWithColor:QZHKIT_COLOR_NAVIBAR_TITLE font:QZHKIT_FONT_TABBAR_TITLE];
    [self exp_navigationBarColor:QZHKIT_COLOR_NAVIBAR_BACK hiddenShadow:NO];
    [self exp_addRightItemTitle:QZHLoaclString(@"save") itemIcon:@""];

    self.leftHour = @"00";
    self.leftMin = @"00";
    self.rightHour = @"00";
    self.rightMin = @"00";

    [self UIConfig];
}
-(void)exp_rightAction{
    
}
- (void)UIConfig{
    [self.view addSubview:self.leftPicker];
    [self.view addSubview:self.rightPicker];
    [self.view addSubview:self.leftTimeLab];
    [self.view addSubview:self.rightTimeLab];
    self.cell = [[SettingDefaultCell alloc] init];
    self.cell.backgroundColor = QZH_KIT_Color_WHITE_70;
    self.cell.nameLab.text = @"重复";
    self.cell.tagLab.text = self.weekDays;
    self.cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectDateAction)];
    [self.cell .contentView addGestureRecognizer:tap];
    [self.view addSubview:self.cell .contentView];
    
    [self.cell .contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(-10);
        make.top.mas_equalTo(0);
        make.right.mas_equalTo(10);
        make.height.mas_equalTo(50);
    }];
    [self.leftTimeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(100);
        make.width.mas_equalTo(QZHScreenWidth/2 - 20);
        make.height.mas_equalTo(20);
    }];
    [self.leftPicker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(self.leftTimeLab.mas_bottom).offset(20);
        make.width.mas_equalTo(QZHScreenWidth/2 - 20);
        make.height.mas_equalTo(240);
    }];
    [self.rightTimeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20);
        make.top.mas_equalTo(100);
        make.width.mas_equalTo(QZHScreenWidth/2 - 20);
        make.height.mas_equalTo(20);
    }];
    [self.rightPicker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20);
        make.top.mas_equalTo(self.rightTimeLab.mas_bottom).offset(20);
        make.width.mas_equalTo(QZHScreenWidth/2 - 20);
        make.height.mas_equalTo(240);
    }];

}
#pragma mark -- lazy

-(UIPickerView *)leftPicker{
    if (!_leftPicker) {
        _leftPicker = [[UIPickerView alloc] init];
        _leftPicker.dataSource =self;
        _leftPicker.delegate = self;
    }
    return _leftPicker;
}
-(UIPickerView *)rightPicker{
    if (!_rightPicker) {
        _rightPicker = [[UIPickerView alloc] init];
        _rightPicker.dataSource =self;
        _rightPicker.delegate = self;
    }
    return _rightPicker;
}
-(UILabel *)leftTimeLab{
    if (!_leftTimeLab) {
        _leftTimeLab = [[UILabel alloc] init];
        _leftTimeLab.textColor = QZHKIT_Color_BLACK_87;
        _leftTimeLab.font = QZHKIT_FONT_LISTCELL_BIG_TITLE;
        _leftTimeLab.textAlignment = NSTextAlignmentCenter;
       _leftTimeLab.text = [NSString stringWithFormat:@"%@:%@",self.leftHour,self.leftMin];
    }
    return _leftTimeLab;
}
-(UILabel *)rightTimeLab{
    if (!_rightTimeLab) {
        _rightTimeLab = [[UILabel alloc] init];
        _rightTimeLab.textColor = QZHKIT_Color_BLACK_87;
        _rightTimeLab.font = QZHKIT_FONT_LISTCELL_BIG_TITLE;
        _rightTimeLab.textAlignment = NSTextAlignmentCenter;
        _rightTimeLab.text = [NSString stringWithFormat:@"%@:%@",self.rightHour,self.rightMin];
        
    }
    return _rightTimeLab;
}
-(NSMutableArray *)hourArr{
    if (!_hourArr) {
        _hourArr = [NSMutableArray array];
        for (int i=0; i < 24; i++) {
            [_hourArr addObject:[NSString stringWithFormat:@"%02d",i]];
        }
    }
    return _hourArr;
}
-(NSMutableArray *)minArr{
    if (!_minArr) {
        _minArr = [NSMutableArray array];
        for (int i=0; i < 60; i++) {
            [_minArr addObject:[NSString stringWithFormat:@"%02d",i]];
        }
    }
    return _minArr;
}
-(NSArray *)listArr{
    if (!_listArr) {
        _listArr = [NSArray array];
    }
    return _listArr;
}
#pragma mark -- delegate
// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component == 0) {
        
        return self.hourArr.count;
    }else{
        return self.minArr.count;
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    return 100;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 40;
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (component == 0) {
        return  self.hourArr[row];
    }else{
        return  self.minArr[row];
    }
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (pickerView == self.leftPicker) {
        if (component == 0) {
            self.leftHour = self.hourArr[row];
        }else{
            self.leftMin = self.minArr[row];
        }
        self.leftTimeLab.text = [NSString stringWithFormat:@"%@:%@",self.leftHour,self.leftMin];
        
    }else{
        if (component == 0) {
            self.rightHour = self.hourArr[row];
        }else{
            self.rightMin = self.minArr[row];
        }
        self.rightTimeLab.text = [NSString stringWithFormat:@"%@:%@",self.rightHour,self.rightMin];
        
    }
}

- (void)selectDateAction{
    QZHWS(weakSelf)
    NSMutableArray *weekArr = [NSMutableArray array];
    
    WeekSelectVC *VC = [[WeekSelectVC alloc] init];
    NSMutableArray *listArr = [NSMutableArray arrayWithArray:[QZHDataHelper readValueForKey:@"weekDays"]];
     if (listArr.count >0) {
         VC.listArr = listArr;
     }
    VC.selectWeek = ^(NSArray * _Nonnull listArr) {
         for (NSDictionary *dic in listArr) {
              if ([dic[@"select"] boolValue]) {
                  [weekArr addObject:dic[@"week"]];
              }
          }
          if (weekArr.count == 7) {
              weakSelf.weekDays = @"每天";
          }else if(weekArr.count == 5 && ![weekArr containsObject:@"星期六"] && ![weekArr containsObject:@"星期日"]){
                 self.weekDays = @"工作日";
          }else if(weekArr.count == 0){
              self.weekDays = @"永不";
          }else{
              self.weekDays = [weekArr componentsJoinedByString:@","];
          }
          weakSelf.cell.tagLab.text = weakSelf.weekDays;
          
          [QZHDataHelper saveValue:listArr forKey:@"weekDays"];
    };
    [self.navigationController pushViewController:VC animated:YES];
}
- (void)getWeekDays{
    NSMutableArray *weekArr = [NSMutableArray array];
    NSMutableArray *listArr = [NSMutableArray arrayWithArray:[QZHDataHelper readValueForKey:@"weekDays"]];
    for (NSDictionary *dic in listArr) {
        if ([dic[@"select"] boolValue]) {
            [weekArr addObject:dic[@"week"]];
        }
    }
    if (weekArr.count == 7) {
        self.weekDays = @"每天";
    }else if(weekArr.count == 5 && ![weekArr containsObject:@"星期六"] && ![weekArr containsObject:@"星期日"]){
           self.weekDays = @"工作日";
    }else if(weekArr.count == 0){
        self.weekDays = @"永不";
    }else{
        self.weekDays = [weekArr componentsJoinedByString:@","];
    }
}
@end
