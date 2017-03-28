//
//  XLRefreshBase.m
//  XLRefreshExample
//
//  Created by MengXianLiang on 2017/3/27.
//  Copyright © 2017年 MengXianLiang. All rights reserved.
//

#import "XLRefreshBase.h"
#import "XLRefreshAnimation.h"

@implementation XLRefreshBase
{
    UILabel *_textLabel;
    XLRefreshAnimation *_animationView;
}
-(instancetype)init{
    if (self = [super init]) {
        [self initUI];
    }
    return self;
}

-(void)initUI{
    NSLog(@"创建UI");
    
    _animationView = [[XLRefreshAnimation alloc] init];
    [self addSubview:_animationView];
    
    _textLabel = [[UILabel alloc] init];
    _textLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_textLabel];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    NSLog(@"更新Subviews");
    
    CGFloat labelWidth = self.bounds.size.width/3;
    CGFloat height = self.bounds.size.height;
    _textLabel.frame = CGRectMake(0, 0, labelWidth, height);
    _textLabel.center = CGPointMake(self.bounds.size.width/2.0f, _textLabel.center.y);
    
    CGFloat animationWidth = height*0.6;
    _animationView.frame = CGRectMake(CGRectGetMinX(_textLabel.frame) - animationWidth, 0, animationWidth, height);
}

-(void)willMoveToSuperview:(UIView *)newSuperview{
    [super willMoveToSuperview:newSuperview];
    if (![newSuperview isKindOfClass:[UIScrollView class]]) {return;}
    [self removeObserves];
    _scrollView = (UIScrollView*)newSuperview;
    //允许垂直
    _scrollView.alwaysBounceVertical = YES;
    NSLog(@"是ScrollView");
    [self updateRect];
    [self addObserves];
}

-(void)updateRect{
    NSLog(@"更新Frame");
}


#pragma mark -
#pragma mark KVO

-(void)addObserves{
    NSKeyValueObservingOptions options = NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld;
    [_scrollView addObserver:self forKeyPath:XLRefreshKeyPathContentOffset options:options context:nil];
}

-(void)removeObserves{
    [_scrollView removeObserver:self forKeyPath:XLRefreshKeyPathContentOffset];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
    // 这个就算看不见也需要处理
    if ([keyPath isEqualToString:XLRefreshKeyPathContentOffset]) {
        [self scrollViewContentOffsetDidChange:change];
    }
}

- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change{}

#pragma mark -
#pragma mark Setter

-(void)setState:(XLRefreshState)state{
    _state = state;
    
    switch (state) {
        case XLRefreshStatePulling:
            _textLabel.text = @"下拉即可刷新";
            break;
        case XLRefreshStateWillRefresh:
            _textLabel.text = @"释放刷新...";
            break;
        case XLRefreshStateRefreshIng:
            _textLabel.text = @"正在刷新...";
            break;
            
        default:
            break;
    }
}

-(void)startRefreshing{
    self.state = XLRefreshStateRefreshIng;
    [_animationView startAnimation];
    if (_refreshingBlock) {
        _refreshingBlock();
    }
}

-(void)endRefreshing{
    dispatch_after(0.35, dispatch_get_main_queue(), ^(void){
        [_animationView endAnimation];
        self.state = XLRefreshStatePulling;
    });
}

#pragma mark -
#pragma mark Setter/Getter

-(void)setRefreshProgress:(CGFloat)refreshProgress{
    _refreshProgress = refreshProgress;
    
    _animationView.progress = refreshProgress;
    _textLabel.alpha = refreshProgress;
}

-(BOOL)isRefreshing{
    return _state == XLRefreshStateRefreshIng || _state == XLRefreshStatePulling;
}

@end
