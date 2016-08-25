//
//  KZGroupCell.m
//  10.21-PhotoAlbum
//
//  Created by 张坤 on 15/10/22.
//  Copyright © 2015年 KZ. All rights reserved.
//

#import "KZGroupCell.h"
#import "KZGrounpInfo.h"
#define kCellHeight 80
#define kMargin 5

@interface KZGroupCell ()
{
    UIImageView *_image;
    UILabel *_title;
    UILabel *_count;
}
@end
@implementation KZGroupCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //accessory 配饰   disclosure 显露   indicator 指示器
        //cell 后面加一个箭头
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [self addContentView];
    }
    return self;
}
- (void)addContentView
{
    _image = [[UIImageView alloc]initWithFrame:CGRectMake(kMargin, kMargin, kCellHeight - kMargin * 2, kCellHeight - kMargin * 2)];
    [self addSubview:_image];
    
    _title = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_image.frame) + kMargin * 2, kMargin, self.bounds.size.width - (CGRectGetMaxX(_image.frame) + kMargin * 2), 40)];
    [_title setTextColor:[UIColor darkGrayColor]];
    [self addSubview:_title];
    
    _count = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_image.frame) + kMargin * 2, CGRectGetMaxY(_title.frame), CGRectGetWidth(_title.frame), 20)];
    [_count setFont:[UIFont systemFontOfSize:15.0f]];
    [_count setTextColor:[UIColor grayColor]];
    [self addSubview:_count];
}
//设置内容视图显示信息
- (void)setContentView:(KZGrounpInfo *)groupInfo
{
    [_image setImage:groupInfo.image];
    [_title setText:groupInfo.title];
    [_count setText:groupInfo.count];
}
+ (CGFloat)getCellHeight
{
    return kCellHeight;
}
@end
