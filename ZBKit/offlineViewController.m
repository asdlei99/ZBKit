//
//  offlineViewController.m
//  ZBKit
//
//  Created by NQ UEC on 17/1/24.
//  Copyright © 2017年 Suzhibin. All rights reserved.
//

#import "offlineViewController.h"
#import "ZBNetworking.h"
#import "MenuModel.h"
#import "APIConstants.h"
@interface offlineViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *dataArray;

@property (nonatomic,strong)ZBBatchRequest *batchRequest;
@end

@implementation offlineViewController
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    NSLog(@"离开页面时 清空容器");
    [self.batchRequest removeOfflineArray];
    
    [self.delegate reloadJsonNumber];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.dataArray=[[NSMutableArray alloc]init];
    
    self.batchRequest=[[ZBBatchRequest alloc]init];
    
    [ZBRequestManager requestWithConfig:^(ZBURLRequest *request) {
        request.urlString=menu_URL;
        request.apiType=ZBRequestTypeRefresh;
    } success:^(id responseObj, apiType type) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingMutableContainers error:nil];
        
        NSArray *array=[dict objectForKey:@"authors"];
        
        for (NSDictionary *dic in array) {
            MenuModel *model=[[MenuModel alloc]init];
            model.name=[dic objectForKey:@"name"];
            model.wid=[dic objectForKey:@"id"];
            [self.dataArray addObject:model];
            
        }
        [_tableView reloadData];
    } failed:^(NSError *error) {
        if (error.code==NSURLErrorCancelled)return;
        if (error.code==NSURLErrorTimedOut) {
            [self alertTitle:@"请求超时" andMessage:@""];
        }else{
            [self alertTitle:@"请求失败" andMessage:@""];
        }
    }];
    
    
    [self.view addSubview:self.tableView];
    
    [self addItemWithTitle:@"离线下载" selector:@selector(offlineBtnClick) location:NO];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIde=@"cellIde";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIde];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIde];
    }
    UISwitch *sw = [[UISwitch alloc] init];
    sw.center = CGPointMake(160, 90);
    sw.tag = indexPath.row;
    [sw addTarget:self action:@selector(switchValueChanged:) forControlEvents:UIControlEventValueChanged];
    cell.accessoryView = sw;
    
    MenuModel *model=[self.dataArray objectAtIndex:indexPath.row];
    cell.textLabel.text=model.name;
    return cell;
}

- (void)switchValueChanged:(UISwitch *)sw{
    MenuModel *model=[self.dataArray objectAtIndex:sw.tag];
    NSString *url=[NSString stringWithFormat:list_URL,model.wid];
    
    if (sw.isOn == YES) {
        //添加请求列队
        [self.batchRequest addObjectWithUrl:url];
        [self.batchRequest addObjectWithKey:model.name];
        NSLog(@"离线请求的url:%@",self.batchRequest.offlineUrlArray);
    }else{
        //删除请求列队
        [self.batchRequest removeObjectWithUrl:url];
        [self.batchRequest removeObjectWithKey:model.name];
        NSLog(@"离线请求的url:%@",self.batchRequest.offlineUrlArray);
    }
}

- (void)offlineBtnClick{
    
    if (self.batchRequest.offlineUrlArray.count==0) {
        
        [self alertTitle:@"请添加栏目" andMessage:@""];
        
    }else{
        
        NSLog(@"离线请求的栏目/url个数:%lu",self.batchRequest.offlineUrlArray.count);
        
        for (NSString *name in self.batchRequest.offlineKeyArray) {
            NSLog(@"离线请求的name:%@",name);
        }
        
        [self.delegate downloadWithArray:self.batchRequest.offlineUrlArray];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

//懒加载
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
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
