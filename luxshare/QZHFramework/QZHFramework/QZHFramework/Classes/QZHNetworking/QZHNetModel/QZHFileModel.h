//
//  QZHRespModel.h
//  QZH
//
//  Created by 米翊米 on 2018/5/25.
//  Copyright © 2018年 米翊米. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QZHMimeType.h"

@interface QZHFileModel : NSObject

//文件数据
@property(nonatomic, strong) NSData *fileData;
//文件数据对应字段
@property(nonatomic, copy) NSString *fileKey;
//文件名称
@property(nonatomic, copy) NSString *fileName;

///以下可自动获取
//文件类型
@property(nonatomic, copy) NSString *fileType;
//文件名后缀
@property(nonatomic, copy) NSString *fileExp;

@end
