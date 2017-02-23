//
//  AppDelegate.m
//  ZBKit
//
//  Created by NQ UEC on 17/1/12.
//  Copyright © 2017年 Suzhibin. All rights reserved.
//

#import "AppDelegate.h"
#import "ZBKit.h"
#import "HomeViewController.h"
#import "ZBTarckingConfig.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
     NSLog(@"程序启动完成：%s",__func__);
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];

    self.window.backgroundColor=[UIColor whiteColor];
    
    NSString *cachePath = [[ZBCacheManager sharedInstance]cachesPath];
    NSLog(@"cachePath = %@",cachePath);
    
    //推送设置
    [self enablePush:[ZBGlobalSettingsTool sharedInstance].enabledPush];
    
    //配置跟踪监控
    [self TarckingConfig];


    HomeViewController * home= [[HomeViewController alloc]init];
    UINavigationController *nc=[[UINavigationController alloc]initWithRootViewController:home];
    self.window.rootViewController = nc;
    
    [self.window makeKeyAndVisible];

    //广告
    
    [ZBAdvertiseInfo getAdvertising:^(NSString *filePath,NSDictionary *urlDict,BOOL isExist){
        if (isExist) {
            ZBAdvertiseView *advertiseView = [[ZBAdvertiseView alloc] initWithFrame:self.window.bounds];
            advertiseView.filePath = filePath;
            advertiseView.linkdict = urlDict;
            
            NSLog(@"展示广告");
        }else{
            NSLog(@"无广告");
        }
    }];
    
   
    
    return YES;
}

- (void)TarckingConfig{
  
    //配置监控的页面
    [ZBTarckingConfig sharedInstance].VCDictionary= @{@"HomeViewController" : @"首页",@"FirstViewController" : @"网络请求页面",@"SecondViewController" : @"图片操作页面",@"ThirdViewController":@"数据库页面",@"FourViewController":@"开屏广告",@"FiveViewController":@"工厂方法",@"SettingViewController":@"设置页面",@"MenuViewController":@"菜单页面",@"ListViewController":@"列表页",@"DetailsViewController":@"详情页",@"DBViewController":@"数据库页面",@"SettingCacheViewController":@"缓存设置页面",@"ClearCacheViewController":@"清除缓存页面",@"offlineViewController":@"离线下载页面"};
    //配置要监控的点击事件  类名_方法名字_tag值 （方法名字注意:）
    [ZBTarckingConfig sharedInstance].actionDictionary= @{@"SecondViewController_btnClicked:_100" : @"垂直翻转",
          @"SecondViewController_btnClicked:_101" : @"水平翻转",
          @"SecondViewController_btnClicked:_102" : @"灰度图",
          @"SecondViewController_btnClicked:_103" : @"截图上部",
          @"SecondViewController_btnClicked:_104" : @"向左",
          @"SecondViewController_btnClicked:_105" : @"向右",
          @"SecondViewController_btnClicked:_106" : @"向下",
          @"SecondViewController_btnClicked:_107" : @"加水印",
          @"SecondViewController_btnClicked:_108" : @"给view截图",
          @"SecondViewController_btnClicked:_109" : @"平铺",
          @"SecondViewController_btnClicked:_110" : @"圆形并浮动",
          @"SecondViewController_btnClicked:_111" : @"Game over",
                                                          };
}
- (void)enablePush:(BOOL)enable{
    if(enable)
    {
        NSLog(@"应用内开启推送／不知道系统是否开启");
        //[self createPush];
        
    }else
    {
        NSLog(@"应用内关闭推送／不知道系统是否开启");
        //  [UMessage unregisterForRemoteNotifications];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    NSLog(@"将要释放焦点：%s",__func__);
    //保存数据
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    NSLog(@"已经进入后台：%s",__func__);
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    NSLog(@"将要进入前台：%s",__func__);
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     NSLog(@"已经获得焦点：%s",__func__);
    //恢复应用状态
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    NSLog(@"程序将要退出：%s",__func__);
}


@end
