//
//  KZAlbumVC.m
//  10.21-PhotoAlbum
//
//  Created by 张坤 on 15/10/22.
//  Copyright © 2015年 KZ. All rights reserved.
//

/*
                                    使用方法
 
 1、将包导入工程中
 2、导入头文件    #import "MSImagePickerController.h"
 3、挂上代理  MSImagePickerControllerDelegate
 4、写访问多选相册的方法
//  访问多选相册
- (void)visityMultipleLibrary
{
    MSImagePickerController *imagePicker = [MSImagePickerController imagePicker];
    imagePicker.msDelegate = self;
    [self presentViewController:imagePicker animated:YES completion:nil];
}
5、实现代理方法
#pragma mark MSImagePickerControllerDelegate
- (void)msImagePickerControllerDidFinishWithArray:(NSArray *)array
{
    NSLog(@"选择多张图片 %@0",array);
    NSMutableArray *mutableArray = [NSMutableArray array];
    for (UIImage *image in array) {
        KZImageInfo *imageInfo = [KZImageInfo imageInfoWithImage:image andText:nil];
        [mutableArray addObject:imageInfo];
    }
    [_editView showImageInfoOnTableViewWithArray:mutableArray index:0 type:_updateType];
}


// msalbumvc 中 ofirstPhotosVC.delegate = self.navigationController;
 */
#import "KZAlbumVC.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "KZGrounpInfo.h"
#import "KZGroupCell.h"
#import "KZPhotoVC.h"
@interface KZAlbumVC ()<UITableViewDataSource,UITableViewDelegate>
{
    ALAssetsLibrary *_assetsLibrary;//资源库
    NSMutableArray *_grounpArray;
    UITableView *_tableView;
    KZPhotoVC *_photoVC;
}
@end

@implementation KZAlbumVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置导航栏属性
    [self setNavigationbar];
    //添加tableView
    [self addTableView];
    //从资源库中添加照片信息
    [self loadAssetsGroup];
}
//添加tableView
- (void)addTableView
{
    CGRect frame = self.view.frame;
    frame.size.height -= 64;
    
    _tableView = [[UITableView alloc]initWithFrame:frame style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}
//从资源库中添加照片信息
- (void)loadAssetsGroup{
    //初始化资源库
    _assetsLibrary = [[ALAssetsLibrary alloc]init];
    //初始化数组
    _grounpArray = [NSMutableArray array];
    //注意这里
    NSUInteger type = ALAssetsGroupLibrary | ALAssetsGroupEvent | ALAssetsGroupAlbum | ALAssetsGroupFaces | ALAssetsGroupSavedPhotos;
    //遍历资源库中所有相册
    [_assetsLibrary enumerateGroupsWithTypes:type usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        //如果相册存在
        if (group) {
            //给相册添加资源过滤器 只存放照片
            [group setAssetsFilter:[ALAssetsFilter allPhotos]];
            //判断相册里的照片数量大于0
            if (group.numberOfAssets>0)
            {
                KZGrounpInfo *grounpInfo = [KZGrounpInfo groupInfoWithGroup:group];
                //把组添加到数组中
                [_grounpArray addObject:grounpInfo];
            }
        } else {
            //                获取相册结束
            NSLog(@"%lu",(unsigned long)_grounpArray.count);
            _grounpArray = (NSMutableArray *)[[_grounpArray reverseObjectEnumerator]allObjects];
            
            //push到第一个相册的照片页面
            KZPhotoVC *firstPhotoVC = [[KZPhotoVC alloc]initWithGroupInfo:_grounpArray[0]];
            firstPhotoVC.delegate = self.navigationController;
            [self.navigationController pushViewController:firstPhotoVC animated:NO];
            
            [_tableView reloadData];
        }
    }failureBlock:^(NSError *error) {
        NSLog(@"获取组失败");
    }];
}
/**
 **设置导航栏
 */
- (void)setNavigationbar{
    //设置标题的大小和颜色
    self.title=@"照片";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont boldSystemFontOfSize:22]}];
    
    //设置导航栏的取消按钮
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(back )];
    self.navigationItem.rightBarButtonItem = rightButton;
    //设置导航栏的背景颜色
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"KZImageBundle.bundle/kz_nav_purple"] forBarMetrics:UIBarMetricsDefault];
    //设置导航栏按钮颜色为白色
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
}
/**
 **返回上一个页面
 */
-(void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _grounpArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    KZGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[KZGroupCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    KZGrounpInfo *groupInfo = _grounpArray[indexPath.row];
    [cell setContentView:groupInfo];
    return cell;
}
#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    KZGrounpInfo *groupInfo = _grounpArray[indexPath.row];
    ALAssetsGroup *group = groupInfo.group;
    [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
        if (result) {
            //            NSLog(@"缩略图 %@",[UIImage imageWithCGImage:result.thumbnail]);
        } else {
            //取完照片
        }
    }];
    KZPhotoVC *photoVC = [[KZPhotoVC alloc]initWithGroupInfo:groupInfo];
    photoVC.delegate = self.navigationController;
    [self.navigationController pushViewController:photoVC animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [KZGroupCell getCellHeight];
}

@end
