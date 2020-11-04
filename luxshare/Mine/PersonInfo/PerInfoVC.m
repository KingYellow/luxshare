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
#import "RegisterSecondVC.h"

@interface PerInfoVC ()<UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate,HXPhotoViewControllerDelegate,HXAlbumListViewControllerDelegate>
@property (strong, nonatomic)UITableView *qzTableView;
@property (strong, nonatomic)NSMutableArray *listArr;
@property (strong, nonatomic)NSMutableArray *logoArr;
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
    self.navigationItem.title = QZHLoaclString(@"personInfo_info");
//    [self exp_navigationBarTextWithColor:QZHKIT_COLOR_NAVIBAR_TITLE font:QZHKIT_FONT_TABBAR_TITLE];
//    [self exp_navigationBarColor:QZHKIT_COLOR_NAVIBAR_BACK hiddenShadow:NO];
    [self UIConfig];

}
- (void)UIConfig{
    
    [self.view addSubview:self.qzTableView];
    [self.qzTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0 ));
    }];
}

#pragma mark -tableView
- (UITableView *)qzTableView{
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
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (section == 0) {
        if (row == 0) {
            PerInfoPicCell *cell = [tableView dequeueReusableCellWithIdentifier:QZHCELL_REUSE_IMAGE];
            cell.nameLab.text = QZHLoaclString(@"personInfo_headPic");
            [cell.IMGView exp_loadImageUrlString:[TuyaSmartUser sharedInstance].headIconUrl placeholder:QZHICON_HEAD_PLACEHOLDER];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else{
            PerInfoDefaultCell *cell = [tableView dequeueReusableCellWithIdentifier:QZHCELL_REUSE_TEXT];
            if (row == 1) {
                cell.nameLab.text = QZHLoaclString(@"personInfo_nickName");
                if ([[TuyaSmartUser sharedInstance].nickname exp_Length] > 0) {
                    cell.describeLab.text = [TuyaSmartUser sharedInstance].nickname;
                }else{
                    cell.describeLab.text = [TuyaSmartUser sharedInstance].userName;
                }
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }else{
//                NSString *phone = [TuyaSmartUser sharedInstance].phoneNumber;
                if ([[TuyaSmartUser sharedInstance].phoneNumber exp_Length] > 0) {
                    cell.nameLab.text = QZHLoaclString(@"personInfo_phoneNum");
                    cell.describeLab.text = [TuyaSmartUser sharedInstance].phoneNumber;
                    
                }else{
                    cell.nameLab.text = QZHLoaclString(@"mine_email");
                    cell.describeLab.text = [TuyaSmartUser sharedInstance].email;
                }

            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }else if(section == 1){
        PerInfoDefaultCell *cell = [tableView dequeueReusableCellWithIdentifier:QZHCELL_REUSE_TEXT];
        cell.nameLab.text = QZHLoaclString(@"personInfo_editLoginPW");
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        QZHDefaultButtonCell *cell = [tableView dequeueReusableCellWithIdentifier:QZHCELL_REUSE_DEFAULT];
        cell.nameLab.text = QZHLoaclString(@"logout");
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
 
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return section==0?3:1;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0 && indexPath.section == 0) {
        return 80;
    }
    return 50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}
- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section{
    view.tintColor = QZHKIT_COLOR_LEADBACK;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger section = indexPath.section;
    if (section == 0) {
         if (indexPath.row == 0) {
               [self camerAction];
           }else if (indexPath.row == 1){
               UIAlertController *alert = [UIAlertController alertWithTextfieldTitle:QZHLoaclString(@"editNickname") originaltext:[[TuyaSmartUser sharedInstance].nickname exp_Length] > 0 ? [TuyaSmartUser sharedInstance].nickname:[TuyaSmartUser sharedInstance].userName textblock:^(NSString * _Nonnull fieldtext) {
                   if (fieldtext.length > 0) {
                       [self uploadNickname:fieldtext];
                   }else{
                       [[QZHHUD HUD]textHUDWithMessage:QZHLoaclString(@"nicknameCantSpace") afterDelay:1.0];
                   }
               }];
               [self presentViewController:alert animated:YES completion:^{
                   
               }];
           }
    }else if(section == 1){

        RegisterSecondVC *vc = [[RegisterSecondVC alloc] init];
        vc.conutry = [TuyaSmartUser sharedInstance].countryCode;
        if ([[TuyaSmartUser sharedInstance].phoneNumber exp_Length] > 0){
            NSString *phone = [TuyaSmartUser sharedInstance].phoneNumber;
            NSArray *arr  = [phone componentsSeparatedByString:@"-"];
            if (arr.count > 1) {
                phone = arr[1];
            }
            vc.account = phone;
        }else{
            vc.account = [TuyaSmartUser sharedInstance].email;
        }
        vc.titleText = QZHLoaclString(@"login_resetPassword");;
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if(section == 2){
        [[TuyaSmartUser sharedInstance] loginOut:^{
            [QZHDataHelper removeForKey:QZHKEY_TOKEN];
            [QZHROOT_DELEGATE setVC];
        } failure:^(NSError *error) {
               [[QZHHUD HUD] textHUDWithMessage:error.userInfo[@"NSLocalizedDescription"] afterDelay:0.5];
        }];
    }
}

#pragma mark --lazy
- (NSMutableArray *)listArr{
    if (!_listArr) {
        _listArr = [NSMutableArray arrayWithArray:@[QZHLoaclString(@"personInfo_headPic"),QZHLoaclString(@"personInfo_name")]];
 
    }
    return _listArr;
}

- (NSMutableArray *)logoArr{
    if (!_logoArr) {
        _logoArr = [NSMutableArray arrayWithArray:@[@"about",@"lianxi",@"shezhi"]];
    }
    return _logoArr;
}

// 打开相机相册
- (void)camerAction{
  
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"" message:QZHLoaclString(@"selectHeadPic") preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:QZHLoaclString(@"selectFromPictures") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]){
            UIImagePickerController *picker = [[UIImagePickerController alloc]init];
            // 打开相册
            picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;

            picker.delegate =self;
            picker.modalPresentationStyle = UIModalPresentationOverFullScreen;

             [self presentViewController:picker animated:YES completion:nil];
        }
        
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:QZHLoaclString(@"openCamer") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            
            UIImagePickerController * picker = [[UIImagePickerController alloc]init];
            picker.delegate = self;
            //摄像头
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            picker.modalPresentationStyle = UIModalPresentationOverFullScreen;
            [self presentViewController:picker animated:YES completion:nil];
        }else{
            
            //如果没有提示用户
            [[QZHHUD HUD] textHUDWithMessage:@"当前相机不可用" afterDelay:1.0];
        }
    }];
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:QZHLoaclString(@"cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {

    }];
    [alertC addAction:action1];
    [alertC addAction:action2];
    [alertC addAction:action3];
    [self presentViewController:alertC animated:YES completion:nil];
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    QZHWS(weakSelf)
    UIImage *image=[info objectForKey:UIImagePickerControllerOriginalImage];//获取原始照片
    HXPhotoModel *photoModel = [HXPhotoModel photoModelWithImage:image];
    [picker hx_presentPhotoEditViewControllerWithManager:self.manager photoModel:photoModel delegate:nil done:^(HXPhotoModel *beforeModel,
        HXPhotoModel *afterModel, HXPhotoEditViewController *viewController) {
            [weakSelf performSelector:@selector(selectPic:) withObject:afterModel.previewPhoto afterDelay:0.1];
            [self dismissViewControllerAnimated:YES completion:nil];

    } cancel:^(HXPhotoEditViewController *viewController) {
        // 取消
        [self dismissViewControllerAnimated:YES completion:nil];

    }];
    // 获取照片

}
// 选择照片显示
- (void)selectPic:(UIImage *)image
{
    NSLog(@"image:%@",image);
    NSData *imageData;
    if (UIImagePNGRepresentation(image) == nil) {
        
        imageData = UIImageJPEGRepresentation(image, 1);
        
    } else {
        
        imageData = UIImageJPEGRepresentation(image, 0.3);
        if (imageData.length > 2*1024*1024) {
            imageData = UIImageJPEGRepresentation(image, 0.1);
        }
    }
    [self uploadHeadPic:[UIImage imageWithData:imageData]];
}


- (void)uploadHeadPic:(UIImage *)headIcon{
    [[TuyaSmartUser sharedInstance] updateHeadIcon:headIcon success:^{
        [UIImage exp_saveImageToLocal:headIcon path:QZHICON_HEADPIC];
        [[QZHHUD HUD] textHUDWithMessage:QZHLoaclString(@"handleSuccess") afterDelay:0.5];
    
        [self.qzTableView reloadData];
    } failure:^(NSError *error) {
        [[QZHHUD HUD] textHUDWithMessage:error.userInfo[@"NSLocalizedDescription"] afterDelay:0.5];
        
    }];
    
}
- (void)uploadNickname:(NSString *)nickname{
    QZHWS(weakSelf)
    [[TuyaSmartUser sharedInstance] updateNickname:nickname success:^{
        [weakSelf.qzTableView reloadData];
        [[QZHHUD HUD] textHUDWithMessage:QZHLoaclString(@"handleSuccess") afterDelay:0.5];

    } failure:^(NSError *error) {
           [[QZHHUD HUD] textHUDWithMessage:error.userInfo[@"NSLocalizedDescription"] afterDelay:0.5];
    }];
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

    }
    return _manager;
}
@end
