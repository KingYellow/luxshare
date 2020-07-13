//
//  QZHFileModel.m
//  QZH
//
//  Created by 米翊米 on 2018/5/25.
//  Copyright © 2018年 米翊米. All rights reserved.
//

#import "QZHFileModel.h"

#define QZHWS(weakSelf)            __weak __typeof(&*self)weakSelf = self;

@implementation QZHFileModel

- (void)setFileData:(NSData *)fileData {
    _fileData = fileData;
    
    QZHWS(weakSelf);
    [QZHMimeType matches:fileData compelete:^(QZHMimeType *mime) {
        weakSelf.fileType = mime.mime;
        weakSelf.fileExp = mime.ext;
    }];
}

@end
