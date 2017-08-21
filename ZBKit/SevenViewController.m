//
//  SevenViewController.m
//  ZBKit
//
//  Created by NQ UEC on 2017/4/25.
//  Copyright © 2017年 Suzhibin. All rights reserved.
//

#import "SevenViewController.h"
#import "ZBKit.h"
#import "NSArray+ZBKit.h"
// 主请求路径
#define budejieURL @"http://api.budejie.com/api/api_open.php"
@interface SevenViewController ()

@end

@implementation SevenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

   // [self filter];
    
    [self request];
  
}
- (void)filter{
    NSArray *cityArray = [NSArray arrayWithObjects:@"Shanghai",@"Hangzhou",@"Beijing",@"Macao",@"Taishan", nil];
    
    NSArray *arr=[cityArray zb_containElement:@"an"];
    NSLog(@"包含an元素:%@",arr);
    NSArray *arr1=[cityArray zb_beginsWithElement:@"M"];
    NSLog(@"已M开头:%@",arr1);
    NSArray *arr2=[cityArray zb_endsWithElement:@"an"];
    NSLog(@"an结尾:%@",arr2);
    NSArray *arr3=[cityArray zb_selfElement:@"Beijing"];
    NSLog(@"含有完整元素的数组:%@",arr3);
    
    NSArray *arabicArray = [NSArray arrayWithObjects:@1,@2,@3,@4,@5,@2,@6,@8,@10, nil];
    
    NSArray *arr4=[arabicArray zb_betweenAtIndex:4 index:6];
    
    NSLog(@"某范围之间:%@",arr4);
    
    NSArray *arr5=[arabicArray zb_greaterToCompare:4];
    NSLog(@"大于某值得:%@",arr5);
    
    NSArray *arr6=[arabicArray zb_lessToCompare:4];
    NSLog(@"小于某值得:%@",arr6);
    
    
    NSArray *array1 = [NSArray arrayWithObjects:@1,@2,@3,@5,@5,@6,@7, nil];
    
    NSArray *array2 = [NSArray arrayWithObjects:@4,@5, nil];
    NSArray *arr7=[array1 zb_filterArray:array2];
    NSLog(@"俩个数组相同的值 返回得数组:%@",arr7);
}

- (void)request{
    NSDictionary *dict=@{@"a":@"tag_recommend",@"c":@"topic",@"action":@"sub"};
    
    [ZBRequestManager requestWithConfig:^(ZBURLRequest *request) {
        request.urlString=budejieURL;
        request.parameters=dict;
    } success:^(id responseObj, apiType type) {
        //  NSLog(@"responseObj：%@",responseObj);
     //   NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingMutableContainers error:nil];
        // NSLog(@"dict：%@",dict);
        
    } failed:^(NSError *error) {
        
    }];
    
    
    [ZBRequestManager requestWithConfig:^(ZBURLRequest *request) {
        request.urlString=budejieURL;
        request.parameters=dict;
    } success:^(id responseObj, apiType type) {
        
     //   NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingMutableContainers error:nil];
        //  NSLog(@"dict：%@",dict);
    } failed:^(NSError *error) {
        
    }];
    
    
    
    
     NSMutableDictionary *parameters=[[NSMutableDictionary alloc]init];
     
     [parameters setValue:@"0" forKey:@"launchCount"];
     [parameters setValue:@"zh_CN" forKey:@"assignLang"];
     [parameters setValue:@"1001" forKey:@"channelId"];
     [parameters setValue:@"D53AA748-7AD3-47A5-B11C-5CC216518471" forKey:@"userId"];
     
     [ZBRequestManager requestWithConfig:^(ZBURLRequest *request) {
     request.urlString=@"http://192.168.33.186:9080/BOSS_APD_WEB/user/information";
     request.methodType=ZBMethodTypePOST;
     request.parameters=parameters;
     } success:^(id responseObj, apiType type) {
       NSLog(@"postresponseObj:%@",responseObj);
     
     NSDictionary * dataDict = [NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"post:%@",dataDict);
     } failed:^(NSError *error) {
        NSLog(@"posterror:%@",error);
     }];
    
    /*
     [ZBURLSessionManager requestWithConfig:^(ZBURLRequest *request) {
     request.urlString=@"";
     request.methodType=POST;
     request.parameters=parameters;
     } success:^(id responseObj, apiType type) {
     NSLog(@"postresponseObj1:%@",responseObj);
     
     id dataDict = [NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingMutableContainers error:nil];
     NSLog(@"post1:%@",dataDict);
     
     } failed:^(NSError *error) {
     NSLog(@"posterror1:%@",error);
     }];
     */
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