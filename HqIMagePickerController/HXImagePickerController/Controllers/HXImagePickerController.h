//
//  HXImagePickerController.h
//  HqIMagePickerController
//
//  Created by hehuiqi on 8/10/19.
//  Copyright © 2019 hehuiqi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HXImagePickerConfig.h"
#import "HXImageModel.h"
#import "HXAlbumModel.h"
#import "HXAlbumListViewController.h"
#import "HXImageListViewController.h"

#define HXImagePickerIsOriginDidChanged @"HXImagePickerIsOriginDidChanged"
#define HXImagePickerSelectedImageModelsDidChanged @"HXImagePickerSelectedImageModelsDidChanged"

NS_ASSUME_NONNULL_BEGIN
@class HXImagePickerController;
@protocol HXImagePickerControllerDelegate <NSObject>

@optional
- (void)imagePickerControllerDidCancelSelect:(HXImagePickerController *)imagePickerController;
- (void)imagePickerController:(HXImagePickerController *)imagePickerController didSelectedImageModels:(NSArray<HXImageModel *>*)ImageModels isOrigin:(BOOL)isOrigin;
- (void)imagePickerController:(HXImagePickerController *)imagePickerController didSelectedImages:(NSArray *)images;

@end

@interface HXImagePickerController : UINavigationController

@property (nonatomic,assign) NSUInteger maxSelectCount;
@property (nonatomic,strong) NSMutableArray<HXImageModel *> *selectedImageModels;
@property (nonatomic,strong) UIColor *mainTintColor;
//@[@(PHAssetMediaType)]
@property (nonatomic,strong) NSArray<NSNumber *> *mediaTypes;
@property (nonatomic,assign) BOOL hasAlbumList;

@property (nonatomic,weak) id<HXImagePickerControllerDelegate> hxip_delegate;

@property (nonatomic,assign) BOOL isOrigin;

- (instancetype)initWithHasAlbumList:(BOOL)hasAlbumList;
- (void)cancelSelect;
// 选择完成
- (void)confirmSelectImageModels;
- (void)showCanNotSelectAlert;
/// 弹出前往设置授权提示框
- (void)showAuthorizationAlert;
@end

NS_ASSUME_NONNULL_END
