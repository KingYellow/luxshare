//
//  PerInfoVC.m
//  DDSample
//
//  Created by 黄振 on 2020/4/2.
//  Copyright © 2020 KingYellow. All rights reserved.
//

#import "PerInfoVC.h"
#import "PerInfoPicCell.h"
#import "PerInfoDefaultCell.h"
#import "QZHDefaultButtonCell.h"
#import "HXPhotoPicker.h"
#import "NameEditVC.h"
#import "ResetPWVC.h"
#import "RegisterVC.h"

@interface PerInfoVC ()<UITableViewDelegate,UITableViewDataSource,HXPhotoViewControllerDelegate,HXAlbumListViewControllerDelegate>
@property (strong, nonatomic)UITableView *qzTableView;
@property (copy, nonatomic)NSMutableArray *listArr;
@property (copy, nonatomic)NSMutableArray *logoArr;
@property (copy, nonatomic)UIImage *image;
@property (strong, nonatomic) CLLocation *location;
@property (strong, nonatomic) HXPhotoManager *manager;

@end

@implementation PerInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initConfig];
    
}
- (void)initConfig{
    self.view.backgroundColor = QZHKIT_COLOR_LEADBACK;
    self.navigationItem.title = @"个人信息";
    [self exp_navigationBarTextWithColor:QZHKIT_COLOR_NAVIBAR_TITLE font:QZHKIT_FONT_TABBAR_TITLE];
    [self exp_navigationBarColor:QZHKIT_COLOR_NAVIBAR_BACK hiddenShadow:NO];
    [self UIConfig];

}
- (void)UIConfig{
    
    [self.view addSubview:self.qzTableView];
    
     [self.qzTableView mas_makeConstraints:^(MASConstraintMaker *make) {
         make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0 ));
     }];
}

#pragma mark -tableView
-(UITableView *)qzTableView{
    if (!_qzTableView) {
        _qzTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [_qzTableView exp_tableViewDefault];
        self.qzTableView.backgroundColor = QZHKIT_COLOR_LEADBACK;
        self.qzTableView.separatorStyle = UITableViewCellSeparatorStyleNone;

        _qzTableView.delegate = self;
        _qzTableView.dataSource = self;
        
        [self.qzTableView registerClass:[PerInfoPicCell class] forCellReuseIdentifier:QZHCELL_REUSE_IMAGE];
        [self.qzTableView registerClass:[PerInfoDefaultCell class] forCellReuseIdentifier:QZHCELL_REUSE_TEXT];
        [self.qzTableView registerClass:[QZHDefaultButtonCell class] forCellReuseIdentifier:QZHCELL_REUSE_DEFAULT];

    }
    return _qzTableView;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (section == 0) {
        if (row == 0) {
            PerInfoPicCell *cell = [tableView dequeueReusableCellWithIdentifier:QZHCELL_REUSE_IMAGE];
            cell.nameLab.text = @"头像";
            [cell.IMGView exp_loadImageUrlString:[TuyaSmartUser sharedInstance].headIconUrl placeholder:QZHICON_HEAD_PLACEHOLDER];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else{
            PerInfoDefaultCell *cell = [tableView dequeueReusableCellWithIdentifier:QZHCELL_REUSE_TEXT];
            if (row == 1) {
                cell.nameLab.text = @"昵称";
                cell.describeLab.text = [TuyaSmartUser sharedInstance].nickname;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                NSLog(@"shifouzaidenglu %d",[TuyaSmartUser sharedInstance].isLogin);
            }else{
                cell.nameLab.text = @"手机号码";
                cell.describeLab.text = [TuyaSmartUser sharedInstance].phoneNumber;
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }else if(section == 1){
        PerInfoDefaultCell *cell = [tableView dequeueReusableCellWithIdentifier:QZHCELL_REUSE_TEXT];
        cell.nameLab.text = @"修改登录密码";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        QZHDefaultButtonCell *cell = [tableView dequeueReusableCellWithIdentifier:QZHCELL_REUSE_DEFAULT];
        cell.nameLab.text = @"退出登录";
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
 
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return section==0?3:1;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0 && indexPath.section == 0) {
        return 80;
    }
    return 50;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}
-(void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section{
    view.tintColor = QZHKIT_COLOR_LEADBACK;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger section = indexPath.section;
    if (section == 0) {
         if (indexPath.row == 0) {
               [self selectedPhoto];
           }else if (indexPath.row == 1){
               UIAlertController *alert = [UIAlertController alertWithTextfieldTitle:@"修改昵称" originaltext:[TuyaSmartUser sharedInstance].nickname textblock:^(NSString * _Nonnull fieldtext) {
                   if (fieldtext.length > 0) {
                       [self uploadNickname:fieldtext];
                   }else{
                       [[QZHHUD HUD]textHUDWithMessage:@"昵称不能为空" afterDelay:1.0];
                   }
               }];
               [self presentViewController:alert animated:YES completion:^{
                   
               }];
           }
    }else if(section == 1){
        RegisterVC *vc = [[RegisterVC alloc] init];
        vc.title = QZHLoaclString(@"login_resetPassword");
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if(section == 2){
        [[TuyaSmartUser sharedInstance] loginOut:^{
               NSLog(@"logOut success");
            [QZHDataHelper removeForKey:QZHKEY_TOKEN];
                 [QZHROOT_DELEGATE setVC];
           } failure:^(NSError *error) {
               NSLog(@"logOut failure: %@", error);
           }];
     
    }
   
}

#pragma mark --lazy
- (NSMutableArray *)listArr{
    if (!_listArr) {
        _listArr = [NSMutableArray arrayWithArray:@[@"头像",@"姓名"]];
 
    }
    return _listArr;
}

-(NSMutableArray *)logoArr{
    if (!_logoArr) {
        _logoArr = [NSMutableArray arrayWithArray:@[@"about",@"lianxi",@"shezhi"]];
    }
    return _logoArr;
}

#pragma mark -- HXHhotoPicker框架
- (HXPhotoManager *)manager {
    if (!_manager) {
        _manager = [[HXPhotoManager alloc] initWithType:HXPhotoManagerSelectedTypePhoto];
        _manager.configuration.singleSelected = YES;
        
        _manager.configuration.albumListTableView = ^(UITableView *tableView) {
            
        };
        //单选后直接进入编辑模式
        _manager.configuration.singleJumpEdit = YES;
        _manager.configuration.movableCropBox = YES;
        _manager.configuration.movableCropBoxEditSize = YES;
        _manager.configuration.movableCropBoxCustomRatio = CGPointMake(1, 1);

    }
    return _manager;
}
- (void)selectedPhoto {
    self.manager.configuration.saveSystemAblum = YES;
    QZHWS(weakSelf)
    [self hx_presentSelectPhotoControllerWithManager:self.manager didDone:^(NSArray<HXPhotoModel *> *allList, NSArray<HXPhotoModel *> *photoList, NSArray<HXPhotoModel *> *videoList, BOOL isOriginal, UIViewController *viewController, HXPhotoManager *manager) {
        HXPhotoModel *model = allList.firstObject;
        
        if (model.subType == HXPhotoModelMediaSubTypePhoto) {
            [weakSelf.view hx_showLoadingHUDText:@"获取图片中"];
            [model requestPreviewImageWithSize:PHImageManagerMaximumSize startRequestICloud:nil progressHandler:nil success:^(UIImage *image, HXPhotoModel *model, NSDictionary *info) {
                UIImage *scaleImage = [UIImage exp_imageScaleWithImage:image toByte:0];
                [weakSelf.view hx_handleLoading];
                weakSelf.image = scaleImage;
                [self uploadHeadPic:scaleImage];

            } failed:^(NSDictionary *info, HXPhotoModel *model) {
                [weakSelf.view hx_handleLoading];
                [weakSelf.view hx_showImageHUDText:@"获取失败"];
            }];
        }
    } cancel:^(UIViewController *viewController, HXPhotoManager *manager) {
        NSSLog(@"取消了");
        [viewController dismissViewControllerAnimated:YES completion:nil];
    }];
}
- (void)albumListViewController:(HXAlbumListViewController *)albumListViewController didDoneAllList:(NSArray<HXPhotoModel *> *)allList photos:(NSArray<HXPhotoModel *> *)photoList videos:(NSArray<HXPhotoModel *> *)videoList original:(BOOL)original {
    if (photoList.count > 0) {
        HXPhotoModel *model = photoList.firstObject;
        UIImage *scaleImage = [UIImage exp_imageScaleWithImage:model.previewPhoto toByte:0];
        self.image = scaleImage;
        [self uploadHeadPic:scaleImage];
    }else if (videoList.count > 0) {
        
    }
}

- (void)uploadHeadPic:(UIImage *)headIcon{
    [[TuyaSmartUser sharedInstance] updateHeadIcon:headIcon success:^{
        NSLog(@"update head icon success");
        [UIImage exp_saveImageToLocal:headIcon path:QZHICON_HEADPIC];
        [self.qzTableView reloadData];
    } failure:^(NSError *error) {
        NSLog(@"update head icon failure: %@", error);
    }];
    
}
- (void)uploadNickname:(NSString *)nickname{
    QZHWS(weakSelf)
    [[TuyaSmartUser sharedInstance] updateNickname:nickname success:^{
        NSLog(@"updateNickname success");
        [weakSelf.qzTableView reloadData];
    } failure:^(NSError *error) {
        NSLog(@"updateNickname failure: %@", error);
           [[QZHHUD HUD] textHUDWithMessage:error.userInfo[@"NSLocalizedDescription"] afterDelay:0.5];
    }];
}
@end
