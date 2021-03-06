//
//  ViewController.m
//  PreviewControllerDemo
//
//  Created by apple on 2017/9/29.
//  Copyright © 2017年 hty. All rights reserved.
//

#import "ViewController.h"
#import <QuickLook/QuickLook.h>
#import <AFNetworking.h>
#import <SVProgressHUD.h>
#import "PreViewController.h"
@interface ViewController () <QLPreviewControllerDataSource>
{
    PreViewController *preVC;
    UINavigationController *nav;
}
@property (strong, nonatomic)QLPreviewController *previewController;
@property (copy, nonatomic)NSURL *fileURL; //文件路径

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.previewController  =  [[QLPreviewController alloc]  init];
    self.previewController.dataSource  = self;
}

//预览本地文件
- (IBAction)previewLocal:(id)sender {
    preVC = [[PreViewController alloc] init];
//    [preVC previewLocal:[NSURL fileURLWithPath:[[NSBundle mainBundle]pathForResource:@"李碧华佳句赏析.doc" ofType:nil]]];
    [preVC previewInternet:@"https://ceshi-im-buckname.obs.cn-north-1.myhuaweicloud.com/1549934116393_y0cj4bml9k.txt"];
    nav = [[UINavigationController alloc] initWithRootViewController:preVC];

     [self presentViewController:nav animated:YES completion:nil];
//    [self.navigationController pushViewController:preVC animated:YES];
//    //获取本地文件路径
//    self.fileURL = [NSURL fileURLWithPath:[[NSBundle mainBundle]pathForResource:@"李碧华佳句赏析.doc" ofType:nil]];
//    [self presentViewController:self.previewController animated:YES completion:nil];
//    //刷新界面,如果不刷新的话，不重新走一遍代理方法，返回的url还是上一次的url
//    [self.previewController refreshCurrentPreviewItem];
}

//预览网络文件
- (IBAction)previewInternet:(id)sender {
    
  
}

//判断文件是否已经在沙盒中存在
-(BOOL) isFileExist:(NSString *)fileName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    NSString *filePath = [path stringByAppendingPathComponent:fileName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL result = [fileManager fileExistsAtPath:filePath];
    return result;
}

#pragma mark - QLPreviewControllerDataSource
-(id<QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index {
    return self.fileURL;
}

- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)previewController{
    return 1;
}



@end
