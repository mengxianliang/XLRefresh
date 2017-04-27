//
//  XLRefreshBase.h
//  XLRefreshExample
//
//  Created by MengXianLiang on 2017/3/27.
//  Copyright © 2017年 MengXianLiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/message.h>

typedef void (^XLRefreshingBlock)();

//刷新控件高度
static CGFloat XLRefreshHeight = 80.0;
//刷新动画持续时间
static CGFloat XLRefreshAnimationDuration = 0.3;

//KVO
static NSString *XLRefreshKeyPathContentOffset = @"contentOffset";
static NSString *XLRefreshKeyPathContentSize = @"contentSize";

//刷新状态提示信息对应的键
static NSString * XLStatePullingKey = @"XLStatePullingKey";
static NSString * XLStateWillRefreshKey = @"XLStateWillRefreshKey";
static NSString * XLStateRefreshingKey = @"XLStateRefreshingKey";

//运行时objc_msgSend
#define XLRefreshMsgSend(...) ((void (*)(void *, SEL, UIView *))objc_msgSend)(__VA_ARGS__)
#define XLRefreshMsgTarget(target) (__bridge void *)(target)

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
    
    /** 记录scrollView刚开始的inset */
    UIEdgeInsets _scrollViewOriginalInset;
}
//刷新状态
@property (nonatomic, assign) XLRefreshState state;
//刷新回调
@property (nonatomic, strong) XLRefreshingBlock refreshingBlock;
/** 回调对象 */
@property (weak, nonatomic) id refreshingTarget;
/** 回调方法 */
@property (assign, nonatomic) SEL refreshingAction;
//刷新进度 用于动画显示
@property (nonatomic, assign) CGFloat refreshProgress;
//是否正在刷新
@property (nonatomic, assign) BOOL isRefreshing;
//状态提示文字
@property (nonatomic, strong) NSDictionary *stateTitle;
//更新frame
-(void)updateRect NS_REQUIRES_SUPER;
//开始刷新
-(void)startRefreshing NS_REQUIRES_SUPER;
//结束刷新
-(void)endRefreshing NS_REQUIRES_SUPER;
//scrollView滚动
-(void)scrollViewContentOffsetDidChange:(NSDictionary *)change;
-(void)scrollViewContentSizeDidChange:(NSDictionary *)change;
//设置回调对象和方法
-(void)setRefreshingTarget:(id)target refreshingAction:(SEL)action;

@end
