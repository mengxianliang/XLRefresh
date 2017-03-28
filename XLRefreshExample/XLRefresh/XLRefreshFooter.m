//
//  XLRefreshFooter.m
//  XLRefreshExample
//
//  Created by MengXianLiang on 2017/3/27.
//  Copyright © 2017年 MengXianLiang. All rights reserved.
//

#import "XLRefreshFooter.h"

@implementation XLRefreshFooter

+(XLRefreshFooter*)footerWithRefreshingBlock:(XLRefreshingBlock)block{
    XLRefreshFooter *footer = [[XLRefreshFooter alloc] init];
    footer.refreshingBlock = block;
    footer.stateTitle = @{XLStatePullingKey:@"上拉即可加载",
                          XLStateWillRefreshKey:@"释放加载...",
                          XLStateRefreshingKey:@"正在加载..."};
    return footer;
}

+(XLRefreshFooter*)footerWithRefreshingTarget:(id)target refreshingAction:(SEL)action{
    XLRefreshFooter *footer = [[XLRefreshFooter alloc] init];
    [footer setRefreshingTarget:target refreshingAction:action];
    footer.stateTitle = @{XLStatePullingKey:@"下拉即可刷新",
                          XLStateWillRefreshKey:@"释放刷新...",
                          XLStateRefreshingKey:@"正在刷新..."};
    return footer;
}

-(void)updateRect{
    [super updateRect];
    self.frame = CGRectMake(0, _scrollView.contentSize.height,_scrollView.bounds.size.width, XLRefreshFooterHeight);
}

-(void)scrollViewContentOffsetDidChange:(NSDictionary *)change{
    [super scrollViewContentOffsetDidChange:change];
    //拖拽距离
    CGFloat dragHeight = _scrollView.contentOffset.y + _scrollView.bounds.size.height;
    //滚动最大距离
    CGFloat contentHeight = _scrollView.contentSize.height;
    if (dragHeight < contentHeight) {return;}
    CGFloat distance = fabs(dragHeight - contentHeight);
    //居中显示
    self.center = CGPointMake(self.center.x, contentHeight + distance/2.0f);
    if (self.state == XLRefreshStateRefreshIng) {return;}
    //动画进度
    self.refreshProgress = distance/XLRefreshHeaderHeight;
    //拖拽时 当拖拽距离大于header的高度时 状态切换成准备拖拽的状态
    if (_scrollView.isDragging) {
        if (distance <= XLRefreshHeaderHeight){
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
        [_scrollView setContentInset:UIEdgeInsetsMake(0, 0, self.bounds.size.height, 0)];
        [_scrollView setContentOffset:CGPointMake(0, _scrollView.contentSize.height - _scrollView.bounds.size.height + self.bounds.size.height) animated:false];
    }];
}

-(void)endRefreshing{
    [super endRefreshing];
    [UIView animateWithDuration:XLRefreshAnimationDuration animations:^{
        [_scrollView setContentInset:UIEdgeInsetsZero];
        [_scrollView setContentOffset:CGPointMake(0, _scrollView.contentSize.height - _scrollView.bounds.size.height) animated:false];
    }];
}

@end
