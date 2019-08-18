//
//  HXImagePreviewViewController.m
//  HqIMagePickerController
//
//  Created by hehuiqi on 8/10/19.
//  Copyright © 2019 hehuiqi. All rights reserved.
//
#define HqPreviewCellSpace 5
#import "HXPreviewCell.h"

#import "HXImagePreviewViewController.h"
#import "HXImageNavigationView.h"
#import "HXImagePickerController.h"

static inline BOOL isIPhoneXSeries() {
    
    if ([UIDevice currentDevice].userInterfaceIdiom != UIUserInterfaceIdiomPhone) {
        return NO;
    }
    if (@available(iOS 11.0, *)) {
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        if (window.safeAreaInsets.bottom > 0.0) {
            return YES;
        }
    }
    return NO;
}

@interface HXImagePreviewViewController ()
<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,assign) BOOL shouldShouNavigationBarWhenDisappear;


@property (nonatomic,strong) UICollectionView *previewCollectionView;
@property (nonatomic,strong) HXImageNavigationView *imageNavigationView;
@property (nonatomic,strong) HXImagePickerController *pickerController;



@end

@implementation HXImagePreviewViewController
- (BOOL)prefersStatusBarHidden{

    //这里隐藏后  [UIApplication sharedApplication].statusBarFrame; 会变为0
    //所以有上页传入导航+状态栏的高度
    return YES;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;

}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.previewCollectionView];
    [self.view addSubview:self.imageNavigationView];
    
    
    /// 设置选中按钮状态
    HXImageModel *previewImageModel = self.imageModels[self.currentIndex];
    NSInteger selectedIndex = -1;
    if ([self.pickerController.selectedImageModels containsObject:previewImageModel]) {
        selectedIndex = [self.pickerController.selectedImageModels indexOfObject:previewImageModel];
    }
    if (selectedIndex>-1 && previewImageModel) {
        [self.imageNavigationView.selectBtn setSelectedIndex:selectedIndex animation:NO];
    }

    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectedImageModelsDidChangeed:) name:HXImagePickerSelectedImageModelsDidChanged object:nil];
}
- (HXImagePickerController *)pickerController{
    return (HXImagePickerController *)self.navigationController;
}
- (HXImageNavigationView *)imageNavigationView{
    if (!_imageNavigationView) {
      
        CGFloat navH =  self.fixNavBarHeight;
//        if (isIPhoneXSeries()) {
//            navH = 88;
//        }
        _imageNavigationView = [[HXImageNavigationView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, navH) contentHeight:50];
        _imageNavigationView.mainTintColor = self.pickerController.mainTintColor;
        [_imageNavigationView.backBtn addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [_imageNavigationView.selectBtn addTarget:self action:@selector(selectBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _imageNavigationView;
}

- (void)backBtnClicked{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - 选中操作
- (void)selectBtnClicked{
    HXImagePickerController *pickerController  = self.pickerController;
    HXImageModel * imageModel  = self.imageModels[self.currentIndex];
    NSMutableArray *selectedModels = self.pickerController.selectedImageModels;

    if (imageModel.isSelected) {
        [self.imageNavigationView.selectBtn setSelectedIndex:-1 animation:NO];
        [self.pickerController.selectedImageModels enumerateObjectsUsingBlock:^(HXImageModel * _Nonnull selectedModel, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([selectedModel equalToImageModel:imageModel]) {
                imageModel.selectedIndex = -1;
                NSInteger delModeIndex = [selectedModels indexOfObject:imageModel];
                [selectedModels removeObject:imageModel];
                //删除之后的model要重排index
                for (NSInteger i = delModeIndex; i<selectedModels.count; i++) {
                    HXImageModel *afterModel = selectedModels[i];
                    afterModel.selectedIndex = i;
                }
                [selectedModels removeObject:selectedModel];
                pickerController.selectedImageModels = selectedModels;
            }
        }];
    }else{
        if (pickerController.selectedImageModels.count >= pickerController.maxSelectCount) {
            [pickerController showCanNotSelectAlert];
            return;
        }
        
        imageModel.selectedIndex = pickerController.selectedImageModels.count;
        [self.imageNavigationView.selectBtn setSelectedIndex:pickerController.selectedImageModels.count animation:YES];
        [pickerController.selectedImageModels addObject:imageModel];
        pickerController.selectedImageModels = pickerController.selectedImageModels;
    }
}
#pragma mark - selectedImageModelsDidChangeed
- (void)selectedImageModelsDidChangeed:(NSNotification *)nofity{
    
}
- (UICollectionView *)previewCollectionView{
    
    if (!_previewCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        CGFloat space = HqPreviewCellSpace;
        layout.minimumLineSpacing = space * 2;
        layout.minimumInteritemSpacing = 0;
        layout.sectionInset = UIEdgeInsetsMake(0, space, 0, space);
        layout.itemSize = self.view.bounds.size;
        _previewCollectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
        _previewCollectionView.delegate = self;
        _previewCollectionView.dataSource = self;
        _previewCollectionView.backgroundColor = [UIColor clearColor];
        _previewCollectionView.pagingEnabled = YES;
        _previewCollectionView.showsVerticalScrollIndicator = YES;
        _previewCollectionView.showsHorizontalScrollIndicator = YES;
        
        [_previewCollectionView registerClass:HXPreviewCell.class forCellWithReuseIdentifier:HXPreviewCellID];
        if (@available(iOS 11.0, *)) {
            _previewCollectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        //        _previewCollectionView.frame = CGRectInset(_previewCollectionView.frame,-space,0);
        CGRect adjustRect = _previewCollectionView.frame;
        adjustRect.origin.x = -space;
        adjustRect.size.width = adjustRect.size.width+space*2;
        _previewCollectionView.frame = adjustRect;
        
    }
    return _previewCollectionView;
}
#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.imageModels.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    HXPreviewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:HXPreviewCellID forIndexPath:indexPath];
    cell.imageModel = self.imageModels[indexPath.row];
    
    cell.singleTapCallback = ^(HXPreviewCell *cell) {
        self.imageNavigationView.hidden = !self.imageNavigationView.hidden;
    };
    
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    HXImageModel *imageModel = self.imageModels[indexPath.row];
    if (!imageModel.canSelect) {
        [self.pickerController showCanNotSelectAlert];
    }else{
        
    }
}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == self.previewCollectionView) {
        self.currentIndex = round(scrollView.contentOffset.x / scrollView.bounds.size.width);
        if (self.currentIndex >= self.imageModels.count) {
            self.currentIndex = self.imageModels.count - 1;
        } else if (self.currentIndex < 0) {
            self.currentIndex = 0;
        }
        NSLog(@"self.currentIndex==%@",@(self.currentIndex));
        HXImageModel *previewImageModel = self.imageModels[self.currentIndex];
        NSInteger selectedIndex = -1;
        if ([self.pickerController.selectedImageModels containsObject:previewImageModel]) {
            selectedIndex = [self.pickerController.selectedImageModels indexOfObject:previewImageModel];
        }
        NSLog(@"selectedIndex===%@",@(selectedIndex));
        if (selectedIndex>-1 && previewImageModel) {
            [self.imageNavigationView.selectBtn setSelectedIndex:selectedIndex animation:NO];
            //let selectedIndexPath = IndexPath(item: selectedIndex, section: 0)
            //thumbCollectionViewCellDidSelected(at: selectedIndexPath)
        } else {
            /*
            if thumbSelectedIndexPath != nil{
                collectionView(thumbCollectionView, didDeselectItemAt: thumbSelectedIndexPath!)
            }
            */
            [self.imageNavigationView.selectBtn setSelectedIndex:-1 animation:NO];
        }
    }
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

