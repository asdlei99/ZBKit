//
//  SettingViewController.m
//  ZBKit
//
//  Created by NQ UEC on 17/2/14.
//  Copyright © 2017年 Suzhibin. All rights reserved.
//

#import "SettingViewController.h"
#import "ZBGlobalSettingsTool.h"
#import <MessageUI/MessageUI.h>
#import "NSBundle+ZBKit.h"
#import "ZBNetworking.h"
#import <UIImageView+WebCache.h>
#import "StorageSpaceViewController.h"
#import "LanguageViewController.h"
#import <StoreKit/StoreKit.h>
@interface SettingViewController ()<MFMailComposeViewControllerDelegate,SKStoreProductViewControllerDelegate>

@end

@implementation SettingViewController
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    // 1.第0租
    [self add0SectionItems];
    // 2.第1组
    [self add1SectionItems];
    // 3.第2组
    [self add2SectionItems];
    // 4.第3组
    [self add3SectionItems];
   
}

#pragma mark - 设置页面
- (void)add0SectionItems{
    __weak typeof(self) weakSelf = self;
    
    // 账号
    //itemWithIcon
    //itemWithTitle
    ZBTableItem *IDItem = [ZBTableItem itemWithIcon:[NSBundle zb_IDInfo] title:ZBLocalized(@"ID",nil) type:ZBTableItemTypeArrow];
    IDItem.operation = ^{
        UIViewController *helpVC = [[UIViewController alloc] init];
        helpVC.view.backgroundColor = [UIColor grayColor];
        helpVC.title = @"账号管理";
        [weakSelf.navigationController pushViewController:helpVC animated:YES];
    };
//    ZBTableItem *nameItem = [ZBTableItem itemWithIcon:[NSBundle zb_IDInfo] title:@"昵称" type:ZBTableItemTypeTextField];
//    nameItem.operation = ^{
//
//    };
    // 字体
    ZBTableItem *fontItem  = [ZBTableItem itemWithIcon:[NSBundle zb_MoreHelp] title:ZBLocalized(@"fontSize",nil) type:ZBTableItemTypeRightText];
    fontItem.rightText=[self setFont];
    __block ZBTableItem *weakFont = fontItem;
    fontItem.operation = ^{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"设置字体大小" message:@"" preferredStyle:(UIAlertControllerStyleActionSheet)];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil];
        UIAlertAction *defult = [UIAlertAction actionWithTitle:@"小" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *_Nonnull action){
            [ZBGlobalSettingsTool sharedInstance].fontSize=0;
            weakFont.rightText=[weakSelf setFont];
            [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:1 inSection:0],nil] withRowAnimation:UITableViewRowAnimationTop];
        }];
        UIAlertAction *defult1 = [UIAlertAction actionWithTitle:@"中" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action){
            [ZBGlobalSettingsTool sharedInstance].fontSize=1;
            weakFont.rightText=[weakSelf setFont];
            [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:1 inSection:0],nil] withRowAnimation:UITableViewRowAnimationTop];
        }];
        UIAlertAction *defult2 = [UIAlertAction actionWithTitle:@"大" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *_Nonnull action){
            [ZBGlobalSettingsTool sharedInstance].fontSize=2;
            weakFont.rightText=[weakSelf setFont];
            [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:1 inSection:0],nil] withRowAnimation:UITableViewRowAnimationTop];
        }];
        [alert addAction:cancel];
        [alert addAction:defult];
        [alert addAction:defult1];
        [alert addAction:defult2];
        [weakSelf presentViewController:alert animated:YES completion:nil]; //呈现
    };
    
    ZBTableItem *langItem = [ZBTableItem itemWithTitle:ZBLocalized(@"language",nil) type:ZBTableItemTypeArrow];
    langItem.operation = ^{
        LanguageViewController *languageView=[[LanguageViewController alloc]init];

        //cityVC.currentCity=sender.titleLabel.text;
        ZBNavigationController *nav = [[ZBNavigationController alloc] initWithRootViewController:languageView];
        ZBTabBarController * rootView = (ZBTabBarController *)[[UIApplication sharedApplication].delegate window].rootViewController;
        [rootView presentViewController:nav animated:YES completion:nil];

      //  [weakSelf presentViewController:languageView animated:YES completion:nil];
       // [weakSelf.navigationController pushViewController:languageView animated:YES];
    };
    
    ZBTableGroup *group = [[ZBTableGroup alloc] init];
    group.items = @[IDItem,fontItem,langItem];
    group.headerHeight=5;
    group.footerHeight=5;
    [_allGroups addObject:group];
    
    
}
- (void)add1SectionItems{
    __weak typeof(self) weakSelf = self;
    
    // 1.1.推送和提醒
    ZBTableItem *pushItem = [ZBTableItem itemWithTitle:ZBLocalized(@"push",nil) type:ZBTableItemTypeSwitch];
    
    __block ZBTableItem *weakPush = pushItem;
    UIUserNotificationSettings *setting = [[UIApplication sharedApplication] currentUserNotificationSettings];
    if(UIUserNotificationTypeNone != setting.types) {//系统开启
        pushItem.isOpenSwitch=[ZBGlobalSettingsTool sharedInstance].enabledPush;
        pushItem.switchBlock = ^(BOOL on) {
            NSLog(@"通知%d",on);
            [ZBGlobalSettingsTool sharedInstance].enabledPush=on;
        };
        
    }else{
        
        pushItem.isOpenSwitch=NO;
        pushItem.switchBlock = ^(BOOL on) {
            NSLog(@"通知%d",on);
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"你尚末开启系统推送" message:@"" preferredStyle:(UIAlertControllerStyleAlert)];
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction *_Nonnull action){
                weakPush.isOpenSwitch=NO;
                [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:0 inSection:1],nil] withRowAnimation:UITableViewRowAnimationFade];
            }];
            UIAlertAction *defult = [UIAlertAction actionWithTitle:@"去开启" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *_Nonnull action){
                
                [[ZBGlobalSettingsTool sharedInstance] openSettings];//跳转设置页面
            }];
            
            [alert addAction:cancel];
            [alert addAction:defult];
            [weakSelf presentViewController:alert animated:YES completion:nil]; //呈现
        };
    }
    
    ZBTableGroup *group1 = [[ZBTableGroup alloc] init];
    group1.items = @[pushItem];
    group1.headerHeight=5;
    group1.footerHeight=5;
    [_allGroups addObject:group1];
    
}

- (void)add2SectionItems{
    
    __weak typeof(self) weakSelf = self;
    
    NSString *title=nil;
    if ([[ZBGlobalSettingsTool sharedInstance] getNightPattern]==YES) {
        title=ZBLocalized(@"daytimemode",nil);
        
    }else{
        title=ZBLocalized(@"nightmode",nil);
    }
    
    // 夜间模式
    ZBTableItem *nightItem = [ZBTableItem itemWithTitle:title type:ZBTableItemTypeSwitch];
    __block ZBTableItem *weakNight = nightItem;
    nightItem.isOpenSwitch=[[ZBGlobalSettingsTool sharedInstance] getNightPattern];
    nightItem.switchBlock = ^(BOOL on) {
        
        on = [[NSUserDefaults standardUserDefaults]boolForKey:@"readStyle"];
        [[NSUserDefaults standardUserDefaults]setBool:!on forKey:@"readStyle"];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [[NSNotificationCenter defaultCenter]postNotificationName:READStyle object:[NSString stringWithFormat:@"%d",[[NSUserDefaults standardUserDefaults]boolForKey:@"readStyle"]]];
        
        weakNight.title=title;
        if ([[ZBGlobalSettingsTool sharedInstance] getNightPattern]==YES) {
            NSLog(@"夜间模式");
            
        }else{
            NSLog(@"日间模式");
        }
    };
    
    // Wifi
    ZBTableItem *wifiItem = [ZBTableItem itemWithTitle:ZBLocalized(@"wifi",nil) type:ZBTableItemTypeSwitch];
    wifiItem.isOpenSwitch=[[ZBGlobalSettingsTool sharedInstance] downloadImagePattern];
    wifiItem.switchBlock = ^(BOOL on) {
        
        on = [[NSUserDefaults standardUserDefaults]boolForKey:@"readImage"];
        [[NSUserDefaults standardUserDefaults]setBool:!on forKey:@"readImage"];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [[NSNotificationCenter defaultCenter]postNotificationName:READIMAGE object:[NSString stringWithFormat:@"%d",[[NSUserDefaults standardUserDefaults]boolForKey:@"readImage"]]];
        
    };
    
    // 存储空间
    ZBTableItem *cacheItem= [ZBTableItem itemWithTitle:ZBLocalized(@"clearcache",nil) type:ZBTableItemTypeArrow];
    
    cacheItem.operation = ^{
        StorageSpaceViewController *spaceVC=[[StorageSpaceViewController alloc]init];
        [weakSelf.navigationController pushViewController:spaceVC animated:YES];
        
    };
    
    ZBTableGroup *group2 = [[ZBTableGroup alloc] init];
    group2.headerHeight=5;
    group2.footerHeight=5;
    group2.items = @[nightItem,wifiItem,cacheItem];
    [_allGroups addObject:group2];
    
}
- (void)add3SectionItems{
    __weak typeof(self) weakSelf = self;
    
    //去评分
    ZBTableItem *openItem = [ZBTableItem itemWithTitle:ZBLocalized(@"rate_Me",nil) type:ZBTableItemTypeArrow];
    openItem.operation = ^{
        if ([UIDevice currentDevice].systemVersion.floatValue >= 10.3) {
            SKStoreProductViewController *storeProductVC =[[SKStoreProductViewController alloc]init];
            storeProductVC.delegate =self;
            
            // 第一个参数为应用标识(appid NSNumber类型)构成的字典。第二个参数是一个block回调。
            [storeProductVC loadProductWithParameters:@{SKStoreProductParameterITunesItemIdentifier:@(123456789)}completionBlock:^(BOOL result,NSError *error) {
                
                if (result) {
                    [self presentViewController:storeProductVC animated:YES completion:nil];
                }else{
                    NSLog(@"错误：%@" ,error);
                }
            }];
            
        }else{
            [[ZBGlobalSettingsTool sharedInstance]openURL:@"123456789"];
        }
        
    };
    
    //意见反馈
    ZBTableItem *feedbackItem = [ZBTableItem itemWithIcon:[NSBundle zb_MoreMessage] title:ZBLocalized(@"feedback",nil) type:ZBTableItemTypeArrow];
    feedbackItem.operation = ^{
        [weakSelf createMail];
    };
    
    // 分享
    ZBTableItem *shareItem = [ZBTableItem itemWithIcon:[NSBundle zb_MoreShare] title:ZBLocalized(@"share",nil) type:ZBTableItemTypeArrow];
    shareItem.operation = ^{
      
    };
    // 关于about
    ZBTableItem *aboutItem = [ZBTableItem itemWithIcon:[NSBundle zb_MoreAbout] title:ZBLocalized(@"about",nil) type:ZBTableItemTypeArrow];
    
    aboutItem.operation = ^{
        NSString *aboutString=[NSString stringWithFormat:@"应用名字:%@\n应用ID:%@\n应用版本:%@\n应用build:%@\n设备名字:%@",[[ZBGlobalSettingsTool sharedInstance]appBundleName],[[ZBGlobalSettingsTool sharedInstance]appBundleID],[[ZBGlobalSettingsTool sharedInstance]appVersion],[[ZBGlobalSettingsTool sharedInstance]appBuildVersion],[[ZBGlobalSettingsTool sharedInstance]deviceName]];
        UIViewController *helpVC = [[UIViewController alloc] init];
        UILabel *abotlabel=[[UILabel alloc]initWithFrame:CGRectMake(20, 100, ZB_SCREEN_WIDTH-40, 200)];
        abotlabel.text=aboutString;
        abotlabel.numberOfLines=0;
        [helpVC.view addSubview:abotlabel];
        helpVC.view.backgroundColor = [UIColor brownColor];
        helpVC.title = @"关于";
        [weakSelf.navigationController pushViewController:helpVC animated:YES];
    };
    
    ZBTableGroup *group3 = [[ZBTableGroup alloc] init];
    group3.items = @[openItem, feedbackItem, shareItem , aboutItem];
    group3.headerHeight=35;
    group3.footerHeight=25;
    group3.header=@"基本设置";
    group3.footer=@"footer";
    [_allGroups addObject:group3];
    
}

- (NSString *)setFont{
    switch ([ZBGlobalSettingsTool sharedInstance].fontSize) {
        case 0:
            return  [NSString stringWithFormat:@"小"];
            break;
        case 1:
            return [NSString stringWithFormat:@"中"];
            break;
        case 2:
            return  [NSString stringWithFormat:@"大"];
            break;
        default:
            return [NSString stringWithFormat:@"中"];
            break;
    }
    
}

#pragma mark - mail delegate
- (void)createMail
{
    MFMailComposeViewController *mail = [[MFMailComposeViewController alloc] init];
    //判断是否支持发送邮件的功能
    if ([MFMailComposeViewController canSendMail]) {
        //设置邮件的主题
        [mail setSubject:@"ZBKit反馈"];
        //设置收件人(设置一组)
        [mail  setToRecipients:[NSArray arrayWithObjects:@"szb2323@163.com",nil]];
        //设置邮件的正文,是否解析正文中的html标签
        NSString *aboutString=[NSString stringWithFormat:@"%@%@/%@/%@",[[ZBGlobalSettingsTool sharedInstance]appBundleName],[[ZBGlobalSettingsTool sharedInstance]appVersion],[[UIDevice currentDevice] systemVersion],[[ZBGlobalSettingsTool sharedInstance]deviceName]];
        [mail setMessageBody:aboutString isHTML:NO];
        //设置代理
        mail.mailComposeDelegate = self;
        //添加图片附件
        UIImage *image = [UIImage imageNamed:@"handShake.png"];
        //转成NData
        NSData *data = UIImagePNGRepresentation(image);
        //添加附件 mimeType 附件的类型  fileName:图片的名称
        [mail addAttachmentData:data mimeType:@"file/png" fileName:@"handShake.png"];
        [self presentViewController:mail animated:YES completion:^{
            
        }];
    }else{
        NSLog(@"不支持发邮件");
    }
    
}
//用于接收邮件的状态
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    switch (result) {
        case MFMailComposeResultCancelled:
        {
            NSLog(@"mailCancel!");
        }
            break;
        case MFMailComposeResultFailed:
        {
            NSLog(@"mail failed!");
        }break;
        case MFMailComposeResultSaved:{
            NSLog(@"mail Save!");
        }break;
        case MFMailComposeResultSent:{
            NSLog(@"mail send!");
        }
        default:
            break;
    }
    [controller dismissViewControllerAnimated:YES completion:^{
        
    }];
}
// SKStoreProductViewController代理方法
- (void)productViewControllerDidFinish:(SKStoreProductViewController*)viewController
{
    //返回上一个页面
    [self dismissViewControllerAnimated:YES completion:nil];
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
