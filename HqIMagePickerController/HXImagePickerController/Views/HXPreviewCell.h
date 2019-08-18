//
//  HXPreviewCell.h
//  HqIMagePickerController
//
//  Created by hehuiqi on 8/11/19.
//  Copyright © 2019 hehuiqi. All rights reserved.
//

#import <UIKit/UIKit.h>

#define HXPreviewCellID @"HXPreviewCell"
#import "HXImageModel.h"
@class HXPreviewCell;
typedef void(^HXPreviewCellSingleTapCallback)(HXPreviewCell *cell);
NS_ASSUME_NONNULL_BEGIN

@interface HXPreviewCell : UICollectionViewCell<UIScrollViewDelegate>


@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) UIActivityIndicatorView *activityView;
@property (nonatomic,strong) UIScrollView *scrollView;


@property (nonatomic,strong) HXImageModel *imageModel;
@property (nonatomic,copy) HXPreviewCellSingleTapCallback singleTapCallback;


@end

NS_ASSUME_NONNULL_END
