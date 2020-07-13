//
//  RoomDetailVC.h
//  luxshare
//
//  Created by 黄振 on 2020/7/2.
//  Copyright © 2020 KingYellow. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RoomDetailVC : UIViewController
@property (strong, nonatomic)TuyaSmartHomeModel *homeModel;
@property (strong, nonatomic)TuyaSmartRoomModel *roomModel;
@property (strong, nonatomic)NSString *roomName;
@end

NS_ASSUME_NONNULL_END
