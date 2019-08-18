//
//  HXImagePreviewViewController.h
//  HqIMagePickerController
//
//  Created by hehuiqi on 8/10/19.
//  Copyright © 2019 hehuiqi. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HXImagePreviewViewController : UIViewController

@property (nonatomic,strong) NSArray<HXImageModel *> *imageModels;
@property (nonatomic,assign) NSUInteger currentIndex;

@property (nonatomic,assign) CGFloat fixNavBarHeight;//由上页传入


@end

NS_ASSUME_NONNULL_END
