//
//  CollectionViewExample.m
//  XLRefreshExample
//
//  Created by MengXianLiang on 2017/3/28.
//  Copyright © 2017年 MengXianLiang. All rights reserved.
//

#import "CollectionViewExample.h"
#import "XLRefresh.h"

@interface CollectionViewExample ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    UICollectionView *_collectionView;
    UISegmentedControl *_segment;
}
@end

@implementation CollectionViewExample

- (void)viewDidLoad {
    [super viewDidLoad];
    [self buildUI];
}

-(void)buildUI{
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:[UIView new]];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(100, 100);
    layout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height - 64) collectionViewLayout:layout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
    [self.view addSubview:_collectionView];
    
    _collectionView.xl_header = [XLRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshMethod)];
    _collectionView.xl_footer = [XLRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreMethod)];
    
    
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
        [_collectionView.xl_header endRefreshing];
        _segment.selectedSegmentIndex = -1;
    });
}

-(void)loadMoreMethod{
    //方便测试延时两秒后执行隐藏操作
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [_collectionView.xl_footer endRefreshing];
        _segment.selectedSegmentIndex = -1;
    });
}

-(void)segmentMethod:(UISegmentedControl*)seg{
    switch (seg.selectedSegmentIndex) {
        case 0:
            [_collectionView.xl_header startRefreshing];
            break;
        case 1:
            [_collectionView.xl_footer startRefreshing];
            break;
        default:
            break;
    }
}

#pragma mark -
#pragma mark CollectionViewDataSource

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 30;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"UICollectionViewCell";
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    cell.backgroundColor = self.navigationController.navigationBar.tintColor;
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
