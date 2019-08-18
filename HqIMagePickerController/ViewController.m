//
//  ViewController.m
//  HqIMagePickerController
//
//  Created by hehuiqi on 8/10/19.
//  Copyright © 2019 hehuiqi. All rights reserved.
//

#import "ViewController.h"
#import "HXImagePickerController.h"
#import "HqShowSelecteImageCell.h"

@interface ViewController ()<HXImagePickerControllerDelegate,
UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) NSArray *images;


@end

@implementation ViewController

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        CGFloat itemSpacing = 5;
        CGFloat itemWidth =  (self.view.bounds.size.width - itemSpacing)/4.0 - itemSpacing;
        layout.itemSize = CGSizeMake(itemWidth, itemWidth);
        layout.minimumLineSpacing = itemSpacing;
        layout.minimumInteritemSpacing = itemSpacing;
        layout.sectionInset = UIEdgeInsetsMake(itemSpacing, itemSpacing, itemSpacing, itemSpacing);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource  = self;
        _collectionView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _collectionView.alwaysBounceVertical = YES;
        [_collectionView registerClass:HqShowSelecteImageCell.class forCellWithReuseIdentifier:HqShowSelecteImageCellID];
    }
    return _collectionView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"发布";
    [self.view addSubview:self.collectionView];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"选择图片" style:UIBarButtonItemStyleDone target:self action:@selector(choosePhoto)];
    self.navigationItem.rightBarButtonItem = item;
}

#pragma mark - UICollectionViewDataSource, UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.images.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    HqShowSelecteImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:HqShowSelecteImageCellID forIndexPath:indexPath];
    cell.image = self.images[indexPath.row];
    return cell;
}
- (void)choosePhoto{
    HXImagePickerController *pickerVC = [[HXImagePickerController alloc] initWithHasAlbumList:YES];
    pickerVC.maxSelectCount = 5;
    pickerVC.hxip_delegate = self;
    [self presentViewController:pickerVC animated:YES completion:nil];
}
#pragma mark - HXImagePickerControllerDelegate
- (void)imagePickerController:(HXImagePickerController *)imagePickerController didSelectedImages:(NSArray *)images{
    NSLog(@"images == %@",images);
    self.images = images;
    [self.collectionView reloadData];
}

@end
