//
//  QZHMimeType.m
//  QZH
//
//  Created by 米一米 on 2018/10/26.
//  Copyright © 2018年 米翊米. All rights reserved.
//

#import "QZHMimeType.h"
#import <MobileCoreServices/MobileCoreServices.h>

@implementation QZHMimeType

///获取文件类型MimeType和拓展名称ext
+ (void)matches:(NSData *)data compelete:(void (^)(QZHMimeType *mime))result {
    NSString *tmpFilePath = [NSTemporaryDirectory() stringByAppendingString:@"tmpfile"];
    [[NSFileManager defaultManager] removeItemAtPath:tmpFilePath error:nil];
    [data writeToFile:tmpFilePath atomically:YES];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:tmpFilePath]) {
        [[[NSURLSession sharedSession] dataTaskWithURL:[NSURL fileURLWithPath:tmpFilePath] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            QZHMimeType *mime = [[QZHMimeType alloc] init];
            mime.mime = response.MIMEType;
            mime.ext = @".";
            mime.ext = [mime.ext stringByAppendingString:[response.suggestedFilename pathExtension]];
            if (!mime.mime) {
                mime.mime = @"application/octet-stream";
            }
            if (result) {
                result(mime);
            }
        }] resume];
    }
}

@end
