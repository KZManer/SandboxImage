//
//  StorePhotoView.h
//  StoreManage-iPad
//
//  Created by 龙邦 on 16/8/23.
//  Copyright © 2016年 longbang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol StorePhotoViewDelegate <NSObject>

- (void)storePhotoViewDeleteBtnClicked:(int)deleteImageIndex;

@end

@interface StorePhotoView : UIView

@property (nonatomic, assign) id delegate;

/**
 *  展示选中的图片
 *
 *  @param view        父view
 *  @param addressArrs 存放图片地址的数组
 *  @param showIndex   从哪张张图片开始展示
 */
- (void)showInView:(UIView *)view addressArrs:(NSArray *)addressArrs showIndex:(NSInteger)showIndex;

@end
