//
//  HXAlbumListViewController.m
//  HqIMagePickerController
//
//  Created by hehuiqi on 8/10/19.
//  Copyright © 2019 hehuiqi. All rights reserved.
//

#import "HXAlbumListViewController.h"
#import "HXAlbumCell.h"
#import "HXImagePickerController.h"
#import "HXImageListViewController.h"
#import "HXPhotoImageManager.h"
@interface HXAlbumListViewController ()<UITableViewDelegate,UITableViewDataSource>


@property (nonatomic,strong) NSMutableArray<HXAlbumModel *> *albums;

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) HXImagePickerController *pickerController;




@end

@implementation HXAlbumListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择照片";
    self.albums = [[NSMutableArray alloc] initWithCapacity:4];
    [self initView];
    [self pushToImageListVC:nil animated:NO];
    [self requestAlbumModels];
    
}
- (void)initView{
    [self.view addSubview:self.tableView];
    [self setupCancelItem];
}
- (void)setupCancelItem{
    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelItemClicked)];
    self.navigationItem.rightBarButtonItem = cancelItem;
}
- (void)cancelItemClicked{
    [self.pickerController cancelSelect];
}
- (HXImagePickerController *)pickerController{
    return (HXImagePickerController *)self.navigationController;
}
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.rowHeight = 60;
    }
    return _tableView;
}
#pragma mark - UITableViewDelegate,UITableViewalbumsource
- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.albums.count;
}
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    static NSString *cellId = @"HXAlbumCell";
    HXAlbumCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[HXAlbumCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.albumModel = self.albums[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self pushToImageListVC:self.albums[indexPath.row] animated:YES];
}
- (void)pushToImageListVC:(HXAlbumModel *)albumModel animated:(BOOL)animated{
    HXImageListViewController *listVC = [[HXImageListViewController alloc] init];
    listVC.albumModel = albumModel;
    [self.navigationController pushViewController:listVC animated:animated];
}

- (void)requestAlbumModels{
    [HXPhotoImageManager getPhotoLibraryAuthorization:^(BOOL success) {
        if (success) {
            dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSMutableArray *albumModels = [[NSMutableArray alloc] init];
                NSArray *photoAlbums =   [HXPhotoImageManager getPhotoAlbums:@[@(HqAssetCollectionTypeSmartAlbum),@(HqAssetCollectionTypeUserCreateAlbum)] filterEmpty:YES];
                for (PHAssetCollection *assetCollection in photoAlbums) {
                    HXAlbumModel *albumModel = [[HXAlbumModel alloc] initWithAssetCollection:assetCollection mediaTypes:@[]];
                    [albumModels addObject:albumModel];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.albums = albumModels;
                    [self.tableView reloadData];
                    HXImageListViewController *listVC = (HXImageListViewController *)self.navigationController.topViewController;
                    listVC.albumModel = self.albums.firstObject;
                });
            });
        }else{
            [self.pickerController showAuthorizationAlert];
        }
    }];
}
@end
