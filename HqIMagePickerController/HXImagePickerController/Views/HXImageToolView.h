//
//  HXImageToolView.h
//  HqIMagePickerController
//
//  Created by hehuiqi on 8/18/19.
//  Copyright © 2019 hehuiqi. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HXImageToolView : UIView

@property (nonatomic,strong) UIColor *mainTintColor;
@property (nonatomic,assign) NSUInteger selectedImageCount;

@property (nonatomic,strong) UIButton *confirmBtn;


@end

NS_ASSUME_NONNULL_END
