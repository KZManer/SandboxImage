//
//  ShowViewController.m
//  SandboxImage
//
//  Created by 龙邦 on 16/8/25.
//  Copyright © 2016年 KZ. All rights reserved.
//

#import "ShowViewController.h"
#import "KZImagePickerController.h"
#import "StorePhotoView.h"

//存放图片数组的文件夹路径
#define Images_Arr_Path [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/imgArrAddress_1"]
//存放照片的文件夹路径
#define Images_Path [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/images"]


@interface ShowViewController ()<KZImagePickerControllerDelegate,StorePhotoViewDelegate>

@property (nonatomic, strong) StorePhotoView *storePhotoView;

@property (nonatomic, copy) NSString *imgsArrPath;//存放图片地址数组的地址

@end

@implementation ShowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [[UIColor lightGrayColor]colorWithAlphaComponent:.4];
    
    //初始化storePhotoView
    _storePhotoView = [[StorePhotoView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width - 20, self.view.bounds.size.width - 20)];
    _storePhotoView.center = self.view.center;
    _storePhotoView.delegate = self;
    
    //初始化图片按钮
    UIButton *addImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [addImageBtn setFrame:CGRectMake(self.view.bounds.size.width/2 - 50, self.view.bounds.size.height - 60, 100, 30)];
    [addImageBtn setTitle:@"AddImage" forState:UIControlStateNormal];
    [addImageBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    addImageBtn.backgroundColor = [[UIColor greenColor]colorWithAlphaComponent:.4];
    [addImageBtn addTarget:self action:@selector(addImageBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addImageBtn];
    
    
    NSLog(@"%@",NSHomeDirectory());
    
    //模拟机下使用以下代码-目的将文件夹删除
    [[NSFileManager defaultManager]removeItemAtPath:Images_Arr_Path error:nil];
    [[NSFileManager defaultManager]removeItemAtPath:Images_Path error:nil];
    //******************************//
    
    
    //
    if (![[NSFileManager defaultManager]fileExistsAtPath:Images_Arr_Path]) {
        [[NSFileManager defaultManager]createDirectoryAtPath:Images_Arr_Path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    _imgsArrPath = [Images_Arr_Path stringByAppendingPathComponent:@"imgArrAddress.txt"];
    NSArray *imagesPathArr = [NSArray arrayWithContentsOfFile:_imgsArrPath];
    [_storePhotoView showInView:self.view addressArrs:imagesPathArr showIndex:0];
}
- (void)addImageBtnClicked {
    KZImagePickerController *picker = [KZImagePickerController imagePicker];
    picker.kzDelegate = self;
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark-KZImagePickerControllerDelegate
- (void)kzImagePickerControllerDidFinishWithArray:(NSArray *)imageArrs {
    NSLog(@"%@",imageArrs);
    //存放图片地址的数组
    NSMutableArray *imagesPathArr = [NSMutableArray arrayWithCapacity:20];
    NSArray *tempImgsArr = [NSArray arrayWithContentsOfFile:_imgsArrPath];
    [imagesPathArr addObjectsFromArray:tempImgsArr];
    
    //创建一个存放图片的文件夹-－如果不存在就创建一个
    if (![[NSFileManager defaultManager]fileExistsAtPath:Images_Path]) {
        [[NSFileManager defaultManager]createDirectoryAtPath:Images_Path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    //沙盒中照片的总数
    int existImageCount = (int)imagesPathArr.count;
    for (int i = 0; i<imageArrs.count; i++) {
        NSString *newImagePath = [Images_Path stringByAppendingPathComponent:[NSString stringWithFormat:@"image_%d.jpg",existImageCount + i]];
        [UIImageJPEGRepresentation(imageArrs[i], 0.6) writeToFile:newImagePath atomically:YES];
        [imagesPathArr addObject:newImagePath];
    }
    [imagesPathArr writeToFile:_imgsArrPath atomically:YES];
    NSLog(@"imagesPathArrCount=%lu",(unsigned long)imagesPathArr.count);
    [_storePhotoView showInView:self.view addressArrs:imagesPathArr showIndex:0];
}

#pragma mark-StorePhotoViewDelegate
- (void)storePhotoViewDeleteBtnClicked:(int)deleteImageIndex {
    NSLog(@"deleteImageIndex＝%d",deleteImageIndex);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *deleImagePath = [Images_Path stringByAppendingPathComponent:[NSString stringWithFormat:@"image_%d.jpg",deleteImageIndex]];
    //将照片从沙盒中删除
    BOOL bo = [[NSFileManager defaultManager]removeItemAtPath:deleImagePath error:nil];
    if (bo) {
        NSLog(@"删除成功");
    } else {
        NSLog(@"删除失败");
    }
    NSString *imageArrPath = [Images_Arr_Path stringByAppendingPathComponent:@"imgArrAddress.txt"];
    NSMutableArray *imagesPathArr = [NSMutableArray arrayWithContentsOfFile:imageArrPath];
    NSLog(@"%@",imagesPathArr);
    //重新给照片命名
    int newSuffix = 0;
    //用来存放图片的新地址的数组
    NSMutableArray *newImagePathArr = [NSMutableArray arrayWithCapacity:20];
    for (int i = 0; i<imagesPathArr.count; i++) {
        if (i!=deleteImageIndex && newSuffix<imagesPathArr.count-1) {
            NSString *imageNewPath = [Images_Path stringByAppendingPathComponent:[NSString stringWithFormat:@"image_%d.jpg",newSuffix]];
            BOOL b = [fileManager moveItemAtPath:imagesPathArr[i] toPath:imageNewPath error:nil];
            if (b) {
                NSLog(@"移动成功");
            } else {
                NSLog(@"移动失败");
            }
            newSuffix++;
            //将图片的新路径放在newImagePathArr数组中
            [newImagePathArr addObject:imageNewPath];
        }
    }
    //将新的存放图片地址的数组写入沙盒
    [newImagePathArr writeToFile:imageArrPath atomically:YES];
    //删除后要显示哪一张图片
    deleteImageIndex = deleteImageIndex>0?deleteImageIndex-1:0;
    //展示在界面上
    NSLog(@"newImagePathArr-Count:%lu",(unsigned long)newImagePathArr.count);
    [_storePhotoView showInView:self.view addressArrs:newImagePathArr showIndex:deleteImageIndex];
}
@end
