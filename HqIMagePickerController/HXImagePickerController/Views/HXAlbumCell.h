//
//  HXAlbumCell.h
//  HqIMagePickerController
//
//  Created by hehuiqi on 8/10/19.
//  Copyright © 2019 hehuiqi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HXAlbumModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HXAlbumCell : UITableViewCell

@property (nonatomic,strong) HXAlbumModel *albumModel;
@property (nonatomic,strong) UIImageView *coverImageView;
@property (nonatomic,strong) UILabel *nameLabel;



@end

NS_ASSUME_NONNULL_END
