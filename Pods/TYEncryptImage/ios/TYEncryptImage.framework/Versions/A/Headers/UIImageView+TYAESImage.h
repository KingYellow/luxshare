//
//  UIImageView+TYAESImage.h
//  TYEncryptImage
//
//  Created by TuyaInc on 2019/5/31.
//

#import <UIKit/UIKit.h>
#import "TYEncryptImageDefine.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIImageView (TYAESImage)

/// Set the imageView `image` with an `imageUrl` and  an 'encrypt key string'.
/// @param imagePath image's URL
/// @param encryptKey image's encrypt key string
/// @param placeholderImage placeholder image before network request response
- (void)ty_setAESImageWithPath:(NSString *)imagePath
                    encryptKey:(NSString *)encryptKey
              placeholderImage:(UIImage *)placeholderImage;

/// Set the imageView `image` with an `imageUrl` and  an 'encrypt key string'.
/// @param imagePath image's URL
/// @param encryptKey image's encrypt key string
- (void)ty_setAESImageWithPath:(NSString *)imagePath
                    encryptKey:(NSString *)encryptKey;

/// Set the imageView `image` with an `imageUrl` and  an 'encrypt key string'.
/// @param imagePath image's URL
/// @param encryptKey image's encrypt key string
/// @param completedBlock A block called when operation has been completed. This block has no return value and takes the requested UIImage as first parameter. The second parameter is the original image url. The third parameter is a Boolean indicating if the image was retrieved from the local cache or from the network. The fourth parameter is current download stage of the download image. In case of error the image parameter is nil and the fifth parameter may contain an NSError.
- (void)ty_setAESImageWithPath:(NSString *)imagePath
                    encryptKey:(NSString *)encryptKey
                     completed:(nullable TYEncryptWebImageCompletionBlock)completedBlock;

@end

NS_ASSUME_NONNULL_END
