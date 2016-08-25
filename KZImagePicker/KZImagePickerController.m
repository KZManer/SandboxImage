//
//  KZImagePickerController.m
//  10.21-PhotoAlbum
//
//  Created by 张坤 on 15/10/22.
//  Copyright © 2015年 KZ. All rights reserved.
//

#import "KZImagePickerController.h"
#import "KZAlbumVC.h"
#import "KZPhotoVC.h"

@interface KZImagePickerController ()<KZPhotoVCDelegate>

@end
@implementation KZImagePickerController

+ (id)imagePicker
{
    KZAlbumVC *albumVC = [[KZAlbumVC alloc]init];
    return [[self alloc]initWithRootViewController:albumVC];
}
#pragma mark KZPhotoVCDelegate
- (void)photoVCImagePickerSuccess:(NSArray *)array
{
//    NSLog(@"%@",array);
    if (self.kzDelegate && [self.kzDelegate respondsToSelector:@selector(kzImagePickerControllerDidFinishWithArray:)]) {
        [self.kzDelegate kzImagePickerControllerDidFinishWithArray:array];
    }
}
@end
