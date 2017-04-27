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
    footer.stateTitle = @{XLStatePullingKey:@"上拉即可加载",
                          XLStateWillRefreshKey:@"释放加载...",
                          XLStateRefreshingKey:@"正在加载..."};
    return footer;
}

-(void)updateRect{
    [super updateRect];
    self.frame = CGRectMake(0,_scrollView.bounds.size.height,_scrollView.bounds.size.width, XLRefreshHeight);
}

-(void)scrollViewContentOffsetDidChange:(NSDictionary *)change{
    [super scrollViewContentOffsetDidChange:change];
    CGFloat distance = 0;
    //比较短 小于屏幕高度
    if (_scrollView.contentSize.height < _scrollView.bounds.size.height) {
        CGFloat actionY = _scrollView.contentOffset.y + _scrollViewOriginalInset.top;
        BOOL action = actionY != XLRefreshHeight && _scrollViewOriginalInset.top > 0 && actionY > 0;
        if (_scrollViewOriginalInset.top == 0) {
            action = actionY > 0;
        }
        if (action) {
            distance = actionY;
            self.center = CGPointMake(self.center.x, _scrollView.bounds.size.height + distance/2.0f - _scrollViewOriginalInset.top);
        }
    }else{//比较大 大于屏幕高度
        //拖拽距离
        CGFloat targetOffsetY = _scrollView.contentSize.height - _scrollView.bounds.size.height;
        if (_scrollView.contentOffset.y < targetOffsetY) {return;}
        distance = fabs(targetOffsetY - _scrollView.contentOffset.y);
        //居中显示
        self.center = CGPointMake(self.center.x, _scrollView.contentSize.height + distance/2.0f);
    }
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

-(void)scrollViewContentSizeDidChange:(NSDictionary *)change{
    if (![[change objectForKey:@"new"] isEqual:[change objectForKey:@"old"]]) {
        CGFloat Y = _scrollView.bounds.size.height > _scrollView.contentSize.height ? _scrollView.bounds.size.height : _scrollView.contentSize.height;
        self.frame = CGRectMake(0,Y,_scrollView.bounds.size.width, XLRefreshHeight);
    }
}

-(void)startRefreshing{
    [super startRefreshing];
    [UIView animateWithDuration:XLRefreshAnimationDuration animations:^{
        [_scrollView setContentInset:UIEdgeInsetsMake(0, 0, self.bounds.size.height, 0)];
        if (_scrollView.contentSize.height < _scrollView.bounds.size.height) {
            [_scrollView setContentOffset:CGPointMake(0,self.bounds.size.height - _scrollViewOriginalInset.top) animated:false];
        }else{
            [_scrollView setContentOffset:CGPointMake(0, _scrollView.contentSize.height - _scrollView.bounds.size.height + self.bounds.size.height) animated:false];
        }
    }];
}

-(void)endRefreshing{
    [super endRefreshing];
    [UIView animateWithDuration:XLRefreshAnimationDuration animations:^{
        [_scrollView setContentInset:_scrollViewOriginalInset];
        if (_scrollView.contentSize.height < _scrollView.bounds.size.height) {
            //            [_scrollView setContentOffset:CGPointMake(0, 0) animated:false];
            self.frame = CGRectMake(0, _scrollView.bounds.size.height + XLRefreshHeight, self.bounds.size.width, self.bounds.size.height);
        }else{
            //            [_scrollView setContentOffset:CGPointMake(0, _scrollView.contentSize.height - _scrollView.bounds.size.height) animated:false];
            self.frame = CGRectMake(0, _scrollView.contentSize.height + XLRefreshHeight, self.bounds.size.width, self.bounds.size.height);
        }
    }];
}

@end
