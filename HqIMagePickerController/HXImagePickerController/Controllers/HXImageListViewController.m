//
//  HXImageListViewController.m
//  HqIMagePickerController
//
//  Created by hehuiqi on 8/10/19.
//  Copyright © 2019 hehuiqi. All rights reserved.
//

#import "HXImageListViewController.h"
#import "HXImagePickerController.h"

#import "HXPhotoImageManager.h"
#import "HXImagePreviewViewController.h"


@interface HXImageListViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>


@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,assign) BOOL willScrollToBottom;
@property (nonatomic,assign) NSKeyValueObservingOptions collectionViewObserver;


@property (nonatomic,strong) HXImagePickerController *pickerController;

@property (nonatomic,strong) NSMutableArray<HXImageModel *> *imageModels;



@end

@implementation HXImageListViewController
- (void)initBaseSet{
    self.imageModels = [[NSMutableArray alloc] initWithCapacity:0];
}
- (instancetype)init{
    if (self = [super init]) {
        [self initBaseSet];
    }
    return self;
}

- (HXImagePickerController *)pickerController{
    return (HXImagePickerController *)self.navigationController;
}
- (void)setAlbumModel:(HXAlbumModel *)albumModel{
    _albumModel = albumModel;
    if (_albumModel) {
        if (self.isViewLoaded) {
            self.title = albumModel.albumName;
            [self requestImageModels];
        }
    }
}
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        CGFloat itemSpacing = 5;
        CGFloat itemWidth =  (self.view.bounds.size.width - itemSpacing)/4.0 - itemSpacing;
        layout.itemSize = CGSizeMake(itemWidth, itemWidth);
        layout.minimumLineSpacing = itemSpacing;
        layout.minimumInteritemSpacing = itemSpacing;
        layout.sectionInset = UIEdgeInsetsMake(itemSpacing, itemSpacing, itemSpacing, itemSpacing);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-80) collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource  = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.alwaysBounceVertical = YES;
        [_collectionView registerClass:HXImageCell.class forCellWithReuseIdentifier:HXImageModelId];
    }
    return _collectionView;
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.title = self.albumModel.albumName;
    [self.view addSubview:self.collectionView];
    [self setupCancelItem];
    [self requestImageModels];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(selectedImageModelsDidChangeed:) name:HXImagePickerSelectedImageModelsDidChanged object:nil];
  
}
- (void)setupCancelItem{
    //21 126 251
    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelItemClicked)];
    self.navigationItem.rightBarButtonItem = cancelItem;
}
- (void)cancelItemClicked{
    [self.pickerController cancelSelect];
}
#pragma mark -  选中通知
- (void)selectedImageModelsDidChangeed:(NSNotification *)notify{
    NSMutableArray<HXImageModel *> *selectedModels = (NSMutableArray *)notify.object;
    NSLog(@"selectedModels==%@",selectedModels);
    /*
    if (selectedModels.count>0) {
        [selectedModels enumerateObjectsUsingBlock:^(HXImageModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.selectedIndex = idx;
        }];

    }
    */
    [self resetCanSelectState:selectedModels];
    [self.collectionView reloadData];
}
#pragma mark - UICollectionViewDataSource, UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.imageModels.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    HXImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:HXImageModelId forIndexPath:indexPath];
    cell.mainTintColor = self.pickerController.mainTintColor;
    cell.imageModel = self.imageModels[indexPath.row];
    __weak typeof(self) weak_self = self;
    cell.selectBtnClickedCallback = ^(HXImageCell * _Nonnull cell) {
        __strong typeof(self) strong_self = weak_self;
        if (cell.imageModel) {
//            [strong_self toggleImageSelected:cell.imageModel];
            [strong_self toggleImageSelected:cell.imageModel selectedBtn:cell.selectBtn];
        }
    };
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    HXImageModel *imageModel = self.imageModels[indexPath.row];
    if (!imageModel.canSelect) {
        [self.pickerController showCanNotSelectAlert];
    }else{
        [self pushToPreviewVC:self.imageModels index:indexPath.row];
    }
}
- (void)pushToPreviewVC:(NSArray<HXImageModel *> *)imageModels index:(NSInteger)index{
    HXImagePreviewViewController *previewVC = [[HXImagePreviewViewController alloc] init];
    previewVC.imageModels = imageModels;
    previewVC.currentIndex = index;
    CGRect statusBarRect = [UIApplication sharedApplication].statusBarFrame;
    CGRect navBarRect = self.navigationController.navigationBar.frame;
    previewVC.fixNavBarHeight = statusBarRect.size.height+navBarRect.size.height;
    
    [self.navigationController pushViewController:previewVC animated:YES];
}
#pragma makr - 处理是否能选择
- (void)resetCanSelectState:(NSArray<HXImageModel *> *)selectedModels{
    BOOL canSelect = YES;
    if (selectedModels.count ==  self.pickerController.maxSelectCount) {
        canSelect = NO;
    }
    [self.imageModels enumerateObjectsUsingBlock:^(HXImageModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![selectedModels containsObject:obj]) {
            obj.canSelect = canSelect;
        }
    }];
}
#pragma mark - 处理选择
- (void)toggleImageSelected:(HXImageModel *)imageModel selectedBtn:(HXSelectButton *)selectedBtn{
    NSMutableArray *selectedModels = self.pickerController.selectedImageModels;
    //    NSLog(@"imageModel.isSelected==%@",@(imageModel.isSelected));
    if (imageModel.isSelected) {
        //重置为未选中
        imageModel.selectedIndex = -1;
        if ([selectedModels containsObject:imageModel]) {
            NSInteger delModeIndex = [selectedModels indexOfObject:imageModel];
            [selectedModels removeObject:imageModel];
            //删除之后的model要重拍index
            for (NSInteger i = delModeIndex; i<selectedModels.count; i++) {
                HXImageModel *afterModel = selectedModels[i];
                afterModel.selectedIndex = i;
            }
        }
        //移除不要动画
        self.pickerController.selectedImageModels = selectedModels;
    }else{
        [selectedModels addObject:imageModel];
        imageModel.selectedIndex = selectedModels.count-1;
        [selectedBtn setSelectedIndex:imageModel.selectedIndex animation:YES];
        //动画结束后在刷新
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //这是设置会出发变化通知
            self.pickerController.selectedImageModels = selectedModels;
        });
    }
    
   
}
#pragma mark - 处理选择
- (void)toggleImageSelected:(HXImageModel *)imageModel{
    NSMutableArray *selectedModels = self.pickerController.selectedImageModels;
//    NSLog(@"imageModel.isSelected==%@",@(imageModel.isSelected));
    if (imageModel.isSelected) {
        //重置为未选中
        imageModel.selectedIndex = -1;
        if ([selectedModels containsObject:imageModel]) {
            [selectedModels removeObject:imageModel];
        }
    }else{
        [selectedModels addObject:imageModel];
    }
    //这是设置会出发变化通知
    self.pickerController.selectedImageModels = selectedModels;
}
#pragma mark - 加载照片
- (void)requestImageModels{
    if (self.albumModel) {
        dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
           
            NSMutableArray *imageModels = [[NSMutableArray alloc] initWithCapacity:0];
            for (PHAsset *phAsset in self.albumModel.fetchAssets) {
                HXImageModel *assetModel = [[HXImageModel alloc] initWithPHAsset:phAsset];
                [imageModels addObject:assetModel];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                self.imageModels = imageModels;
                [self.collectionView reloadData];
            });
        });
    }else{
        [self requestAlbumModel];
    }
}
- (void)requestAlbumModel{
    [HXPhotoImageManager getPhotoLibraryAuthorization:^(BOOL success) {
        if (success) {
            dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
              NSArray *albums =   [HXPhotoImageManager getPhotoAlbums:@[@(HqAssetCollectionTypeSmartAlbum)] filterEmpty:YES];
                HXAlbumModel *albumModel = [[HXAlbumModel alloc] initWithAssetCollection:albums.firstObject mediaTypes:@[]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.albumModel = albumModel;
                });
            });
        }else{
            [self.pickerController showAuthorizationAlert];
        }
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
