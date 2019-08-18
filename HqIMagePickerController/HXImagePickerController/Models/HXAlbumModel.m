//
//  HXAlbumModel.m
//  HqIMagePickerController
//
//  Created by hehuiqi on 8/10/19.
//  Copyright © 2019 hehuiqi. All rights reserved.
//

#import "HXAlbumModel.h"
#import "HXPhotoImageManager.h"

@implementation HXAlbumModel

- (NSString *)albumName{
    return self.assetCollection.localizedTitle;
}
- (NSString *)albumId{
    return self.assetCollection.localIdentifier;
}

- (instancetype)initWithAssetCollection:(PHAssetCollection *)assetCollection mediaTypes:(NSArray *)mediaTypes{
    self.assetCollection = assetCollection;
    if (mediaTypes.count == 0) {
        mediaTypes = @[@(PHAssetMediaTypeImage),@(PHAssetMediaTypeVideo)];
    }
    self.fetchAssets = [HXPhotoImageManager getPhotoAssets:assetCollection mediaTypes:mediaTypes];
    
    return self;
}
- (void)requestCoverImage:(void (^)(HXAlbumModel * _Nullable model , UIImage * _Nullable coverImage))completion{
    if (self.coverImage) {
        completion(self,self.coverImage);
    }else{
        //todo
        PHAsset *firstAsset = self.fetchAssets.firstObject;
        if (firstAsset == nil ) {
            completion(self,nil);
            return;
        }
        [HXPhotoImageManager requestThumbImage:firstAsset completion:^(UIImage * _Nullable image, BOOL finished) {
            self.coverImage = image;
            completion(self,image);
        }];
    }
}
- (BOOL)equalToAlbumModel:(HXAlbumModel *)rhs{
    return [self.albumId isEqualToString:rhs.albumId];
}
@end
