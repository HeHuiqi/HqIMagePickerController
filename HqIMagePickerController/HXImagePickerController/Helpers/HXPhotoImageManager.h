//
//  HXPhotoImageManager.h
//  HqIMagePickerController
//
//  Created by hehuiqi on 8/10/19.
//  Copyright © 2019 hehuiqi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

typedef NS_ENUM(NSInteger,HqAssetCollectionType) {
    HqAssetCollectionTypeSmartAlbum =  PHAssetCollectionTypeSmartAlbum,
    HqAssetCollectionTypeSyncedAlbum = PHAssetCollectionSubtypeAlbumSyncedAlbum,
    HqAssetCollectionTypeUserCreateAlbum = 100,
    HqAssetCollectionTypeCloudShared  = PHAssetCollectionSubtypeAlbumCloudShared,
    
};
NS_ASSUME_NONNULL_BEGIN

@interface HXPhotoImageManager : NSObject

+ (void)getPhotoLibraryAuthorization:(void(^)(BOOL success))handler;

+ (void)getCameraAuthorization:(void(^)(BOOL success))handler;

+ (NSArray<PHAssetCollection *>*)getPhotoAlbums:(NSArray *)albumTypes
                                    filterEmpty:(BOOL)filterEmpty;

// mediaTypes= <PHAssetMediaType>
+ (PHFetchResult<PHAsset*>*)getPhotoAssets:(PHAssetCollection *)assetCollection
                                mediaTypes:(NSArray<NSNumber *> *)mediaTypes;

+ (PHImageRequestID)requestImageAsynchronous:(PHAsset *)phAsset
                                  targetSize:(CGSize)targetSize contentMode:(PHImageContentMode)PHImageContentMode completion:(void(^)(UIImage *image , BOOL finished))completion;
//
+ (PHImageRequestID)requestImageDataAsynchronous:(PHAsset *)phAsset
                                      completion:(void(^)(NSData *data , BOOL finished))completion;

//获取视频资源
+ (PHImageRequestID)requestAVAsset:(PHAsset *)phAsset
                        completion:(void(^)(AVAsset *avAsset , NSString *videoPath))completion;

// 保存图片到相册
+ (void)saveImageToAlbum:(UIImage *)image
              completion:(void(^)(BOOL success))completion;

// 保存视频到相册
+ (void)saveVideoToAlbum:(NSString *)videoPath
              completion:(void(^)(BOOL success))completion;

// 取消图片请求
+ (void)cancelImageRequest:(PHImageRequestID)imageRequestID;

//// 获取缩略图
+ (PHImageRequestID)requestThumbImage:(PHAsset *)phAsset
                           completion:(void(^)(UIImage *image , BOOL finished))completion;
//获取预览图
+ (PHImageRequestID)requestPreviewImage:(PHAsset *)phAsset
                             completion:(void(^)(UIImage *image , BOOL finished))completion;
//获取原图
+ (PHImageRequestID)requestOriginImage:(PHAsset *)phAsset
                             completion:(void(^)(UIImage *image , BOOL finished))completion;
//standard 默认1280
+ (CGSize)getPriviewSizeWithoriginSize:(CGSize)originSize standard:(CGFloat)standard;
@end

NS_ASSUME_NONNULL_END
