//
//  HXPreviewCell.m
//  HqIMagePickerController
//
//  Created by hehuiqi on 8/11/19.
//  Copyright © 2019 hehuiqi. All rights reserved.
//

#import "HXPreviewCell.h"
#import "HXPhotoImageManager.h"

@implementation HXPreviewCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}
- (void)setup{
    [self addSubview:self.scrollView];
    [self.scrollView addSubview:self.imageView];
    [self addSubview:self.activityView];
    [self addGestures];
}

- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.maximumZoomScale = 3.0;
        _scrollView.bouncesZoom = YES;
        _scrollView.delegate = self;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.alwaysBounceVertical = NO;
        if (@available(iOS 11.0, *)) {
            _scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _scrollView;
}
- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _imageView.clipsToBounds = YES;
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imageView;
}
- (UIActivityIndicatorView *)activityView{
    if (!_activityView) {
        _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyleWhiteLarge)];
        _activityView.center = self.center;
    }
    return _activityView;
}
- (void)addGestures{
    UITapGestureRecognizer *singleTap  =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
    
    UITapGestureRecognizer *doubleTap  =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
    doubleTap.numberOfTapsRequired = 2;
    
    [singleTap requireGestureRecognizerToFail:doubleTap];
    [self.scrollView addGestureRecognizer:singleTap];
    [self.scrollView addGestureRecognizer:doubleTap];

    
}
- (void)singleTap:(UITapGestureRecognizer *)tap{
    if (self.singleTapCallback) {
        self.singleTapCallback(self);
    }
}
- (void)doubleTap:(UITapGestureRecognizer *)tap{
    //todo
    
//    if (scrollView.zoomScale > 1.0) {
//        // 状态还原
//        scrollView.setZoomScale(1.0, animated: true)
//    } else {
//        let touchPoint = tapGesture.location(in: imageView)
//        let newZoomScale = scrollView.maximumZoomScale
//        let width = frame.width / newZoomScale
//        let height = frame.height / newZoomScale
//        scrollView.zoom(to: CGRect(x: touchPoint.x - width / 2, y: touchPoint.y - height / 2, width: width, height: height), animated: true)
//    }
    
        if (self.scrollView.zoomScale > 1.0) {
            // 状态还原
            [self.scrollView setZoomScale:1.0 animated:YES];
        } else {
            CGPoint touchPoint = [tap locationInView:self.imageView];
            CGFloat newZoomScale = self.scrollView.maximumZoomScale;
            CGFloat width = self.frame.size.width / newZoomScale;
            CGFloat height = self.frame.size.height / newZoomScale;
            CGRect rect = CGRectMake(touchPoint.x - width / 2, touchPoint.y - height/2, width, height);
            [self.scrollView zoomToRect:rect animated:YES];
        }
    
}

#pragma mark - UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return self.imageView;
}
- (void)scrollViewDidZoom:(UIScrollView *)scrollView{
    CGFloat offsetX = (scrollView.frame.size.width > scrollView.contentSize.width) ? (scrollView.frame.size.width - scrollView.contentSize.width) / 2 : 0.0;
    CGFloat offsetY = (scrollView.frame.size.height > scrollView.contentSize.height) ? (scrollView.frame.size.height - scrollView.contentSize.height) / 2 : 0.0;
    _imageView.center = CGPointMake(scrollView.contentSize.width / 2 + offsetX, scrollView.contentSize.height / 2 + offsetY);
}

- (void)setImageModel:(HXImageModel *)imageModel{
    _imageModel = imageModel;
    if (_imageModel) {
        self.imageView.image = imageModel.thumbImage;
        if (!imageModel.editedImage) {
            [self.activityView startAnimating];
            
            [HXPhotoImageManager requestPreviewImage:imageModel.phAsset completion:^(UIImage * _Nonnull image, BOOL finished) {
                self.imageView.image = image;
                [self.activityView stopAnimating];
                [self resizeImageView];
            }];
            [self resizeImageView];
        }
    }
}
- (void)resizeImageView{
    
    self.scrollView.zoomScale = 1;
    self.imageView.frame = [self calculateContainerFrame:self.imageView.image];
    CGFloat contentH = MAX(self.imageView.frame.size.height, self.scrollView.bounds.size.height);
    self.scrollView.contentSize = CGSizeMake(self.bounds.size.width, contentH);
    
}
- (CGRect )calculateContainerFrame:(UIImage *)image{
    CGRect containerFrame = CGRectZero;
    if (image) {
        containerFrame = [UIScreen mainScreen].bounds;
        CGFloat scaleH = image.size.height/image.size.width;
        CGFloat height = floor(containerFrame.size.width*scaleH);
        containerFrame.size.height = height;
        
        CGFloat scrollScale = self.scrollView.frame.size.height / containerFrame.size.width;
        if (scaleH < scrollScale) {
            containerFrame.origin.y = (self.bounds.size.height - height) / 2;
        }
    }
    
    return containerFrame;
}
@end
