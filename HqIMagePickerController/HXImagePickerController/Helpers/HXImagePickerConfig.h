//
//  HXImagePickerConfig.h
//  HqIMagePickerController
//
//  Created by hehuiqi on 8/10/19.
//  Copyright © 2019 hehuiqi. All rights reserved.
//

#import <Foundation/Foundation.h>
#define HqStatusBarHeight CGRectGetHeight([UIApplication sharedApplication].statusBarFrame)

#define HXImagePickerIsOriginDidChanged @"HXImagePickerIsOriginDidChanged"
#define HXImagePickerSelectedImageModelsDidChanged @"HXImagePickerSelectedImageModelsDidChanged"

NS_ASSUME_NONNULL_BEGIN

@interface HXImagePickerConfig : NSObject

@end

NS_ASSUME_NONNULL_END
