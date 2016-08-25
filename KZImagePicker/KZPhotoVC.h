//
//  KZPhotoVC.h
//  10.21-PhotoAlbum
//
//  Created by 张坤 on 15/10/22.
//  Copyright © 2015年 KZ. All rights reserved.
//

#import <UIKit/UIKit.h>
@class KZGrounpInfo;

@protocol KZPhotoVCDelegate <NSObject>

- (void)photoVCImagePickerSuccess:(NSArray *)array;

@end

@interface KZPhotoVC : UIViewController

@property (nonatomic, assign) id delegate;

- (id)initWithGroupInfo:(KZGrounpInfo *)groupInfo;

@end
