//
//  HXImagePickerController.m
//  HqIMagePickerController
//
//  Created by hehuiqi on 8/10/19.
//  Copyright © 2019 hehuiqi. All rights reserved.
//

#import "HXImagePickerController.h"
#import "HXPhotoImageManager.h"
@interface HXImagePickerController ()



@end

@implementation HXImagePickerController
- (instancetype)init{
    if (self = [super init]) {
        [self initBaseSet];
    }
    return self;
}
- (void)initBaseSet{
    self.maxSelectCount = 9;
    self.mediaTypes = @[@(PHAssetMediaTypeImage),@(PHAssetMediaTypeVideo)];
    self.hasAlbumList = NO;
    self.mainTintColor = [UIColor colorWithRed:21/255.0 green:126/255.0 blue:251/255.0 alpha:1.0];
    self.isOrigin = NO;
    self.selectedImageModels = [[NSMutableArray alloc] initWithCapacity:0];
}
- (instancetype)initWithHasAlbumList:(BOOL)hasAlbumList{
    
  
    UIViewController *rootVC = nil;
    if (hasAlbumList) {
        rootVC = [[HXAlbumListViewController alloc] init];
    }else{
        rootVC = [[HXImageListViewController alloc] init];
    }
    if (self = [super initWithRootViewController:rootVC]) {
        [self initBaseSet];
        self.hasAlbumList = hasAlbumList;

    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigationBarUI];
}
- (void)setIsOrigin:(BOOL)isOrigin{
    _isOrigin = isOrigin;
    
    if (isOrigin) {
        [[NSNotificationCenter defaultCenter] postNotificationName:HXImagePickerIsOriginDidChanged object:@(isOrigin)];
    }
}
- (void)setSelectedImageModels:(NSMutableArray<HXImageModel *> *)selectedImageModels{
    _selectedImageModels = selectedImageModels;
    if (_selectedImageModels) {
        [[NSNotificationCenter defaultCenter] postNotificationName:HXImagePickerSelectedImageModelsDidChanged object:selectedImageModels];

    }
}
- (void)setupNavigationBarUI{
    self.navigationBar.tintColor = self.mainTintColor;
    self.navigationBar.shadowImage = [UIImage new];
}
// 取消
- (void)cancelSelect{
    if (self.hxip_delegate) {
        [self.hxip_delegate imagePickerControllerDidCancelSelect:self];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
// 选择完成
- (void)confirmSelectImageModels{
    if (self.hxip_delegate) {
    [self.hxip_delegate imagePickerController:self didSelectedImageModels:self.selectedImageModels isOrigin:self.isOrigin];

       __block BOOL requestFail = NO;
        dispatch_group_t group = dispatch_group_create();
        NSMutableArray *images = [[NSMutableArray alloc] init];
        /*
        for (HXImageModel *model in self.selectedImageModels) {
            [images addObject:UIImage.new];
        }
        */
        for (HXImageModel *model in self.selectedImageModels) {
            dispatch_group_enter(group);
            UIImage *editedImage = model.editedImage;
            if (editedImage) {
                [images addObject:editedImage];
                dispatch_group_leave(group);
            }else if (self.isOrigin){
                [HXPhotoImageManager requestOriginImage:model.phAsset completion:^(UIImage * _Nonnull image, BOOL finished) {
                    if (image) {
                        [images addObject:image];
                        dispatch_group_leave(group);
                    }else{
                        requestFail = YES;
                        dispatch_group_leave(group);
                    }
                }];
            }else{
                [HXPhotoImageManager requestPreviewImage:model.phAsset completion:^(UIImage * _Nonnull image, BOOL finished) {
                    if (image) {
                        [images addObject:image];
                        dispatch_group_leave(group);
                    }else{
                        requestFail = YES;
                        dispatch_group_leave(group);
                    }
                }];
            }
        }
    
        dispatch_group_notify(group, dispatch_get_main_queue(), ^{
           
            if (requestFail) {
                NSLog(@"图片加载失败");
                return ;
            }
            [self.hxip_delegate imagePickerController:self didSelectedImages:images];
            [self dismissViewControllerAnimated:YES completion:nil];
            
        });
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
- (void)showCanNotSelectAlert{
    
    NSString *title = [NSString stringWithFormat:@"最多只能选择%@张图片",@(self.maxSelectCount)];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:(UIAlertControllerStyleAlert)];
    
    UIAlertAction *cancelAction  =[UIAlertAction actionWithTitle:@"我知道了" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:cancelAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}
/// 弹出前往设置授权提示框
- (void)showAuthorizationAlert{
    NSString *title = @"请开启照片权限";
    NSString *message = @"相册权限未开启,请进入系统设置>隐私>照片中打开开关,并允许使用照片权限";
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:(UIAlertControllerStyleAlert)];
    
    UIAlertAction *cancelAction  =[UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *confirmAction  =[UIAlertAction actionWithTitle:@"立即设置" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        UIApplication *app = [UIApplication sharedApplication];
        if ([app canOpenURL:url]) {
            [app openURL:url options:@{} completionHandler:nil];
        }
    }];
    [alert addAction:cancelAction];
    [alert addAction:confirmAction];

    
    [self presentViewController:alert animated:YES completion:nil];
}
//覆盖popViewControllerAnimated
- (UIViewController *)popViewControllerAnimated:(BOOL)animated{
    UIViewController *popVC = [super popViewControllerAnimated:animated];
    NSString *clasStr = NSStringFromClass(popVC.class);
    if ([clasStr isEqualToString:@"HXImageListViewController"] ) {
        NSLog(@"popVC.class==2%@",popVC.class);
        [self.selectedImageModels removeAllObjects];
    }
    return popVC;
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
