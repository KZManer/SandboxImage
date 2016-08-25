//
//  KZGrounpInfo.h
//  10.21-PhotoAlbum
//
//  Created by 张坤 on 15/10/21.
//  Copyright © 2015年 KZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
@interface KZGrounpInfo : NSObject

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *count;
@property (nonatomic, strong) ALAssetsGroup *group;


- (id)initWithGrounp:(ALAssetsGroup *)group;
+ (id)groupInfoWithGroup:(ALAssetsGroup *)group;
@end
