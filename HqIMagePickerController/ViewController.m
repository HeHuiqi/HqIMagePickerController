//
//  ViewController.m
//  HqIMagePickerController
//
//  Created by hehuiqi on 8/10/19.
//  Copyright © 2019 hehuiqi. All rights reserved.
//

#import "ViewController.h"
#import "HXImagePickerController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    HXImagePickerController *pickerVC = [[HXImagePickerController alloc] initWithHasAlbumList:YES];
//    pickerVC.maxSelectCount = 5;
    [self presentViewController:pickerVC animated:YES completion:nil];
}


@end
