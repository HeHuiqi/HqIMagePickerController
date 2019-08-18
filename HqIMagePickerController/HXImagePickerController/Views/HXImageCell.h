//
//  HXImageCell.h
//  HqIMagePickerController
//
//  Created by hehuiqi on 8/10/19.
//  Copyright © 2019 hehuiqi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HXImageModel.h"
#define HXImageModelId  @"HXImageModel"
#import "HXSelectButton.h"

NS_ASSUME_NONNULL_BEGIN
@class HXImageCell;
typedef void(^HXImageCellSelectBtnClickedCallback)(HXImageCell *cell);

@interface HXImageCell : UICollectionViewCell


@property (nonatomic,strong) HXImageModel *imageModel;
@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) UIView *videoView;
@property (nonatomic,strong) UIImageView *editedIconImageView;
@property (nonatomic,strong) UIImageView *videoIconImageView;
@property (nonatomic,strong) UILabel *videoDurationLabel;
@property (nonatomic,strong) HXSelectButton *selectBtn;
@property (nonatomic,strong) UIView *maskForegroundView;

@property (nonatomic,strong) UIColor *mainTintColor;

@property (nonatomic,copy) HXImageCellSelectBtnClickedCallback selectBtnClickedCallback;









@end

NS_ASSUME_NONNULL_END
