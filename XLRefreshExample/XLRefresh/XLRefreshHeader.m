//
//  XLRefreshHeader.m
//  XLRefreshExample
//
//  Created by MengXianLiang on 2017/3/27.
//  Copyright © 2017年 MengXianLiang. All rights reserved.
//

#import "XLRefreshHeader.h"

@implementation XLRefreshHeader

+(XLRefreshHeader*)headerWithRefreshingBlock:(XLRefreshingBlock)block{
    XLRefreshHeader *header = [[XLRefreshHeader alloc] init];
    header.refreshingBlock = block;
    header.stateTitle = @{XLStatePullingKey:@"下拉即可刷新",
                          XLStateWillRefreshKey:@"释放刷新...",
                          XLStateRefreshingKey:@"正在刷新..."};
    return header;
}

+(XLRefreshHeader*)headerWithRefreshingTarget:(id)target refreshingAction:(SEL)action{
    XLRefreshHeader *header = [[XLRefreshHeader alloc] init];
    [header setRefreshingTarget:target refreshingAction:action];
    header.stateTitle = @{XLStatePullingKey:@"下拉即可刷新",
                          XLStateWillRefreshKey:@"释放刷新...",
                          XLStateRefreshingKey:@"正在刷新..."};
    return header;
}

-(void)updateRect{
    [super updateRect];
    
    self.frame = CGRectMake(0, -XLRefreshHeight,_scrollView.bounds.size.width, XLRefreshHeight);
    
}

-(void)scrollViewContentOffsetDidChange:(NSDictionary *)change{
    
    [super scrollViewContentOffsetDidChange:change];
    //向上滑动不执行以下方法
    if (_scrollView.contentOffset.y > 0) {return;}
    //拖拽的距离
    CGFloat distance = fabs(_scrollView.contentOffset.y + _scrollViewOriginalInset.top);
    //居中显示
    self.center = CGPointMake(self.center.x, -distance/2.0f);
    //刷新中不执行以下方法
    if (self.state == XLRefreshStateRefreshIng) {return;}
    //保留缩进
    _scrollViewOriginalInset = _scrollView.contentInset;
    //动画进度
    self.refreshProgress = distance/XLRefreshHeight;
    //拖拽时 当拖拽距离大于header的高度时 状态切换成准备拖拽的状态
    if (_scrollView.isDragging) {
        if (distance <= XLRefreshHeight){
            self.state = XLRefreshStatePulling;
        }else{
            self.state = XLRefreshStateWillRefresh;
        }
    }else{//松手后，如果已经到达可以刷新的状态 则进行刷新
        if (self.state == XLRefreshStateWillRefresh) {
            [self startRefreshing];
        }
    }
}

-(void)startRefreshing{
    [super startRefreshing];
    [UIView animateWithDuration:XLRefreshAnimationDuration animations:^{
        CGFloat top = _scrollViewOriginalInset.top + self.bounds.size.height;
        _scrollView.contentInset = UIEdgeInsetsMake(top, 0, 0, 0);
        [_scrollView setContentOffset:CGPointMake(0, -top) animated:false];
    }];
}

-(void)endRefreshing{
    [super endRefreshing];
    [UIView animateWithDuration:XLRefreshAnimationDuration animations:^{
        [_scrollView setContentInset:_scrollViewOriginalInset];
        self.frame = CGRectMake(0, -XLRefreshHeight, self.bounds.size.width, self.bounds.size.height);
    }];
}

@end
