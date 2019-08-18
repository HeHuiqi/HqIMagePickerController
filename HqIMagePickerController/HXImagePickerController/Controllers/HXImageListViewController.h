//
//  HXImageListViewController.h
//  HqIMagePickerController
//
//  Created by hehuiqi on 8/10/19.
//  Copyright © 2019 hehuiqi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HXAlbumModel.h"
#import "HXImageCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface HXImageListViewController : UIViewController
@property (nonatomic,strong) HXAlbumModel *albumModel;

@end

NS_ASSUME_NONNULL_END
