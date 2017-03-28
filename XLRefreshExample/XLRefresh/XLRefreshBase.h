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

static CGFloat XLRefreshFooterHeight = 80.0;

static CGFloat XLRefreshAnimationDuration = 0.35;

static NSString *XLRefreshKeyPathContentOffset = @"contentOffset";

static NSString * XLStatePullingKey = @"XLStatePullingKey";
static NSString * XLStateWillRefreshKey = @"XLStateWillRefreshKey";
static NSString * XLStateRefreshingKey = @"XLStateRefreshingKey";

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
//刷新状态
@property (nonatomic, assign) XLRefreshState state;
//刷新回调
@property (nonatomic, assign) XLRefreshingBlock refreshingBlock;
//刷新进度 用于动画显示
@property (nonatomic, assign) CGFloat refreshProgress;
//是否正在刷新
@property (nonatomic, assign) BOOL isRefreshing;
//状态提示文字
@property (nonatomic, strong) NSDictionary *stateTitle;
//更新frame
-(void)updateRect;
//开始刷新
-(void)startRefreshing;
//结束刷新
-(void)endRefreshing;
//scrollView滚动
-(void)scrollViewContentOffsetDidChange:(NSDictionary *)change;

@end
