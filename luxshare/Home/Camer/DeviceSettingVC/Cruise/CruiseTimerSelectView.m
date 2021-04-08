//
//  CruiseTimerSelectView.m
//  luxshare
//
//  Created by 黄振 on 2021/1/11.
//  Copyright © 2021 KingYellow. All rights reserved.
//

#import "CruiseTimerSelectView.h"

//
//  CruiseTimerSelectVC.m
//  luxshare
//
//  Created by 黄振 on 2021/1/11.
//  Copyright © 2021 KingYellow. All rights reserved.
//

#import "CruiseTimerSelectView.h"
#import "BRDatePickerView.h"

@interface CruiseTimerSelectView ()<UIPickerViewDelegate,UIPickerViewDataSource>

@property (strong, nonatomic)UILabel *leftTimeLab;
@property (strong, nonatomic)UILabel *rightTimeLab;
@property (strong, nonatomic)UILabel *yesterdayLab;
@property (strong, nonatomic)UILabel *todayLab;
@property (strong, nonatomic)UIButton *cancelBtn;
@property (strong, nonatomic)UIButton *submitBtn;
@property (strong, nonatomic)UIView *bigView;
@property (strong, nonatomic)NSMutableArray *hourArr;
@property (strong, nonatomic)NSMutableArray *minArr;
@property (strong, nonatomic)NSString *leftHour;
@property (strong, nonatomic)NSString *leftMin;
@property (strong, nonatomic)NSString *rightHour;
@property (strong, nonatomic)NSString *rightMin;
@property (strong, nonatomic)NSString *weekDays;
@property (strong, nonatomic)NSArray *listArr;
@end

@implementation CruiseTimerSelectView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initConfig];

        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelAction)];
        [self addGestureRecognizer:tap];
    }
    return self;;
}

- (void)creatSelectTimerViewConfig{
    self.leftHour = @"00";
    self.leftMin = @"00";
    self.rightHour = @"00";
    self.rightMin = @"00";
    NSData *jsonData = [self.selectTime dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];

    NSString *startTime = dic[@"t_start"];
    NSString *endTime = dic[@"t_end"];
    if (self.selectTime.length > 0) {

        self.leftHour = [startTime componentsSeparatedByString:@":"].firstObject;
        self.leftMin = [startTime componentsSeparatedByString:@":"].lastObject;
        self.rightHour = [endTime componentsSeparatedByString:@":"].firstObject;
        self.rightMin = [endTime componentsSeparatedByString:@":"].lastObject;
        NSInteger leftH = [self.leftHour integerValue];
        NSInteger leftM = [self.leftMin integerValue];
        NSInteger rightH = [self.rightHour integerValue];
        NSInteger rightM = [self.rightMin integerValue];
        [self.leftPicker selectRow:leftH inComponent:0 animated:YES];
        [self.leftPicker selectRow:leftM inComponent:1 animated:YES];
        [self.rightPicker selectRow:rightH inComponent:0 animated:YES];
        [self.rightPicker selectRow:rightM inComponent:1 animated:YES];
    }
    _leftTimeLab.text = [NSString stringWithFormat:@"%@:%@",self.leftHour,self.leftMin];
    _rightTimeLab.text = [NSString stringWithFormat:@"%@:%@",self.rightHour,self.rightMin];
    [self compareRightTime];

}
- (void)initConfig{
    self.backgroundColor = QZHKIT_Color_BLACK_26;

    [self UIConfig];
}
#pragma mark -- action
- (void)cancelAction{
    [self removeFromSuperview];
}
- (void)submitAction{
    
    if (!self.leftHour) {
        self.leftHour = @"00";
    }
    if (!self.leftMin) {
        self.leftMin = @"00";
    }
    if (!self.rightHour) {
        self.rightHour = @"00";
    }
    if (!self.rightMin) {
        self.rightMin = @"00";
    }
    self.selectBlock([NSString stringWithFormat:@"%@:%@",self.leftHour,self.leftMin],[NSString stringWithFormat:@"%@:%@",self.rightHour,self.rightMin]);
    [self removeFromSuperview];
    
}
- (void)UIConfig{
    [self addSubview:self.bigView];
    [self.bigView addSubview:self.cancelBtn];
    [self.bigView addSubview:self.submitBtn];
    [self.bigView addSubview:self.leftPicker];
    [self.bigView addSubview:self.rightPicker];
    [self.bigView addSubview:self.leftTimeLab];
    [self.bigView addSubview:self.rightTimeLab];
    [self.bigView addSubview:self.yesterdayLab];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = QZHKIT_Color_BLACK_26;
    [self.bigView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.mas_equalTo(0);
        make.bottom.mas_equalTo(self.cancelBtn.mas_top);
        make.height.mas_equalTo(1);
    }];
    [self.bigView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.leftTimeLab).offset(-20);
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.bottom.mas_equalTo(-QZHHeightBottom);
        make.width.mas_equalTo(QZHScreenWidth/2);
        make.height.mas_equalTo(50 * QZHScaleWidth);
    }];
    [self.submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-QZHHeightBottom);
        make.width.mas_equalTo(QZHScreenWidth/2);
        make.height.mas_equalTo(50 * QZHScaleWidth);
    }];
    
    [self.leftTimeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.bottom.mas_equalTo(self.rightTimeLab);
        make.width.mas_equalTo(QZHScreenWidth/2 - 20);
        make.height.mas_equalTo(20);
    }];
    [self.leftPicker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.bottom.mas_equalTo(self.cancelBtn.mas_top).offset(-1);
        make.width.mas_equalTo(QZHScreenWidth/2 - 20);
        make.height.mas_equalTo(240);
    }];
    [self.rightTimeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.bottom.mas_equalTo(self.yesterdayLab.mas_top);
        make.width.mas_equalTo(QZHScreenWidth/2 - 20);
        make.height.mas_equalTo(20);
    }];
    [self.yesterdayLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20);
        make.bottom.mas_equalTo(self.rightPicker.mas_top);
        make.width.mas_equalTo(QZHScreenWidth/2 - 20);
        make.height.mas_equalTo(40);
    }];
    [self.rightPicker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20);
        make.bottom.mas_equalTo(self.cancelBtn.mas_top).offset(-1);
        make.width.mas_equalTo(QZHScreenWidth/2 - 20);
        make.height.mas_equalTo(240);
    }];

}
#pragma mark -- lazy
-(UIView *)bigView{
    if (!_bigView) {
        _bigView = [[UIView alloc] init];
        _bigView.backgroundColor = QZHKIT_COLOR_LEADBACK;
    }
    
    return _bigView;
}
-(UIButton *)cancelBtn{
    if (!_cancelBtn) {
        _cancelBtn = [[UIButton alloc] init];
        [_cancelBtn setTitleColor:QZHKIT_Color_BLACK_70 forState:UIControlStateNormal];
        [_cancelBtn setTitle:QZHLoaclString(@"cancel") forState:UIControlStateNormal];
        [_cancelBtn addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}
-(UIButton *)submitBtn{
    if (!_submitBtn) {
        _submitBtn = [[UIButton alloc] init];
        [_submitBtn setTitle:QZHLoaclString(@"submit") forState:UIControlStateNormal];
        [_submitBtn setTitleColor:QZHKIT_COLOR_SKIN forState:UIControlStateNormal];

        [_submitBtn addTarget:self action:@selector(submitAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _submitBtn;
}

- (UIPickerView *)leftPicker{
    if (!_leftPicker) {
        _leftPicker = [[UIPickerView alloc] init];
        _leftPicker.dataSource =self;
        _leftPicker.delegate = self;
    }
    return _leftPicker;
}
- (UIPickerView *)rightPicker{
    if (!_rightPicker) {
        _rightPicker = [[UIPickerView alloc] init];
        _rightPicker.dataSource =self;
        _rightPicker.delegate = self;
    }
    return _rightPicker;
}
- (UILabel *)leftTimeLab{
    if (!_leftTimeLab) {
        _leftTimeLab = [[UILabel alloc] init];
        _leftTimeLab.textColor = QZHKIT_Color_BLACK_87;
        _leftTimeLab.font = QZHKIT_FONT_LISTCELL_BIG_TITLE;
        _leftTimeLab.textAlignment = NSTextAlignmentCenter;
    }
    return _leftTimeLab;
}
- (UILabel *)rightTimeLab{
    if (!_rightTimeLab) {
        _rightTimeLab = [[UILabel alloc] init];
        _rightTimeLab.textColor = QZHKIT_Color_BLACK_87;
        _rightTimeLab.font = QZHKIT_FONT_LISTCELL_BIG_TITLE;
        _rightTimeLab.textAlignment = NSTextAlignmentCenter;
        
    }
    return _rightTimeLab;
}
- (UILabel *)yesterdayLab{
    if (!_yesterdayLab) {
        _yesterdayLab = [[UILabel alloc] init];
        _yesterdayLab.textColor = QZHKIT_Color_BLACK_87;
        _yesterdayLab.font = QZHKIT_FONT_LISTCELL_MAIN_TITLE;
        _yesterdayLab.textAlignment = NSTextAlignmentCenter;
        _yesterdayLab.text = QZHLoaclString(@"today");
        
    }
    return _yesterdayLab;
}
- (NSMutableArray *)hourArr{
    if (!_hourArr) {
        _hourArr = [NSMutableArray array];
        for (int i=0; i < 24; i++) {
            [_hourArr addObject:[NSString stringWithFormat:@"%02d",i]];
        }
    }
    return _hourArr;
}
- (NSMutableArray *)minArr{
    if (!_minArr) {
        _minArr = [NSMutableArray array];
        for (int i=0; i < 60; i++) {
            [_minArr addObject:[NSString stringWithFormat:@"%02d",i]];
        }
    }
    return _minArr;
}
- (NSArray *)listArr{
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

//- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
//    return 100;
//}
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
    [self compareRightTime];
}


- (void)compareRightTime{
    if ([self.leftHour intValue] < [self.rightHour intValue]) {
        self.yesterdayLab.text = QZHLoaclString(@"today");
    }else if([self.leftHour intValue] > [self.rightHour intValue]){
        self.yesterdayLab.text = QZHLoaclString(@"tomorrow");
    }else{
        if ([self.leftMin intValue] < [self.rightMin intValue]) {
            self.yesterdayLab.text = QZHLoaclString(@"today");
        }else{
            self.yesterdayLab.text = QZHLoaclString(@"tomorrow");
        }
    }
}
@end
