//
//  XLRefreshBase.h
//  XLRefreshExample
//
//  Created by MengXianLiang on 2017/3/27.
//  Copyright © 2017年 MengXianLiang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^XLRefreshingBlock)();

static CGFloat XLRefreshHeaderHeight = 100.0;

static NSString *XLRefreshKeyPathContentOffset = @"contentOffset";

typedef NS_ENUM(NSInteger,XLRefreshState){
    //初始状态
    XLRefreshStatePulling = 0,
    //即将刷新
    XLRefreshStateWillRefresh,
    //正在刷新
    XLRefreshStateRefreshIng,
};

@interface XLRefreshBase : UIView{
    
    __weak UIScrollView *_scrollView;
}

@property (nonatomic, assign) XLRefreshState state;

@property (nonatomic, assign) XLRefreshingBlock refreshingBlock;

@property (nonatomic, assign) CGFloat refreshProgress;

-(void)updateRect;

-(void)startRefreshing;

-(void)endRefreshing;

-(void)scrollViewContentOffsetDidChange:(NSDictionary *)change;

@end
