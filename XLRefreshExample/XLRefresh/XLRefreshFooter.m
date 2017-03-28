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
    footer.stateTitle = @{XLStatePullingKey:@"1111",
                          XLStateWillRefreshKey:@"1111",
                          XLStateRefreshingKey:@"1111"};
    return footer;
}

-(void)updateRect{
    [super updateRect];
    self.frame = CGRectMake(0, _scrollView.contentSize.height,_scrollView.bounds.size.width, XLRefreshHeaderHeight);
}

-(void)scrollViewContentOffsetDidChange:(NSDictionary *)change{
    [super scrollViewContentOffsetDidChange:change];
    
    if (self.state == XLRefreshStateRefreshIng) {return;}
    //拖拽距离
    CGFloat dragHeight = _scrollView.contentOffset.y + _scrollView.bounds.size.height;
    //滚动最大距离
    CGFloat contentHeight = _scrollView.contentSize.height;
    if (dragHeight < contentHeight) {return;}
    CGFloat distance = fabs(dragHeight - contentHeight);
    //居中显示
    self.center = CGPointMake(self.center.x, contentHeight + distance/2.0f);
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
    [UIView animateWithDuration:0.35 animations:^{
        [_scrollView setContentInset:UIEdgeInsetsMake(0, 0, self.bounds.size.height, 0)];
//        [_scrollView setContentOffset:CGPointMake(0, -self.bounds.size.height) animated:false];
    }];
}

-(void)endRefreshing{
    [super endRefreshing];
    [UIView animateWithDuration:0.35 animations:^{
        [_scrollView setContentInset:UIEdgeInsetsZero];
//        [_scrollView setContentOffset:CGPointZero animated:false];
    }completion:^(BOOL finished) {
        
    }];
}

@end
