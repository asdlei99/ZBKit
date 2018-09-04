//
//  ZBDebugWebViewController.m
//  ZBKit
//
//  Created by NQ UEC on 2018/4/25.
//  Copyright © 2018年 Suzhibin. All rights reserved.
//

#import "ZBDebugWebViewController.h"
#import <WebKit/WebKit.h>
#import "ZBFileModel.h"
@interface ZBDebugWebViewController ()<WKNavigationDelegate, WKUIDelegate>
@property (strong, nonatomic) WKWebView *wkWebView;
@property (strong, nonatomic) UITextView *textView;

@end

@implementation ZBDebugWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = self.model.fileName;
    
    [self createUI];
    [self loadFile];
}
- (void)createUI{
    if (self.model.isCanPreviewInWebView) {
        self.wkWebView = [[WKWebView alloc] initWithFrame:self.view.bounds];
        self.wkWebView.backgroundColor = [UIColor whiteColor];
        self.wkWebView.navigationDelegate = self;
        [self.view addSubview:self.wkWebView];
    } else {
        switch (self.model.type) {
            case ZBFileTypePList: {
                self.textView = [[UITextView alloc] initWithFrame:self.view.bounds];
                self.textView.editable = NO;
                self.textView.alwaysBounceVertical = YES;
                [self.view addSubview:self.textView];
                break;
            }
            default:
                //copyied by liman
                self.textView = [[UITextView alloc] initWithFrame:self.view.bounds];
                self.textView.editable = NO;
                self.textView.alwaysBounceVertical = YES;
                [self.view addSubview:self.textView];
                break;
        }
    }
}
- (void)loadFile {
    if (self.model.isCanPreviewInWebView) {
        if (@available(iOS 9.0, *)) {
            [self.wkWebView loadFileURL:self.model.URL allowingReadAccessToURL:self.model.URL];
        } else {
            // Fallback on earlier versions
            [self.wkWebView loadRequest:[NSURLRequest requestWithURL:self.model.URL]];
        }
    } else {
        switch (self.model.type) {
            case ZBFileTypePList: {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    NSData *data = [NSData dataWithContentsOfFile:self.model.URL.path];
                    
                    if (!data) {
                        //沙盒主目录.com.apple.mobile_container_manager.metadata.plist真机会崩溃 by liman
                        dispatch_async(dispatch_get_main_queue(), ^{
                            self.textView.text = @" unable to preview";
                            self.textView.backgroundColor = [UIColor blackColor];
                            self.textView.textColor = [UIColor whiteColor];
                            self.textView.font = [UIFont systemFontOfSize:17];
                        });
                    }else{
                        NSError *error;
                        NSString *content = [[NSPropertyListSerialization propertyListWithData:data options:kNilOptions format:nil error:&error] description];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            //liman
                            if (error) {
                                self.textView.text = @" unable to preview";
                                self.textView.backgroundColor = [UIColor blackColor];
                                self.textView.textColor = [UIColor whiteColor];
                                self.textView.font = [UIFont systemFontOfSize:17];
                            }else{
                                self.textView.text = content;
                                self.textView.backgroundColor = [UIColor whiteColor];
                                self.textView.textColor = [UIColor blackColor];
                                self.textView.font = [UIFont systemFontOfSize:12];
                            }
                        });
                    }
                });
                break;
            }
            default:
                //liman
                self.textView.text = @" unable to preview";
                self.textView.backgroundColor = [UIColor blackColor];
                self.textView.textColor = [UIColor whiteColor];
                self.textView.font = [UIFont systemFontOfSize:17];
                break;
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
