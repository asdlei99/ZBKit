//
//  ZBImageDownloader.m
//  ZBKit
//
//  Created by NQ UEC on 17/1/20.
//  Copyright © 2017年 Suzhibin. All rights reserved.
//

#import "ZBImageDownloader.h"
#import "ZBCacheManager.h"
#import "NSFileManager+pathMethod.h"
#import "ZBConstants.h"
NSString *const ImageDefaultPath =@"AppImage";
static const NSInteger timeOut = 60*60;
@interface ZBImageDownloader ()


@end
@implementation ZBImageDownloader

+ (void)saveThePhotoAlbum:(UIImage *)image{
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    NSLog(@"image = %@, error = %@, contextInfo = %@", image, error, contextInfo);
    if (error) {
        
    }else{
        
    }
}

+ (void)downloadImageUrl:(NSString *)imageUrl{
    [self downloadImageUrl:imageUrl completion:nil];
}

+ (void)downloadImageUrl:(NSString *)imageUrl completion:(downloadCompletion)completion{
    [self downloadImageUrl:imageUrl path:[self imageFilePath] completion:completion];
}

+ (void)downloadImageUrl:(NSString *)imageUrl path:(NSString *)path completion:(downloadCompletion)completion{
    
    [[ZBCacheManager sharedManager]createDirectoryAtPath:path];
    
    NSString *imagePath=[[ZBCacheManager sharedManager]cachePathForKey:imageUrl inPath:path];
    
    if ([[ZBCacheManager sharedManager]isExistsAtPath:imagePath]&&[NSFileManager isTimeOutWithPath:imagePath timeOut:timeOut]==NO) {
        
        NSData *data=[NSData dataWithContentsOfFile:imagePath];
        
        UIImage *image=[UIImage imageWithData:data];
        
        completion(image);
        ZBKLog(@"image cache");
    }else{
        ZBKLog(@"image request");
        [self requestImageUrl:imageUrl completion:^(UIImage *image){

            [[ZBCacheManager sharedManager]setContent:image writeToFile:imagePath];
         
            completion(image);
        }];
    }
}

+ (void)requestImageUrl:(NSString *)imageUrl completion:(requestCompletion)completion{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSURL *url=[NSURL URLWithString:imageUrl];
        
        NSData *data=[NSData dataWithContentsOfURL:url];
        
        UIImage *image=[UIImage imageWithData:data];
 
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(image);
        });
    });
}

+ (NSUInteger)imageFileSize{
   return [[ZBCacheManager sharedManager]getFileSizeWithpath:[self imageFilePath]];
}

+ (NSUInteger)imageFileCount{
   return [[ZBCacheManager sharedManager]getFileCountWithpath:[self imageFilePath]];
}

+ (void)clearImageFile{
    [[ZBCacheManager sharedManager]clearDiskWithpath:[self imageFilePath]];
}


+ (NSString *)contentTypeForImageData:(NSData *)data {
    uint8_t c;
    [data getBytes:&c length:1];
    switch (c) {
        case 0xFF:
            return @"image/jpeg";
        case 0x89:
            return @"image/png";
        case 0x47:
            return @"image/gif";
        case 0x49:
        case 0x4D:
            return @"image/tiff";
        case 0x52:
            // R as RIFF for WEBP
            if ([data length] < 12) {
                return nil;
            }
            
            NSString *testString = [[NSString alloc] initWithData:[data subdataWithRange:NSMakeRange(0, 12)] encoding:NSASCIIStringEncoding];
            if ([testString hasPrefix:@"RIFF"] && [testString hasSuffix:@"WEBP"]) {
                return @"image/webp";
            }
            
            return nil;
    }
    return nil;
}

+ (NSString *)imageFilePath{
    NSString *AppImagePath =  [[[ZBCacheManager sharedManager]ZBKitPath]stringByAppendingPathComponent:ImageDefaultPath];
    return AppImagePath;
}

@end
