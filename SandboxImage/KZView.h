//
//  KZView.h
//  ipaddd
//
//  Created by 张坤 on 16/5/30.
//  Copyright © 2016年 longbang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KZButton : UIButton

//要删除的照片的在数组中的下标
@property (nonatomic, assign) int index;


@end

@interface KZView : UIView<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;

- (id)initWithFrame:(CGRect)frame image:(UIImage *)image;

- (void)imageBackOriginalSize:(NSArray *)imageViews;

@end
