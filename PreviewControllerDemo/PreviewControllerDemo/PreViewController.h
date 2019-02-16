//
//  PreViewController.h
//  PreviewControllerDemo
//
//  Created by Apple on 2019/2/13.
//  Copyright © 2019 hty. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuickLook/QuickLook.h>

NS_ASSUME_NONNULL_BEGIN

@interface PreViewController : UIViewController
//预览网络文件
- (void) previewInternet:(NSString *) urlStr;
-(void) previewLocal:(NSURL *) filePath;
@end

NS_ASSUME_NONNULL_END
