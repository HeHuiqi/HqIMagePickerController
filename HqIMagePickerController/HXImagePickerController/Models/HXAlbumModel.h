//
//  HXAlbumModel.h
//  HqIMagePickerController
//
//  Created by hehuiqi on 8/10/19.
//  Copyright © 2019 hehuiqi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
NS_ASSUME_NONNULL_BEGIN

@interface HXAlbumModel : NSObject

@property (nonatomic,strong) PHAssetCollection *assetCollection;

@property (nonatomic,copy) NSString *albumName;
@property (nonatomic,copy) NSString *albumId;
@property (nonatomic,strong) PHFetchResult<PHAsset *> *fetchAssets;
@property (nonatomic,strong) UIImage *coverImage;

- (instancetype)initWithAssetCollection:(PHAssetCollection *)assetCollection mediaTypes:(NSArray *)mediaTypes;
- (void)requestCoverImage:(void(^)(HXAlbumModel *model,UIImage *coverImage))completion;
- (BOOL)equalToAlbumModel:(HXAlbumModel *)rhs;

@end

NS_ASSUME_NONNULL_END
