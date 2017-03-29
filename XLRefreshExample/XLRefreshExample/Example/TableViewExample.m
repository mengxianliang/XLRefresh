//
//  TableViewExample.m
//  XLRefreshExample
//
//  Created by MengXianLiang on 2017/3/28.
//  Copyright © 2017年 MengXianLiang. All rights reserved.
//

#import "TableViewExample.h"
#import "XLRefresh.h"

@interface TableViewExample ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
    UISegmentedControl *_segment;
}
@end

@implementation TableViewExample

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self buildTable];
}

-(void)buildTable
{
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:[UIView new]];
    //创建TableView
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height - 64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    //添加下拉刷新和上拉加载模块
    _tableView.xl_header = [XLRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshMethod)];
    _tableView.xl_footer = [XLRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreMethod)];
    
    //手动实现下拉/上拉
    _segment = [[UISegmentedControl alloc] initWithItems:@[@"手动刷新",@"手动加载"]];
    [_segment addTarget:self action:@selector(segmentMethod:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_segment];
}

#pragma mark -
#pragma mark 刷新/加载方法
-(void)refreshMethod{
    //方便测试延时两秒后执行隐藏操作
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [_tableView.xl_header endRefreshing];
        _segment.selectedSegmentIndex = -1;
    });
}

-(void)loadMoreMethod{
    //方便测试延时两秒后执行隐藏操作
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [_tableView.xl_footer endRefreshing];
        _segment.selectedSegmentIndex = -1;
    });
}

#pragma mark -
#pragma mark TableViewDelegate&DataSource

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
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
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.textLabel.text = [NSString stringWithFormat:@"第%zd行",indexPath.row];
    return cell;
}

-(void)segmentMethod:(UISegmentedControl*)seg{
    switch (seg.selectedSegmentIndex) {
        case 0:
            [_tableView.xl_header startRefreshing];
            break;
        case 1:
            [_tableView.xl_footer startRefreshing];
            break;
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
