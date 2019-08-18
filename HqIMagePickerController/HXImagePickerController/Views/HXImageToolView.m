//
//  HXImageToolView.m
//  HqIMagePickerController
//
//  Created by hehuiqi on 8/18/19.
//  Copyright © 2019 hehuiqi. All rights reserved.
//

#import "HXImageToolView.h"
#import "HXImagePickerConfig.h"

@implementation HXImageToolView
- (void)dealloc{
    [self removeNotifications];
}
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}
- (void)setup{
    self.backgroundColor = [UIColor blackColor];
    [self addSubview:self.confirmBtn];
    [self registerNotifications];
}
- (void)registerNotifications{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectedImageModelsDidChangeed:) name:HXImagePickerSelectedImageModelsDidChanged object:nil];
}
- (void)selectedImageModelsDidChangeed:(NSNotification *)nofity{
    NSArray *models = (NSArray *)nofity.object;
    self.selectedImageCount = models.count;
}
- (void)removeNotifications{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)setMainTintColor:(UIColor *)mainTintColor{
    _mainTintColor = mainTintColor;
    if (_mainTintColor) {
        self.confirmBtn.backgroundColor = [mainTintColor colorWithAlphaComponent:0.7];
;
    }
}
- (void)setSelectedImageCount:(NSUInteger)selectedImageCount{
    _selectedImageCount = selectedImageCount;
    BOOL confirmBtnEnable = NO;
    NSString *confitmBtnTitle = @"完成";
    UIColor *bgColror = [self.mainTintColor colorWithAlphaComponent:0.7];
    if (_selectedImageCount>0) {
        confitmBtnTitle = [NSString stringWithFormat:@"完成(%@)",@(selectedImageCount)];
        confirmBtnEnable = YES;
        bgColror = self.mainTintColor;
    }
    self.confirmBtn.enabled = confirmBtnEnable;
    [self.confirmBtn setTitle:confitmBtnTitle forState:UIControlStateNormal];
    self.confirmBtn.backgroundColor = bgColror;

}
- (UIButton *)confirmBtn{
    
    if (!_confirmBtn) {
        _confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_confirmBtn setTitle:@"完成" forState:UIControlStateNormal];
        UIColor *titleColor = [UIColor whiteColor];
        [_confirmBtn setTitleColor:titleColor forState:UIControlStateNormal];
        UIColor *disableColor = [titleColor colorWithAlphaComponent:0.7];
        [_confirmBtn setTitleColor:disableColor forState:UIControlStateDisabled];

        _confirmBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _confirmBtn.layer.cornerRadius = 5;
        _confirmBtn.enabled = NO;
        
    }
    return _confirmBtn;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat confirmW = 65;
    CGFloat confirmH = 35;
    CGFloat confirmX = self.bounds.size.width - confirmW - 15;
    CGFloat confirmY = (self.bounds.size.height - confirmH)/2.0;
    self.confirmBtn.frame = CGRectMake(confirmX, confirmY, confirmW, confirmH);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
