//
//  ViewController.m
//  XLRefreshExample
//
//  Created by MengXianLiang on 2017/3/27.
//  Copyright © 2017年 MengXianLiang. All rights reserved.
//

#import "ViewController.h"
#import "XLRefresh.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self buildTable];
}

-(void)buildTable
{
    self.view.backgroundColor = [UIColor whiteColor];
    //防止UIScrollView和Navigation冲突问题
    [self.view addSubview:[UIView new]];
    
    self.title = @"XLRefresh";
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height - 64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    _tableView.xl_header = [XLRefreshHeader headerWithRefreshingBlock:^{
        [self refreshMethod];
        NSLog(@"刷新方法");
    }];
    
    _tableView.xl_footer = [XLRefreshFooter footerWithRefreshingBlock:^{
        [self loadMore];
        NSLog(@"加载更多方法");
    }];
}

#pragma mark -
#pragma mark 其他方法
-(void)refreshMethod{
    NSLog(@"刷新方法");
}

-(void)loadMore{
    NSLog(@"加载更多方法");
}



#pragma mark -
#pragma mark TableViewDelegate&DataSource

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* cellIdentifier = @"cell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"第%zd行",indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView.xl_header isRefreshing]) {
        [tableView.xl_header endRefreshing];
    }
    
    if ([tableView.xl_footer isRefreshing]){
        [tableView.xl_footer endRefreshing];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
