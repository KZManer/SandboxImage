//
//  KZPhotoVC.m
//  10.21-PhotoAlbum
//
//  Created by 张坤 on 15/10/22.
//  Copyright © 2015年 KZ. All rights reserved.
//

#import "KZPhotoVC.h"
#import "KZGrounpInfo.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "KZAssetsInfo.h"

#define kMargin 5
#define kBottomHeight 40
#define LIGHT_BLUE_COLOR [UIColor colorWithRed:23/255.0f green:105/255.0f blue:214/255.0f alpha:1.0f]
#define kCountButtonH 26

static NSString *cellIdentifier = @"cellIdentifier";
@interface KZPhotoVC ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    KZGrounpInfo *_groupInfo;
    UICollectionView *_collectionView;
    NSMutableArray *_assetInfoArray;//存储所有读取的照片
    NSMutableDictionary *_imageDictionary;
    UIButton *_downButton;//完成按钮
    UIButton *_countButton;//计数按钮
    dispatch_queue_t _queue;//队列
}
@end

@implementation KZPhotoVC
- (id)initWithGroupInfo:(KZGrounpInfo *)groupInfo
{
    self = [super init];
    if (self) {
        _groupInfo = groupInfo;
        self.title = groupInfo.title;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    [self addCollectionView];
    //加载相册里的照片
    [self loadAssets];
    //添加底部视图
    [self addBottomView];
    
}
- (void)addCollectionView
{
    CGRect frame = self.view.frame;
    frame.size.height -= (64+kBottomHeight);
    
    _collectionView = [[UICollectionView alloc]initWithFrame:frame collectionViewLayout:[UICollectionViewFlowLayout new]];
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:cellIdentifier];
    [_collectionView setBackgroundColor:[UIColor whiteColor]];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    //允许多选
    _collectionView.allowsMultipleSelection = YES;
    [self.view addSubview:_collectionView];
}
//加载相册里的照片
- (void)loadAssets
{
    _assetInfoArray = [NSMutableArray array];
    ALAssetsGroup *group = _groupInfo.group;
    [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
        if (result) {
            KZAssetsInfo *assetInfo = [[KZAssetsInfo alloc]initWithAsset:result];
            [_assetInfoArray addObject:assetInfo];
        } else {
            //遍历完成
            //滚动到最底部
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:_assetInfoArray.count -1  inSection:0];
            [_collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionBottom animated:NO];
        }
    }];
}
//添加底部视图
- (void)addBottomView
{
    UIView *bottomView= [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_collectionView.frame), self.view.bounds.size.width, kBottomHeight)];
    [bottomView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:bottomView];
    
    _downButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_downButton setFrame:CGRectMake(self.view.bounds.size.width - 50 - 10, (kBottomHeight - 20)/2, 50, 20)];
    [_downButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_downButton setUserInteractionEnabled:NO];
    [_downButton.titleLabel setFont:[UIFont systemFontOfSize:16.0f]];
    [_downButton setTitle:@"添加" forState:UIControlStateNormal];
    [_downButton addTarget:self action:@selector(upload) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:_downButton];
    
    _countButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_countButton setFrame:CGRectMake(CGRectGetMinX(_downButton.frame) - kCountButtonH, (kBottomHeight - kCountButtonH)/2, kCountButtonH, kCountButtonH)];
    [_countButton.layer setCornerRadius:kCountButtonH/2];
    [_countButton setImage:[UIImage imageNamed:@"KZImageBundle.bundle/kz_badge"] forState:UIControlStateNormal];
    _countButton.hidden = YES;
    [_countButton.titleLabel setFont:[UIFont systemFontOfSize:16.0f]];
    [_countButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -kCountButtonH, 0, 0)];
    [bottomView addSubview:_countButton];
}
//设置按钮的状态
- (void)setButtonStatus:(int)count
{
    if (count > 0) {
        [_downButton setTitleColor:LIGHT_BLUE_COLOR forState:UIControlStateNormal];
        [_downButton setUserInteractionEnabled:YES];
        _countButton.hidden = NO;
        [_countButton setTitle:[NSString stringWithFormat:@"%d",count] forState:UIControlStateNormal];
        
        CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"bounds"];
        NSValue *value1 = [NSValue valueWithCGRect:CGRectMake(0, 0, kCountButtonH*0.5, kCountButtonH*0.5)];
        NSValue *value2 = [NSValue valueWithCGRect:CGRectMake(0, 0, kCountButtonH*1.2, kCountButtonH*1.2)];
        NSValue *value3 = [NSValue valueWithCGRect:CGRectMake(0, 0, kCountButtonH, kCountButtonH)];
        animation.values = @[value1,value2,value3];
        [_countButton.imageView.layer addAnimation:animation forKey:nil];
        
    } else {
        [_downButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [_downButton setUserInteractionEnabled:NO];
        _countButton.hidden = YES;
    }
}
- (void)upload
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(photoVCImagePickerSuccess:)]) {
        [self.delegate photoVCImagePickerSuccess:[_imageDictionary allValues]];
    }
    [self back];
}
- (void)back {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _assetInfoArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    KZAssetsInfo *assetInfo = _assetInfoArray[indexPath.item];
    cell.backgroundView = [[UIImageView alloc]initWithImage:assetInfo.thumbNailImage];
    cell.selectedBackgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"KZImageBundle.bundle/kz_overlay"]];
    //    [cell setContentView:assetInfo];
    
    return cell;
}
#pragma mark UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"%f",(self.view.bounds.size.width - kMargin*5)/4);
    return CGSizeMake((self.view.bounds.size.width - kMargin*5)/4, (self.view.bounds.size.width - kMargin*5)/4);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(kMargin, kMargin, kMargin, kMargin);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return kMargin;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return kMargin;
}
#pragma mark UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (!_imageDictionary) {
        _imageDictionary = [NSMutableDictionary dictionary];
    }
    if (!_queue) {
        //初始化一个队列（串行队列）
        _queue = dispatch_queue_create("test", NULL);
    }
    dispatch_async(_queue, ^{
        KZAssetsInfo *assetInfo = _assetInfoArray[indexPath.item];
        UIImage *image = [UIImage imageWithCGImage:[assetInfo.asset defaultRepresentation].fullScreenImage];
        [_imageDictionary setObject:image forKey:[NSString stringWithFormat:@"%lu",(long)indexPath.item]];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setButtonStatus:(int)_imageDictionary.count];
        });
    });
    
}
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    dispatch_async(_queue, ^{
        [_imageDictionary removeObjectForKey:[NSString stringWithFormat:@"%lu",(long)indexPath.item]];
        dispatch_async(dispatch_get_main_queue(), ^{
            //设置按钮状态
            [self setButtonStatus:(int)_imageDictionary.count];
        });
    });
}
@end
