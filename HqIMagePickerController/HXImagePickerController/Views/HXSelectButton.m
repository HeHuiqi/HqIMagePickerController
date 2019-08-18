//
//  HXSelectButton.m
//  HqIMagePickerController
//
//  Created by hehuiqi on 8/10/19.
//  Copyright © 2019 hehuiqi. All rights reserved.
//

#import "HXSelectButton.h"

@implementation HXSelectButton
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}
- (void)setup{
    [self addSubview:self.sortLabel];
    [self addSubview:self.selectImageView];
}
- (UIImageView *)selectImageView{
    if (!_selectImageView) {
        _selectImageView = [[UIImageView alloc] init];
        _selectImageView.image = [UIImage imageNamed:@"HXImagePickerController.bundle/hxip_select"];
    }
    return _selectImageView;
}
- (UILabel *)sortLabel{
    if (!_sortLabel) {
        _sortLabel = [[UILabel alloc] init];
        _sortLabel.backgroundColor = [UIColor redColor];
        _sortLabel.textColor = [UIColor whiteColor];
        _sortLabel.layer.masksToBounds = YES;
        _sortLabel.hidden = YES;
        _sortLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _sortLabel;
}
- (void)setMainTintColor:(UIColor *)mainTintColor{
    _mainTintColor = mainTintColor;
    if (_mainTintColor) {
        self.sortLabel.backgroundColor = mainTintColor;
    }
}
- (void)setImageSize:(CGSize)imageSize{
    _imageSize = imageSize;
    self.sortLabel.font = [UIFont systemFontOfSize:imageSize.width/2.0];
    self.sortLabel.frame = CGRectMake(0, 0, imageSize.width, imageSize.height);
    self.sortLabel.layer.cornerRadius = imageSize.width/2.0;
    self.selectImageView.frame = CGRectMake(0, 0, imageSize.width, imageSize.height);
    [self setNeedsLayout];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    CGPoint center = CGPointMake(self.bounds.size.width/2.0, self.bounds.size.height/2.0);
    self.sortLabel.center = center;
    self.selectImageView.center  = center;
    
}
- (void)setSelectedIndex:(NSInteger)index animation:(BOOL)animation{
    self.selectImageView.hidden = index>=0;
    self.sortLabel.hidden = index<0;
    self.sortLabel.text = [NSString stringWithFormat:@"%@",@(index+1)];
    if (animation) {
        self.sortLabel.transform = CGAffineTransformMakeScale(0.1, 0.1);
        [UIView animateWithDuration:0.3 animations:^{
            self.sortLabel.transform = CGAffineTransformMakeScale(1.0, 1.0);
        }];
    }

}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
