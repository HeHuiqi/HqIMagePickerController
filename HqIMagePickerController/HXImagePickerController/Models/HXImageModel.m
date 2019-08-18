//
//  HXImageModel.m
//  HqIMagePickerController
//
//  Created by hehuiqi on 8/10/19.
//  Copyright © 2019 hehuiqi. All rights reserved.
//

#import "HXImageModel.h"
#import "HXPhotoImageManager.h"

@implementation HXImageModel

- (instancetype)initWithPHAsset:(PHAsset *)phAsset{
    if (self = [super init]) {
        self.phAsset = phAsset;
        self.canSelect = YES;
        self.selectedIndex = -1;
        self.isSelected = NO;
        self.isEdited = NO;
    }
    return self;
}

- (NSString *)assetId{
    return self.phAsset.localIdentifier;
}
- (PHAssetMediaType)mediaType{
    return self.phAsset.mediaType;
}

- (void)setSelectedIndex:(NSInteger)selectedIndex{
    _selectedIndex = selectedIndex;
    self.isSelected = selectedIndex>=0;
}
- (void)setEditedImage:(UIImage *)editedImage{
    _editedImage = editedImage;
    self.thumbImage = editedImage;
    self.isEdited = YES;
}

- (void)requestThumbImage:(void (^)(HXImageModel * _Nullable model , UIImage * _Nullable thumbImage))completion{
    if (self.thumbImage) {
//        NSLog(@"self.thumbImage == %@",self.thumbImage);

        completion(self,self.thumbImage);
    }else{
        //todo
        [HXPhotoImageManager requestThumbImage:self.phAsset completion:^(UIImage * _Nullable image, BOOL finished) {
            self.thumbImage = image;
//            NSLog(@"requestThumbImage == %@",image);
            completion(self,image);
        }];
    }
}
+ (BOOL)hxImageModel:(HXImageModel *)lhs equalToImageModel:(HXImageModel *)rhs{
    return [lhs.assetId isEqualToString:rhs.assetId];
}

- (BOOL)equalToImageModel:(HXImageModel *)rhs{
    return [self.assetId isEqualToString:rhs.assetId];
}

@end
