//
//  HXAlbumCell.m
//  HqIMagePickerController
//
//  Created by hehuiqi on 8/10/19.
//  Copyright © 2019 hehuiqi. All rights reserved.
//

#import "HXAlbumCell.h"

@implementation HXAlbumCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
    }
    return self;
}
- (void)setup{
    [self addSubview:self.coverImageView];
    [self addSubview:self.nameLabel];
}

- (UIImageView *)coverImageView{
    if (!_coverImageView) {
        _coverImageView = [[UIImageView alloc] init];
        _coverImageView.contentMode = UIViewContentModeScaleAspectFill;
        _coverImageView.clipsToBounds = YES;
        _coverImageView.backgroundColor = [UIColor lightGrayColor];
    }
    return _coverImageView;
}
- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont boldSystemFontOfSize:16];
    }
    return _nameLabel;
}
- (void)setAlbumModel:(HXAlbumModel *)albumModel{
    _albumModel = albumModel;
    if (_albumModel) {
        NSString *name = [NSString stringWithFormat:@"%@(%@)",albumModel.albumName,@(albumModel.fetchAssets.count)];
        self.nameLabel.text = name;
        [albumModel requestCoverImage:^(HXAlbumModel * _Nonnull model, UIImage * _Nonnull coverImage) {
            if ([albumModel equalToAlbumModel:model]) {
                self.coverImageView.image = coverImage;
            }
        }];
        [self setNeedsLayout];
    }
}
- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat y = 8;
    CGFloat imgW = self.bounds.size.height-y*2;
    CGFloat space = 15;
    self.coverImageView.frame = CGRectMake(space, y, imgW, imgW);
    CGFloat labX = CGRectGetMaxX(self.coverImageView.frame)+space;
    CGFloat labW = self.bounds.size.width - labX-space;
    self.nameLabel.frame = CGRectMake(labX, y, labW, imgW);
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
