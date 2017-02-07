//
//  ZBGlobalSettingsTool.m
//  ZBKit
//
//  Created by NQ UEC on 17/2/6.
//  Copyright © 2017年 Suzhibin. All rights reserved.
//

#import "ZBGlobalSettingsTool.h"
#import "sys/utsname.h"
#import <UIKit/UIKit.h>
@implementation ZBGlobalSettingsTool

+ (ZBGlobalSettingsTool*)sharedInstance
{
    static ZBGlobalSettingsTool *settingInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        settingInstance = [[self alloc] init];
    });
    return settingInstance;
    
}

- (id)init{
    self = [super init];
    if (self) {
        self.enabledPush = YES;
        
    }
    return self;
}

- (BOOL)getNightPattern{
    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"readStyle"]) {
        //  NSLog(@"夜间模式");
        return YES;
    }else{
        //    NSLog(@"日间模式");
        return NO;
    }
}
- (BOOL)downloadImagePattern{
    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"readImage"]) {
        //NSLog(@"仅WIFI网络下载图片");
        return YES;
    }else{
        // NSLog(@"所有网络都可以下载图片");
        return NO;
    }
}

- (int)getArticleFontSize {
    switch (self.fontSize) {
        case 0:
            return 14;
            break;
        case 1:
            return 16;
            break;
        case 2:
            return 20;
            break;
            
        default:
            return 15;
            break;
    }
}

- (void)openSettings{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
}

- (void)openURL:(NSString *)APPID{
    NSString *appstr=[NSString stringWithFormat:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@",APPID];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appstr]];
}

- (NSString *)appBundleName {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"];
}

- (NSString *)appBundleID {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleIdentifier"];
}

- (NSString *)appVersion {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
}

- (NSString *)appBuildVersion {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
}

- (NSString *)machineName {
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    return deviceString;
}


@end