//
//  HXImageNavigationView.m
//  HqIMagePickerController
//
//  Created by hehuiqi on 8/11/19.
//  Copyright © 2019 hehuiqi. All rights reserved.
//

#import "HXImageNavigationView.h"

@implementation HXImageNavigationView

- (instancetype)initWithFrame:(CGRect)frame contentHeight:(CGFloat)contentHeight{
    if (self = [super initWithFrame:frame]) {
        self.contentHeight = contentHeight;
        [self setup];
    }
    return self;
}
- (void)setup{
    self.backgroundColor = [UIColor blackColor];
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.backBtn];
    [self.contentView addSubview:self.selectBtn];
}


- (void)setMainTintColor:(UIColor *)mainTintColor{
    _mainTintColor = mainTintColor;
    if (_mainTintColor) {
        self.selectBtn.mainTintColor = mainTintColor;
    }
}
- (HXSelectButton *)selectBtn{
    if (!_selectBtn) {
        _selectBtn = [[HXSelectButton alloc] init];
        _selectBtn.imageSize = CGSizeMake(30, 30);
    }
    return _selectBtn;
}
- (UIButton *)backBtn{

    if (!_backBtn) {
        _backBtn = [[UIButton alloc] init];
        [_backBtn setImage:[UIImage imageNamed:@"HXImagePickerController.bundle/hxip_back"] forState:UIControlStateNormal];
    }
    return _backBtn;
}
- (UIView *)contentView{
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor blackColor];
    }
    return _contentView;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat contentY = self.bounds.size.height - self.contentHeight;
    self.contentView.frame = CGRectMake(0, contentY, self.bounds.size.width, self.contentHeight);
    CGFloat backW = 44;
    CGFloat backY = (self.contentHeight- backW)/2.0;
    self.backBtn.frame = CGRectMake(0, backY, backW, backW);
    
    CGFloat selectX = self.bounds.size.width - backW-10;
    self.selectBtn.frame = CGRectMake(selectX, backY, backW, backW);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
