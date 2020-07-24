//
//  PhotosListVC.m
//  luxshare
//
//  Created by 黄振 on 2020/7/13.
//  Copyright © 2020 KingYellow. All rights reserved.
//

#import "PhotosListVC.h"
#import "PhotoListCell.h"
#import "PhotPreViewVC.h"


@interface PhotosListVC ()<UITableViewDelegate,UITableViewDataSource,TuyaSmartDeviceDelegate>

@property (strong, nonatomic)UITableView *qzTableView;
@property (strong, nonatomic)UILabel *tipLab;
@property (strong, nonatomic)UIButton *addBtn;
@end

@implementation PhotosListVC
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.listArr.count == 0) {
        self.qzTableView.hidden = YES;
        self.tipLab.hidden = !self.qzTableView.hidden;
        self.addBtn.hidden = self.tipLab.hidden;
    }else{
        self.qzTableView.hidden = NO;
        self.tipLab.hidden = !self.qzTableView.hidden;
        self.addBtn.hidden = self.tipLab.hidden;
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initConfig];
    [self getphotosList];
    
}
- (void)initConfig{
    self.view.backgroundColor = QZHKIT_COLOR_LEADBACK;
    self.navigationItem.title = QZHLoaclString(@"home_manage");
    [self exp_navigationBarTextWithColor:QZHKIT_COLOR_NAVIBAR_TITLE font:QZHKIT_FONT_TABBAR_TITLE];
    [self exp_navigationBarColor:QZHKIT_COLOR_NAVIBAR_BACK hiddenShadow:NO];
    [self UIConfig];

}
- (void)UIConfig{
    
    [self.view addSubview:self.tipLab];
    [self.view addSubview:self.addBtn];
    [self.view addSubview:self.qzTableView];

    [self.tipLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.addBtn.mas_top).offset(-15);
    }];
    [self.addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.centerY.mas_equalTo(self.view.mas_centerY).offset(-50);

        make.width.mas_equalTo(100);
        make.height.mas_equalTo(50);
    }];
    
    [self.qzTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];

}

#pragma mark -tableView
-(UITableView *)qzTableView{
    if (!_qzTableView) {
        _qzTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [_qzTableView exp_tableViewDefault];
        _qzTableView.bounces = NO;
        self.qzTableView.backgroundColor = QZHKIT_COLOR_LEADBACK;
        self.qzTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _qzTableView.delegate = self;
        _qzTableView.dataSource = self;
        [self.qzTableView registerClass:[PhotoListCell class] forCellReuseIdentifier:QZHCELL_REUSE_TEXT];

    }
    return _qzTableView;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = indexPath.row;
        
    PhotoListCell *cell = [tableView dequeueReusableCellWithIdentifier:QZHCELL_REUSE_TEXT];
    HXPhotoModel *model = self.listArr[row];
    cell.selectBtn.selected = model.selected;
    [model requestThumbImageCompletion:^(UIImage * _Nullable image, HXPhotoModel * _Nullable model, NSDictionary * _Nullable info) {
        cell.IMGView.image = image;
    }];
    cell.IMGView.tag = row;
    cell.IMGView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectAction:)];
    [cell.IMGView addGestureRecognizer:tap];
    
    cell.nameLab.text = [model.creationDate jk_stringWithFormat:@"yyyy年MM月dd日"];
    cell.describeLab.text = [model.creationDate jk_stringWithFormat:@"hh:mm"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;

}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.listArr.count;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return (QZHScreenWidth/2 - 20) * 1080/1920  + 20;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.00001;
}
-(void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section{
    view.tintColor = QZHKIT_COLOR_LEADBACK;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HXPhotoModel *model = self.listArr[indexPath.row];
    PhotPreViewVC *vc = [[PhotPreViewVC alloc] init];
    vc.model = model;
    [self.navigationController pushViewController:vc animated:YES];

}

- (void)getphotosList{
    HXPhotoManager *manager =   [[HXPhotoManager alloc]initWithType:HXPhotoManagerSelectedTypePhoto];
    QZHWS(weakSelf)
    [manager getAllAlbumModelFilter:NO select:^(HXAlbumModel *selectedModel) {
    
        
    } completion:^(NSMutableArray<HXAlbumModel *> *albums) {
        for (HXAlbumModel *mm in albums) {
            NSString *appname = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"];
            if ([mm.albumName isEqualToString:appname]) {
                
                [manager getPhotoListWithAlbumModel:albums.lastObject complete:^(NSArray *allList, NSArray *previewList, NSArray *photoList, NSArray *videoList, NSArray *dateList, HXPhotoModel *firstSelectModel, HXAlbumModel *albumModel) {
            
                    weakSelf.listArr = photoList;
                    [weakSelf.qzTableView reloadData];
                }];
            }
        }

    }];
}
- (void)selectAction:(UIGestureRecognizer *)sender{
    HXPhotoModel *model = self.listArr[sender.view.tag];
    PhotoListCell *Cell = [self.qzTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:sender.view.tag inSection:0]];
    model.selected = !model.selected;
    Cell.selectBtn.selected = !Cell.selectBtn.selected;
    self.selecctResultBlock([self setSelectedArr]);
}

- (NSArray *)setSelectedArr{
    NSMutableArray *arrm = [NSMutableArray array];
    for (HXPhotoModel *model in self.listArr) {
        if (model.selected ) {
            [arrm addObject:model];
        }
    }
    return arrm;
}
- (void)selectAllVideosOrPhotos:(BOOL) select{
    for (HXPhotoModel *model in self.listArr) {
        model.selected = select;
    }
    [self.qzTableView reloadData];
    self.selecctResultBlock([self setSelectedArr]);

}

@end
