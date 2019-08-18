//
//  HqShowSelecteImageCell.m
//  HqIMagePickerController
//
//  Created by hehuiqi on 8/18/19.
//  Copyright © 2019 hehuiqi. All rights reserved.
//

#import "HqShowSelecteImageCell.h"

@implementation HqShowSelecteImageCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}
- (void)setup{
    _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    _imageView.clipsToBounds = YES;
    [self addSubview:_imageView];
}
- (void)setImage:(UIImage *)image{
    _image = image;
    if (_image) {
        self.imageView.image = image;
    }
}
- (void)layoutSubviews{
    [super layoutSubviews];
    self.imageView.frame = self.bounds;
}

@end
