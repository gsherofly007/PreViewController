//
//  PreViewController.m
//  PreviewControllerDemo
//
//  Created by Apple on 2019/2/13.
//  Copyright © 2019 hty. All rights reserved.
//

#import "PreViewController.h"
#import <QuickLook/QuickLook.h>
#import <AFNetworking.h>
#import <SVProgressHUD.h>
#define CreateButtonOnNavigationBarWithImage(imageNameStr , aTarget , aAction) [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:imageNameStr] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:aTarget action:aAction]
@interface PreViewController () <QLPreviewControllerDataSource>
@property (strong, nonatomic)QLPreviewController *previewController;
@property (copy, nonatomic)NSURL *fileURL; //文件路径
@end

@implementation PreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = CreateButtonOnNavigationBarWithImage(@"icon_new_back", self, @selector(cancel));
    self.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"预览";
    self.previewController  =  [[QLPreviewController alloc]  init];
    self.previewController.dataSource  = self;
    self.previewController.view.frame= CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    
    [self addChildViewController:self.previewController];
    [self.view addSubview:self.previewController.view];
    [self.previewController didMoveToParentViewController:self];
    [self.view addSubview:self.previewController.view];
}
-(void) cancel{
    [self dismissViewControllerAnimated:true completion:nil];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
//预览网络文件
- (void) previewInternet:(NSString *) urlStr{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
//    NSString *urlStr = @"https://ceshi-im-buckname.obs.cn-north-1.myhuaweicloud.com/1549934116393_y0cj4bml9k.txt";
    //    NSString *urlStr = @"https://www.tutorialspoint.com/ios/ios_tutorial.pdf";
    NSString *fileName = [urlStr lastPathComponent]; //获取文件名称
    NSURL *URL = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    //判断是否存在
    if([self isFileExist:fileName]) {
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        NSURL *url = [documentsDirectoryURL URLByAppendingPathComponent:fileName];
        self.fileURL = url;
        [self presentViewController:self.previewController animated:YES completion:nil];
        //刷新界面,如果不刷新的话，不重新走一遍代理方法，返回的url还是上一次的url
        [self.previewController refreshCurrentPreviewItem];
    }else {
        [SVProgressHUD showWithStatus:@"下载中"];
        NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress *downloadProgress){
            
        } destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
            NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
            NSURL *url = [documentsDirectoryURL URLByAppendingPathComponent:fileName];
            return url;
        } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
            [SVProgressHUD dismiss];
            self.fileURL = filePath;
            [self presentViewController:self.previewController animated:YES completion:nil];
            //刷新界面,如果不刷新的话，不重新走一遍代理方法，返回的url还是上一次的url
            [self.previewController refreshCurrentPreviewItem];
        }];
        [downloadTask resume];
    }
}
-(void) previewLocal:(NSURL *) filePath{
    //获取本地文件路径
    self.fileURL = filePath;
//    [self presentViewController:self.previewController animated:YES completion:nil];
//    刷新界面,如果不刷新的话，不重新走一遍代理方法，返回的url还是上一次的url
    [self.previewController refreshCurrentPreviewItem];
  
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
