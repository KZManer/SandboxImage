//
//  KZView.m
//  ipaddd
//
//  Created by 张坤 on 16/5/30.
//  Copyright © 2016年 longbang. All rights reserved.
//

#import "KZView.h"

@implementation KZButton


@end




@interface KZView ()
{
    UIImageView *_imageView;
}
@end

@implementation KZView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _imageView = [[UIImageView alloc]initWithFrame:self.bounds];
//        [_imageView setImage:image];
        UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
        _scrollView = scrollView;
        [scrollView addSubview:_imageView];
        
        scrollView.contentSize = CGSizeMake(0, 0);
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.maximumZoomScale = 3;
        scrollView.minimumZoomScale = 1;
        scrollView.bounces = NO;
        scrollView.delegate = self;
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageClicked:)];
        tapGesture.numberOfTapsRequired = 2;
        [scrollView addGestureRecognizer:tapGesture];
        
        [self addSubview:scrollView];
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame image:(UIImage *)image{
    self = [super initWithFrame:frame];
    if (self) {
        _imageView = [[UIImageView alloc]initWithFrame:self.bounds];
        [_imageView setImage:image];
        UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
        _scrollView = scrollView;
        [scrollView addSubview:_imageView];
        
        scrollView.contentSize = CGSizeMake(0, 0);
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.maximumZoomScale = 3;
        scrollView.minimumZoomScale = 1;
        scrollView.bounces = NO;
        scrollView.delegate = self;
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageClicked:)];
        tapGesture.numberOfTapsRequired = 2;
        [scrollView addGestureRecognizer:tapGesture];
        
        [self addSubview:scrollView];
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame imageView:(UIImageView *)imageView{
    self = [super initWithFrame:frame];
    if (self) {
        _imageView = imageView;
        UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
        _scrollView = scrollView;
        [scrollView addSubview:imageView];
        
        scrollView.contentSize = CGSizeMake(0, 0);
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.maximumZoomScale = 3;
        scrollView.minimumZoomScale = 1;
        scrollView.bounces = NO;
        scrollView.delegate = self;
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageClicked:)];
        tapGesture.numberOfTapsRequired = 2;
        [scrollView addGestureRecognizer:tapGesture];
        
        [self addSubview:scrollView];
    }
    return self;
}
- (void)imageClicked:(UITapGestureRecognizer *)gesture{
    UIScrollView *scrollView = (UIScrollView *)gesture.view;
    _scrollView = scrollView;
    CGFloat scale = 1.0;
    if (scrollView.zoomScale == 1.0) {
        scale = 3.0;
    } else {
        scale = 1.0;
    }
    CGRect zoomRect = [self zoomRectForScale:scale withCenter:[gesture locationInView:gesture.view]];
    [scrollView zoomToRect:zoomRect animated:YES];
}

- (void)imageBackOriginalSize:(NSArray *)imageViews {
    for (UIScrollView *scrollView in imageViews) {
        scrollView.zoomScale = 1;
    }
}
- (void)imgBackOriginalSize:(UIImageView *)imageView{
    UIScrollView *scrollView = (UIScrollView *)imageView.superview;
    scrollView.zoomScale = 1;
}
//以中心
- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center
{
    CGRect zoomRect;
    zoomRect.size.height = _scrollView.frame.size.height / scale;
    zoomRect.size.width  = _scrollView.frame.size.width  / scale;
    zoomRect.origin.x    = center.x - (zoomRect.size.width  /2.0);
    zoomRect.origin.y    = center.y - (zoomRect.size.height /2.0);
    return zoomRect;
}
#pragma UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return _imageView;
}
@end
