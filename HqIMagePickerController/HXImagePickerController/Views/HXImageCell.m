//
//  HXImageCell.m
//  HqIMagePickerController
//
//  Created by hehuiqi on 8/10/19.
//  Copyright © 2019 hehuiqi. All rights reserved.
//

#import "HXImageCell.h"

@implementation HXImageCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}
- (void)setup{
    [self addSubview:self.imageView];
    [self addSubview:self.selectBtn];
    [self addSubview:self.maskForegroundView];
}
- (void)setImageModel:(HXImageModel *)imageModel{
    _imageModel = imageModel;
    if (_imageModel) {
        [imageModel requestThumbImage:^(HXImageModel * _Nonnull model, UIImage * _Nonnull thumbImage) {
//            [self.selectBtn setSelectedIndex:imageModel.selectedIndex];
            [self.selectBtn setSelectedIndex:imageModel.selectedIndex animation:NO];
            if ([imageModel equalToImageModel:model] ) {
                self.imageView.image = thumbImage;
            }
        }];
        if (imageModel.mediaType == PHAssetMediaTypeVideo) {
            self.videoView.hidden = NO;
            self.videoDurationLabel.text = @"11:11";
        }else{
            self.videoView.hidden = YES;
            self.videoDurationLabel.text = @"";
        }
        [self.videoDurationLabel sizeToFit];
        self.editedIconImageView.hidden = !imageModel.isEdited;
        self.maskForegroundView.hidden = imageModel.canSelect;
    }
}
- (void)setMainTintColor:(UIColor *)mainTintColor{
    //todo
    _mainTintColor = mainTintColor;
    self.selectBtn.mainTintColor = mainTintColor;
}

- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _imageView.backgroundColor = [UIColor whiteColor];
        _imageView.clipsToBounds = YES;
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _imageView;
}
- (HXSelectButton *)selectBtn{
    if (!_selectBtn) {
        _selectBtn = [[HXSelectButton alloc] init];
        _selectBtn.imageSize = CGSizeMake(24, 24);
        [_selectBtn addTarget:self action:@selector(selectBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectBtn;
}
- (void)selectBtnClicked{
    NSLog(@"selectBtnClicked==");
    if (self.selectBtnClickedCallback) {
        self.selectBtnClickedCallback(self);
    }
}
- (UIView *)maskForegroundView{
    if (!_maskForegroundView) {
        _maskForegroundView = [[UIView alloc] init];
        _maskForegroundView.backgroundColor = [UIColor colorWithWhite:255.0/255.0 alpha:0.7];
        _maskForegroundView.hidden = YES;
    }
    return _maskForegroundView;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    self.imageView.frame = self.bounds;
    CGFloat btnX = self.bounds.size.width - 40;
    self.selectBtn.frame = CGRectMake(btnX, 0, 40, 40);
    self.maskForegroundView.frame = self.bounds;
}
@end
