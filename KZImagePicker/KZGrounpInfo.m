//
//  KZGrounpInfo.m
//  10.21-PhotoAlbum
//
//  Created by 张坤 on 15/10/21.
//  Copyright © 2015年 KZ. All rights reserved.
//

#import "KZGrounpInfo.h"

@implementation KZGrounpInfo
- (id)initWithGrounp:(ALAssetsGroup *)group
{
    self = [super init];
    if (self)
    {
        self.group = group;
        self.image = [UIImage imageWithCGImage:group.posterImage];
        self.count = [NSString stringWithFormat:@"%ld张照片",(long)group.numberOfAssets];
        self.title = [group valueForProperty:ALAssetsGroupPropertyName];
    }
    return self;
}
+ (id)groupInfoWithGroup:(ALAssetsGroup *)group
{
    return [[self alloc]initWithGrounp:group];
}
@end
