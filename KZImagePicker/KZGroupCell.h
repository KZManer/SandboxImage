//
//  KZGroupCell.h
//  10.21-PhotoAlbum
//
//  Created by 张坤 on 15/10/22.
//  Copyright © 2015年 KZ. All rights reserved.
//

#import <UIKit/UIKit.h>
@class KZGrounpInfo;

@interface KZGroupCell : UITableViewCell

- (void)setContentView:(KZGrounpInfo *)groupInfo;
+ (CGFloat)getCellHeight;

@end
