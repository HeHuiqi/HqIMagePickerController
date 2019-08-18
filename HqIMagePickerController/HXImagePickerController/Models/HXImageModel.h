//
//  HXImageModel.h
//  HqIMagePickerController
//
//  Created by hehuiqi on 8/10/19.
//  Copyright © 2019 hehuiqi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

NS_ASSUME_NONNULL_BEGIN

@interface HXImageModel : NSObject


@property (nonatomic,strong) PHAsset *phAsset;
@property (nonatomic,copy) NSString *assetId;
@property (nonatomic,assign) PHAssetMediaType mediaType;
@property (nonatomic,strong) UIImage *thumbImage;
@property (nonatomic,assign) BOOL isSelected;
@property (nonatomic,assign) NSInteger selectedIndex;

@property (nonatomic,assign) BOOL canSelect;
@property (nonatomic,strong) UIImage *editedImage;
@property (nonatomic,assign) BOOL isEdited;

- (instancetype)initWithPHAsset:(PHAsset *)phAsset;
- (void)requestThumbImage:(void(^)(HXImageModel *model,UIImage *thumbImage))completion;
+ (BOOL)hxImageModel:(HXImageModel *)lhs equalToImageModel:(HXImageModel *)rhs;

- (BOOL)equalToImageModel:(HXImageModel *)rhs;



@end

NS_ASSUME_NONNULL_END
