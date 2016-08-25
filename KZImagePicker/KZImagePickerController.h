//
//  KZImagePickerController.h
//  10.21-PhotoAlbum
//
//  Created by 张坤 on 15/10/22.
//  Copyright © 2015年 KZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KZImagePickerControllerDelegate <NSObject>

- (void)kzImagePickerControllerDidFinishWithArray:(NSArray *)imageArrs;

@end
@interface KZImagePickerController : UINavigationController

@property (nonatomic, assign) id kzDelegate;

+ (id)imagePicker;

@end
