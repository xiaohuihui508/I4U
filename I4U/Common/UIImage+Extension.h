//
//  UIImage+Extension.h
//  ISS-ISPS-USER
//
//  Created by isoft on 2018/12/5.
//  Copyright © 2018 isoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (Extension)

+ (UIImage *)resizableImageWithName:(NSString *)imageName size:(CGSize )size;
- (UIImage *)clipImageWithRadius:(CGFloat)radius;

- (UIImage *)createImageWithColor:(UIColor *)color;
+ (UIImage *)getNewImageWithName:(NSString *)imageName size:(CGSize )size;
+ (UIImage *)resizableRightImageWithName:(NSString *)imageName size:(CGSize )size;
+ (UIImage *)fixOrientation:(UIImage *)aImage;

+ (UIImage *)resizableImageWithString:(NSString *)imageStr size:(CGSize )size;
+ (UIImage *)getImageWithUrlStr:(NSString *)str;
/** 该方法传入一个UIColor就可以获得一张大小为1.0 × 1.0的纯色图片 */
+ (UIImage *)imageWithColor:(UIColor *)color;

/** 图片图片转成Base64字符串 */
- (NSString *)imageToBase64String;

/** 图片等比例压缩 */
- (UIImage *) imageCompressForSize:(UIImage *)sourceImage targetSize:(CGSize)size;
/** 压缩图片到指定大小 */
- (UIImage *)compressOriginalImage:(UIImage *)image toMaxDataSizeKBytes:(CGFloat)size;

/** 根据Url获取图片尺寸 */
+ (CGSize)getImageSizeWithURL:(id)URL;

@end

NS_ASSUME_NONNULL_END
