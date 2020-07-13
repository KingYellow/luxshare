//
//  QZHMimeType.h
//  QZH
//
//  Created by 米一米 on 2018/10/26.
//  Copyright © 2018年 米翊米. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QZHMimeType : NSObject

/// Mime type string representation. For example "application/pdf"
@property (nonatomic, strong) NSString *mime;
/// Mime type extension. For example ".pdf"
@property (nonatomic, strong) NSString *ext;
///获取文件类型MimeType和拓展名称ext
+ (void)matches:(NSData *)data compelete:(void (^)(QZHMimeType *mime))result;

@end
