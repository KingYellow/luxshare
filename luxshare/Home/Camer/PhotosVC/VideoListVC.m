//
//  VideoListVC.m
//  luxshare
//
//  Created by 黄振 on 2020/7/13.
//  Copyright © 2020 KingYellow. All rights reserved.
//

#import "VideoListVC.h"
#import "PhotoListCell.h"
#import "VideoPlayVC.h"


@interface VideoListVC ()<UITableViewDelegate,UITableViewDataSource,TuyaSmartDeviceDelegate>

@property (strong, nonatomic)UITableView *qzTableView;
@property (strong, nonatomic)UILabel *tipLab;
@property (strong, nonatomic)UIButton *addBtn;
@end

@implementation VideoListVC
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
    
    [model requestThumbImageCompletion:^(UIImage * _Nullable image, HXPhotoModel * _Nullable model, NSDictionary * _Nullable info) {
        cell.IMGView.image = image;
    }];
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
    [model requestAVPlayerItemStartRequestICloud:^(PHImageRequestID iCloudRequestId, HXPhotoModel * _Nullable model) {
        
    } progressHandler:^(double progress, HXPhotoModel * _Nullable model) {
        
    } success:^(AVPlayerItem * _Nullable playerItem, HXPhotoModel * _Nullable model, NSDictionary * _Nullable info) {
        VideoPlayVC *pl = [[VideoPlayVC alloc] init];
        pl.playiItem = playerItem;
        [self.navigationController pushViewController:pl animated:YES];
        
    } failed:^(NSDictionary * _Nullable info, HXPhotoModel * _Nullable model) {
    
    }];

}

- (void)getphotosList{
 HXPhotoManager *manager =   [[HXPhotoManager alloc]initWithType:HXPhotoManagerSelectedTypeVideo];
    HXAlbumModel *model = [[HXAlbumModel alloc] init];
    QZHWS(weakSelf)
    [manager getAllAlbumModelFilter:NO select:^(HXAlbumModel *selectedModel) {
    
        
    } completion:^(NSMutableArray<HXAlbumModel *> *albums) {
        for (HXAlbumModel *mm in albums) {
            NSString *appname = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"];
            if ([mm.albumName isEqualToString:appname]) {
                [manager getPhotoListWithAlbumModel:albums.lastObject complete:^(NSArray *allList, NSArray *previewList, NSArray *photoList, NSArray *videoList, NSArray *dateList, HXPhotoModel *firstSelectModel, HXAlbumModel *albumModel) {
                
                    weakSelf.listArr = videoList;
                    [weakSelf.qzTableView reloadData];
                }];
            }
        }

    }];
}
@end
