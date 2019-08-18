//
//  HXSelectButton.h
//  HqIMagePickerController
//
//  Created by hehuiqi on 8/10/19.
//  Copyright © 2019 hehuiqi. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HXSelectButton : UIButton

@property (nonatomic,strong) UIColor *mainTintColor;
@property (nonatomic,assign) CGSize imageSize;
@property (nonatomic,strong) UILabel *sortLabel;
@property (nonatomic,strong) UIImageView *selectImageView;

- (void)setSelectedIndex:(NSInteger)index animation:(BOOL)animation;



@end

NS_ASSUME_NONNULL_END
