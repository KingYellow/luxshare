//
//  PhotosListVC.h
//  luxshare
//
//  Created by 黄振 on 2020/7/13.
//  Copyright © 2020 KingYellow. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
typedef void (^selectResult)(NSArray *selectArr);
@interface PhotosListVC : UIViewController
@property (strong, nonatomic)NSArray *listArr;
@property (copy, nonatomic)selectResult selecctResultBlock;
- (void)selectAllVideosOrPhotos:(BOOL) select;
- (void)getphotosList;
@end

NS_ASSUME_NONNULL_END
