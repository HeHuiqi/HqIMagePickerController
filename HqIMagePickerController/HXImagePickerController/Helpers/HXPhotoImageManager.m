//
//  HXPhotoImageManager.m
//  HqIMagePickerController
//
//  Created by hehuiqi on 8/10/19.
//  Copyright © 2019 hehuiqi. All rights reserved.
//

#import "HXPhotoImageManager.h"

@implementation HXPhotoImageManager

+ (void)getPhotoLibraryAuthorization:(void(^)(BOOL success))handler{
    PHAuthorizationStatus status =  PHPhotoLibrary.authorizationStatus;
    switch (status) {
        case PHAuthorizationStatusAuthorized:
        {
            handler(YES);
        }
            break;
        case PHAuthorizationStatusRestricted:
        {
            handler(NO);
        }
        case PHAuthorizationStatusDenied:
        {
            handler(NO);
        }
            break;
        case PHAuthorizationStatusNotDetermined:
        {
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                dispatch_async(dispatch_get_main_queue(), ^{
                   
                    handler(status == PHAuthorizationStatusAuthorized);
                });
            }];
        }
            break;
        default:
            break;
    }
}
+ (void)getCameraAuthorization:(void(^)(BOOL success))handler{
    [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    
    AVAuthorizationStatus status =  [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    switch (status) {
        case AVAuthorizationStatusAuthorized:
        {
            handler(YES);
        }
            break;
        case AVAuthorizationStatusRestricted:
        {
            handler(NO);
        }
        case AVAuthorizationStatusDenied:
        {
            handler(NO);
        }
            break;
        case PHAuthorizationStatusNotDetermined:
        {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                handler(granted);
            }];
        }
            break;
        default:
            break;
    }
}

//获取相册
// albumTypes = @[@(HqAssetCollectionType)...];
+ (NSArray<PHAssetCollection *>*)getPhotoAlbums:(NSArray *)albumTypes
                                    filterEmpty:(BOOL)filterEmpty{
    NSMutableArray *albums = [[NSMutableArray alloc] initWithCapacity:0];
    if ([albumTypes containsObject:@(HqAssetCollectionTypeSmartAlbum)]) {
        /// 系统智能相册
        PHFetchResult<PHAssetCollection *> *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:(PHAssetCollectionTypeSmartAlbum) subtype:(PHAssetCollectionSubtypeSmartAlbumUserLibrary) options:nil];
        [smartAlbums enumerateObjectsUsingBlock:^(PHAssetCollection * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ( !filterEmpty || obj.estimatedAssetCount>0) {
                [albums addObject:obj];
            }
        }];
    }
  
   
    
    if ([albumTypes containsObject:@(HqAssetCollectionTypeUserCreateAlbum)]) {
        /// 用户创建的相册
        PHFetchResult<PHCollection *> * userAlbums = [PHAssetCollection fetchTopLevelUserCollectionsWithOptions:nil];
        [userAlbums enumerateObjectsUsingBlock:^(PHCollection * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            PHAssetCollection *assetCollection = (PHAssetCollection*)obj;
            if ( !filterEmpty || assetCollection.estimatedAssetCount>0) {
                [albums addObject:assetCollection];
            }
        }];
    }
    
    
  
    if ([albumTypes containsObject:@(HqAssetCollectionTypeSyncedAlbum)]) {
        /// iPhone中同步的相册
        PHFetchResult<PHAssetCollection *> *syncedAlbums = [PHAssetCollection fetchAssetCollectionsWithType:(PHAssetCollectionTypeAlbum) subtype:(PHAssetCollectionSubtypeAlbumSyncedAlbum) options:nil];
        [syncedAlbums enumerateObjectsUsingBlock:^(PHAssetCollection * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ( !filterEmpty || obj.estimatedAssetCount>0) {
                [albums addObject:obj];
            }
        }];
    }
   
    
    /// iCloud中同步的相册
    if ([albumTypes containsObject:@(HqAssetCollectionTypeCloudShared)]) {
        PHFetchResult<PHAssetCollection *> *iCloudShared = [PHAssetCollection fetchAssetCollectionsWithType:(PHAssetCollectionTypeAlbum) subtype:(PHAssetCollectionSubtypeAlbumCloudShared) options:nil];
        [iCloudShared enumerateObjectsUsingBlock:^(PHAssetCollection * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ( !filterEmpty || obj.estimatedAssetCount>0) {
                [albums addObject:obj];
            }
        }];
    }
   
    
    return albums;
}

/// 获取相册中的资源
///
/// - Parameters:
///   - assetCollection: 相册
///   - mediaTypes: 资源类型，默认[.image, .video]
/// - Returns: 资源集合
+ (PHFetchResult<PHAsset*>*)getPhotoAssets:(PHAssetCollection *)assetCollection
                                mediaTypes:(NSArray<NSNumber *> *)mediaTypes{
    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    if (mediaTypes.count == 0) {
        mediaTypes = @[@(PHAssetMediaTypeImage),@(PHAssetMediaTypeVideo)];
    }
    NSString *predicateFormat = @"";
    for (int i = 0 ; i<mediaTypes.count; i++) {
        PHAssetMediaType mediaType = mediaTypes[i].integerValue;
        if (i == mediaTypes.count -1) {
            predicateFormat = [NSString stringWithFormat:@"%@mediaType == %@",predicateFormat,@(mediaType)];
        }else{
            predicateFormat = [NSString stringWithFormat:@"%@mediaType == %@ || ",predicateFormat,@(mediaType)];

        }
    }
    if (predicateFormat.length>0) {
        options.predicate = [NSPredicate predicateWithFormat:predicateFormat];
    }
    options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
    PHFetchResult *phAssets = [PHAsset fetchAssetsInAssetCollection:assetCollection options:options];
    return phAssets;
}


+ (PHImageRequestID)requestImageAsynchronous:(PHAsset *)phAsset
                                  targetSize:(CGSize)targetSize contentMode:(PHImageContentMode)contentMode completion:(void(^)(UIImage *image , BOOL finished))completion{
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.synchronous = NO;
    options.networkAccessAllowed = YES;
    options.resizeMode = PHImageRequestOptionsResizeModeFast;
    options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    PHImageRequestID requsetId = [PHImageManager.defaultManager requestImageForAsset:phAsset targetSize:targetSize contentMode:contentMode options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        BOOL cancelled = [info[PHImageCancelledKey] boolValue];
        BOOL hasError = info[PHImageErrorKey] != nil;
        /// 请求结果是否不完全
        BOOL degraded = [info[PHImageResultIsDegradedKey] boolValue];
        /// 没有取消、没有错误、请求结果完整才算完成
        BOOL finished = !cancelled && !hasError && !degraded;
        //异步请求默认在主线程回调
        completion(result,finished);
    }];
 
    
    
    return requsetId;
}

+ (PHImageRequestID)requestImageDataAsynchronous:(PHAsset *)phAsset
                                      completion:(void(^)(NSData *data , BOOL finished))completion{
    
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.synchronous = NO;
    options.networkAccessAllowed = YES;
    options.resizeMode = PHImageRequestOptionsResizeModeFast;
    options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    
    PHImageRequestID requsetId = [PHImageManager.defaultManager requestImageDataForAsset:phAsset options:options resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
        BOOL cancelled = [info[PHImageCancelledKey] boolValue];
        BOOL hasError = info[PHImageErrorKey] != nil;
        /// 请求结果是否不完全
        BOOL degraded = [info[PHImageResultIsDegradedKey] boolValue];
        /// 没有取消、没有错误、请求结果完整才算完成
        BOOL finished = !cancelled && !hasError && !degraded;
        //异步请求默认在主线程回调
        completion(imageData,finished);
    }];
    return requsetId;
    
}

//获取视频资源
+ (PHImageRequestID)requestAVAsset:(PHAsset *)phAsset
                        completion:(void(^)(AVAsset *avAsset , NSString *videoPath))completion{
    PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
    
   PHImageRequestID requesID = [PHImageManager.defaultManager requestAVAssetForVideo:phAsset options:options resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
       dispatch_async(dispatch_get_main_queue(), ^{
           AVURLAsset *urlAsset = (AVURLAsset *)asset;
           completion(urlAsset,urlAsset.URL.path);
       });
    }];
    return requesID;
}
// 保存图片到相册
+ (void)saveImageToAlbum:(UIImage *)image
              completion:(void(^)(BOOL success))completion{
    
    [PHPhotoLibrary.sharedPhotoLibrary performChanges:^{
        [PHAssetChangeRequest creationRequestForAssetFromImage:image];
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(success);
        });
    }];
}
// 保存视频到相册
+ (void)saveVideoToAlbum:(NSString *)videoPath
              completion:(void(^)(BOOL success))completion{
    [PHPhotoLibrary.sharedPhotoLibrary performChanges:^{
        NSURL *videoURL = [NSURL URLWithString:videoPath];
        [PHAssetChangeRequest creationRequestForAssetFromVideoAtFileURL:videoURL];
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(success);
        });
    }];
}
// 取消图片请求
+ (void)cancelImageRequest:(PHImageRequestID)imageRequestID{
    [PHImageManager.defaultManager cancelImageRequest:imageRequestID];
}


//// 获取缩略图
+ (PHImageRequestID)requestThumbImage:(PHAsset *)phAsset
                           completion:(void(^)(UIImage *image , BOOL finished))completion{
    CGSize targetSize = CGSizeMake(200, 200);
    
    return [self requestImageAsynchronous:phAsset targetSize:targetSize contentMode:(PHImageContentModeAspectFill) completion:completion];
}
//获取预览图
+ (PHImageRequestID)requestPreviewImage:(PHAsset *)phAsset
                             completion:(void(^)(UIImage *image , BOOL finished))completion{
    
    
    CGSize targetSize = [self getPriviewSizeWithoriginSize:CGSizeMake(phAsset.pixelWidth, phAsset.pixelHeight) standard:0];
    
    return [self requestImageAsynchronous:phAsset targetSize:targetSize contentMode:(PHImageContentModeAspectFill) completion:completion];

}
//获取原图
+ (PHImageRequestID)requestOriginImage:(PHAsset *)phAsset
                            completion:(void(^)(UIImage *image , BOOL finished))completion{
    return [self requestImageDataAsynchronous:phAsset completion:^(NSData * _Nonnull data, BOOL finished) {
        UIImage *resultImage = [[UIImage alloc] initWithData:data];
        completion(resultImage,finished);
    }];
}
+ (CGSize)getPriviewSizeWithoriginSize:(CGSize)originSize standard:(CGFloat)standard{
    if (standard == 0) {
        standard = 1280.0;
    }
    
    CGFloat width = originSize.width;
    CGFloat height = originSize.height;
    CGFloat pixelScale = width / height;
    CGSize targetSize = CGSizeZero;
    if (width <= standard && height <= standard ){
        // 图片宽或者高均小于或等于standard时图片尺寸保持不变，不改变图片大小
        targetSize.width = width;
        targetSize.height = height;
    } else if (width > standard && height > standard) {
        // 宽以及高均大于standard，但是图片宽高比例大于(小于)2时，则宽或者高取小(大)的等比压缩至standard
        if (pixelScale > 2) {
            targetSize.width = standard * pixelScale;
            targetSize.height = standard;
        } else if (pixelScale < 0.5 ){
            targetSize.width = standard;
            targetSize.height = standard / pixelScale;
        } else if (pixelScale > 1) {
            targetSize.width = standard;
            targetSize.height = standard / pixelScale;
        } else {
            targetSize.width = standard * pixelScale;
            targetSize.height = standard;
        }
    } else {
        // 宽或者高大于standard，但是图片宽度高度比例小于或等于2，则将图片宽或者高取大的等比压缩至standard
        if (pixelScale <= 2 && pixelScale > 1) {
            targetSize.width = standard;
            targetSize.height = standard / pixelScale;
        } else if (pixelScale > 0.5 && pixelScale <= 1) {
            targetSize.width = standard * pixelScale;
            targetSize.height = standard;
        } else {
            targetSize.width = width;
            targetSize.height = height;
        }
    }
    return targetSize;
}

@end
