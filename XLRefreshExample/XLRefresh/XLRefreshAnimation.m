//
//  XLRefreshAnimation.m
//  XLRefreshExample
//
//  Created by MengXianLiang on 2017/3/27.
//  Copyright © 2017年 MengXianLiang. All rights reserved.
//

#import "XLRefreshAnimation.h"
#import "XLRefreshAnimationLayer.h"

@interface XLRefreshAnimation ()
{
    XLRefreshAnimationLayer *_layer;
    BOOL _animating;
}
@end

@implementation XLRefreshAnimation

-(instancetype)init{
    if (self = [super init]) {
        _layer = [XLRefreshAnimationLayer layer];
        _layer.contentsScale = [UIScreen mainScreen].scale;
        [self.layer addSublayer:_layer];
        _layer.progress = 0;
    }
    return self;
}

-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    _layer.frame = self.bounds;
}

-(void)setProgress:(CGFloat)progress{
    if (_animating == true) {return;}
    //画圆
    progress = progress > 1 ? 1 : progress;
    _layer.progress = progress;
    
//    //旋转
//    if (_progress > 1) {
//        CGFloat angle = M_PI * (_progress - 1.0f);
//        _layer.affineTransform = CGAffineTransformMakeRotation(angle);
//    }else{
//        _layer.affineTransform = CGAffineTransformIdentity;
//    }
}

//旋转动画
-(void)startAnimation{
    _animating = true;
//    self.progress = 1.0f;
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = @(M_PI * 2.0);
    rotationAnimation.duration = 0.7f;
    rotationAnimation.autoreverses = NO;
    rotationAnimation.repeatCount = HUGE_VALF;
    rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [_layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

-(void)endAnimation{
    [_layer removeAllAnimations];
    _animating = false;
}

@end
