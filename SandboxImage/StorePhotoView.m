//
//  StorePhotoView.m
//  StoreManage-iPad
//
//  Created by 龙邦 on 16/8/23.
//  Copyright © 2016年 longbang. All rights reserved.
//

#import "StorePhotoView.h"
#import "KZView.h"
#import "UIViewExt.h"

@interface StorePhotoView ()<UIScrollViewDelegate>
{
    UIScrollView *_scrollView;
    UIView *_picBackView;//照片背景view
    KZButton *_deleteBtn;
    NSMutableArray *_kViews;//存放所有kview
}
@end

@implementation StorePhotoView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _picBackView = [[UIView alloc]initWithFrame:self.bounds];
        [self addSubview:_picBackView];
        
        _scrollView = [[UIScrollView alloc]initWithFrame:_picBackView.bounds];
        _scrollView.delegate = self;
        //是否整页翻动
        _scrollView.pagingEnabled = YES;
        //是否显示水平方向的滚动条
        _scrollView.showsHorizontalScrollIndicator = NO;
        //是否显示竖直方向的滚动条
        _scrollView.showsVerticalScrollIndicator = NO;
        //遇到边框是否反弹
        _scrollView.bounces = NO;
        [_picBackView addSubview:_scrollView];
        _kViews = [NSMutableArray arrayWithCapacity:20];
        //监控目前滚动的位置
        _scrollView.contentOffset = CGPointMake(0, 0);
        [_scrollView setBackgroundColor:[UIColor whiteColor]];
        
        //删除按钮
        _deleteBtn = [KZButton buttonWithType:UIButtonTypeCustom];
        [_deleteBtn setFrame:CGRectMake(_picBackView.width - 45, _picBackView.height - 45, 40, 40)];
        [_deleteBtn setBackgroundImage:[UIImage imageNamed:@"deleteBtnBGI"] forState:UIControlStateNormal];
        [_deleteBtn addTarget:self action:@selector(deleteBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [_picBackView addSubview:_deleteBtn];
    }
    return self;
}
- (void)showInView:(UIView *)view addressArrs:(NSArray *)addressArrs showIndex:(NSInteger)showIndex{
    for (UIView *view in _scrollView.subviews) {
        if ([view isKindOfClass:[KZView class]]) {
            [view removeFromSuperview];
        }
    }
    if (addressArrs.count == 0) {
        [_deleteBtn setHidden:YES];
        UIImage *noImage = [UIImage imageNamed:@"noImage"];
        KZView *kView = [[KZView alloc]initWithFrame:CGRectMake(0, 0, _picBackView.width, _picBackView.height) image:noImage];
        [_scrollView addSubview:kView];
        _scrollView.userInteractionEnabled = NO;
    } else {
        [_deleteBtn setHidden:NO];
        _scrollView.userInteractionEnabled = YES;
        for (int i = 0; i<addressArrs.count; i++) {
            UIImage *image = [UIImage imageWithContentsOfFile:addressArrs[i]];
            KZView *kView = [[KZView alloc]initWithFrame:CGRectMake(_picBackView.width * i, 0, _picBackView.width, _picBackView.height) image:image];
            [_scrollView addSubview:kView];
        }
        _scrollView.contentSize = CGSizeMake(_picBackView.bounds.size.width * addressArrs.count, _picBackView.bounds.size.height);
        _scrollView.contentOffset = CGPointMake(_picBackView.bounds.size.width * showIndex, 0);
    }
    [view addSubview:self];
}
//删除按钮被点击
- (void)deleteBtnClicked {
    if (self.delegate && [self.delegate respondsToSelector:@selector(storePhotoViewDeleteBtnClicked:)]) {
        [self.delegate storePhotoViewDeleteBtnClicked:_deleteBtn.index];
    }
}
#pragma mark-UIScrollViewDelegate
//当前是第几张图片
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    int indexImage = scrollView.contentOffset.x/_picBackView.width;
    _deleteBtn.index = indexImage;
}
@end
