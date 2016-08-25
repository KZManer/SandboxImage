//
//  KZAssetsInfo.m
//  10.21-PhotoAlbum
//
//  Created by 张坤 on 15/10/22.
//  Copyright © 2015年 KZ. All rights reserved.
//

#import "KZAssetsInfo.h"

@implementation KZAssetsInfo

- (id)initWithAsset:(ALAsset *)asset
{
    self = [super init];
    if (self) {
        self.thumbNailImage = [UIImage imageWithCGImage:asset.thumbnail];
        self.asset = asset;
    }
    return self;
}

@end
