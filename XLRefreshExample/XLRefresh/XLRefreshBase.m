//
//  XLRefreshBase.m
//  XLRefreshExample
//
//  Created by MengXianLiang on 2017/3/27.
//  Copyright © 2017年 MengXianLiang. All rights reserved.
//

#import "XLRefreshBase.h"
#import "XLRefreshAnimation.h"

@implementation XLRefreshBase {
    UILabel *_textLabel;
    XLRefreshAnimation *_animationView;
}

-(instancetype)init{
    if (self = [super init]) {
        [self initUI];
    }
    return self;
}

//1.创建UI
-(void)initUI{
    _animationView = [[XLRefreshAnimation alloc] init];
    [self addSubview:_animationView];
    
    _textLabel = [[UILabel alloc] init];
    _textLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_textLabel];
    
    self.layer.masksToBounds = true;
}

//2.添加功能
-(void)willMoveToSuperview:(UIView *)newSuperview{
    
    [super willMoveToSuperview:newSuperview];
    
    if (![newSuperview isKindOfClass:[UIScrollView class]] && newSuperview) {return;}
    [self removeObservers];
    if (newSuperview) {
        _scrollView = (UIScrollView*)newSuperview;
        //允许垂直
        _scrollView.alwaysBounceVertical = YES;
        // 记录UIScrollView最开始的contentInset
        _scrollViewOriginalInset = _scrollView.contentInset;
        
        [self updateRect];
        [self addObservers];
    }
}

//3.放置SubView
-(void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat labelWidth = self.bounds.size.width/3;
    CGFloat height = XLRefreshHeight;
    CGFloat animationWidth = height*0.6;
    
    
    _textLabel.bounds = CGRectMake(0, 0, labelWidth, height);
    _textLabel.center = CGPointMake(self.bounds.size.width/2+animationWidth/2, self.bounds.size.height/2.0f);
    
    _animationView.frame = CGRectMake(CGRectGetMinX(_textLabel.frame) - animationWidth, 0, animationWidth, height);
    _animationView.center = CGPointMake(_animationView.center.x, self.bounds.size.height/2.0f);
}

-(void)updateRect{}

//设置回调对象和方法
-(void)setRefreshingTarget:(id)target refreshingAction:(SEL)action{
    self.refreshingTarget = target;
    self.refreshingAction = action;
}

#pragma mark -
#pragma mark KVO

-(void)addObservers{
    NSKeyValueObservingOptions options = NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld;
    [_scrollView addObserver:self forKeyPath:XLRefreshKeyPathContentOffset options:options context:nil];
    [_scrollView addObserver:self forKeyPath:XLRefreshKeyPathContentSize options:options context:nil];
}

-(void)removeObservers{
    [self.superview removeObserver:self forKeyPath:XLRefreshKeyPathContentOffset];
    [self.superview removeObserver:self forKeyPath:XLRefreshKeyPathContentSize];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
    if ([keyPath isEqualToString:XLRefreshKeyPathContentOffset]) {
        [self scrollViewContentOffsetDidChange:change];
    }else if([keyPath isEqualToString:XLRefreshKeyPathContentSize]){
        [self scrollViewContentSizeDidChange:change];
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

-(void)scrollViewContentOffsetDidChange:(NSDictionary *)change{}
-(void)scrollViewContentSizeDidChange:(NSDictionary *)change{}

#pragma mark -
#pragma mark Setter

-(void)setState:(XLRefreshState)state{
    _state = state;
    switch (state) {
        case XLRefreshStatePulling:
            _textLabel.text = _stateTitle[XLStatePullingKey];
            break;
        case XLRefreshStateWillRefresh:
            _textLabel.text = _stateTitle[XLStateWillRefreshKey];
            break;
        case XLRefreshStateRefreshIng:
            _textLabel.text = _stateTitle[XLStateRefreshingKey];
            break;
            
        default:
            break;
    }
}

-(void)startRefreshing{
    self.state = XLRefreshStateRefreshIng;
    self.refreshProgress = 1;
    [self sendRefresingCallBack];
    [_animationView startAnimation];
}

-(void)endRefreshing{
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, XLRefreshAnimationDuration * NSEC_PER_SEC);
    dispatch_after(time, dispatch_get_main_queue(), ^(void){
        [_animationView endAnimation];
        self.state = XLRefreshStatePulling;
        self.refreshProgress = 0;
    });
}

//发送回调
-(void)sendRefresingCallBack{
    
    if ([self.refreshingTarget respondsToSelector:self.refreshingAction]) {
        XLRefreshMsgSend(XLRefreshMsgTarget(self.refreshingTarget), self.refreshingAction, self);
    }
    if (_refreshingBlock) {
        _refreshingBlock();
    }
}

#pragma mark -
#pragma mark Setter/Getter

-(void)setRefreshProgress:(CGFloat)refreshProgress{
    _refreshProgress = refreshProgress;
    
    _animationView.progress = refreshProgress;
    self.alpha = refreshProgress;
    
    refreshProgress = refreshProgress > 1 ? 1 : refreshProgress;
    self.bounds = CGRectMake(0, 0, self.bounds.size.width, refreshProgress * XLRefreshHeight);
}

-(BOOL)isRefreshing{
    return _state == XLRefreshStateRefreshIng;
}

@end
