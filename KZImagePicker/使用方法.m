//
//使用方法
//
//1、将包导入工程中
//2、导入头文件    #import "KZImagePickerController.h"
//3、挂上代理  KZImagePickerControllerDelegate
//4、写访问多选相册的方法
////  访问多选相册
//- (void)visityMultipleLibrary
//{
//    KZImagePickerController *imagePicker = [KZImagePickerController imagePicker];
//    imagePicker.kzDelegate = self;
//    [self presentViewController:imagePicker animated:YES completion:nil];
//}
//5、实现代理方法
//#pragma mark KZImagePickerControllerDelegate
//- (void)kzImagePickerControllerDidFinishWithArray:(NSArray *)array
//{
//    NSLog(@"选择多张图片 %@0",array);
//    NSMutableArray *mutableArray = [NSMutableArray array];
//    for (UIImage *image in array) {
//        KZImageInfo *imageInfo = [KZImageInfo imageInfoWithImage:image andText:nil];
//        [mutableArray addObject:imageInfo];
//    }
//    [_editView showImageInfoOnTableViewWithArray:mutableArray index:0 type:_updateType];
//}


// KZAlbumvc 中 firstPhotosVC.delegate = self.navigationController;