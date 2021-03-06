//
//  LanguageViewController.m
//  ZBNews
//
//  Created by NQ UEC on 16/11/18.
//  Copyright © 2016年 Suzhibin. All rights reserved.
//

#import "LanguageViewController.h"
#import "ZBKit.h"
#import "AppDelegate.h"
#import "HomeViewController.h"

@interface LanguageViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong)UITableView *tableView;
@end

@implementation LanguageViewController
- (void)dealloc{
    NSLog(@"释放%s",__func__);
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor whiteColor];
    
 
    [self.view addSubview:self.tableView];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIde=@"cellIde";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIde];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIde];
    }
    if (indexPath.row==0) {
        cell.textLabel.text=ZBLocalized(@"content1",nil);
    }
    
    if (indexPath.row==1) {
        cell.textLabel.text=@"中文简体";
    }
    if (indexPath.row==2) {
        cell.textLabel.text=@"英文";
    }
    if (indexPath.row==3) {
        cell.textLabel.text=@"中文繁体";
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row==0) {

        [[ZBLocalized sharedInstance]systemLanguage];
    }
    if (indexPath.row==1) {

        [[ZBLocalized sharedInstance]setLanguage:@"zh-Hans"];
        
    }
    if (indexPath.row==2) {
 
        [[ZBLocalized sharedInstance]setLanguage:@"en"];

    }
    if (indexPath.row==3) {
        
        [[ZBLocalized sharedInstance]setLanguage:@"zh-Hant"];
    }
    
    [self initRootVC];
    NSString *language=[[ZBLocalized sharedInstance]currentLanguage];
    NSLog(@"当前语言:%@",language);

 
   
}
- (void)initRootVC{
    ZBTabBarController *tab=[[ZBTabBarController alloc]init];
    tab.selectedIndex=4;
    [UIApplication sharedApplication].keyWindow.rootViewController = tab;
    
}
//懒加载
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, ZB_SCREEN_WIDTH, ZB_SCREEN_HEIGHT-64) style:UITableViewStylePlain];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.tableFooterView=[[UIView alloc]init];
    }
    return _tableView;
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
