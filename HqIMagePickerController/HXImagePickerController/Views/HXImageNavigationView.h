//
//  HXImageNavigationView.h
//  HqIMagePickerController
//
//  Created by hehuiqi on 8/11/19.
//  Copyright © 2019 hehuiqi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HXSelectButton.h"
NS_ASSUME_NONNULL_BEGIN

@interface HXImageNavigationView : UIView

@property (nonatomic,strong) UIColor *mainTintColor;
@property (nonatomic,strong) HXSelectButton *selectBtn;
@property (nonatomic,strong) UIButton *backBtn;
@property (nonatomic,strong) UIView *contentView;
@property (nonatomic,assign) CGFloat contentHeight;
- (instancetype)initWithFrame:(CGRect)frame contentHeight:(CGFloat)contentHeight;

@end

NS_ASSUME_NONNULL_END
