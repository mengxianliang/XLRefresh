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
}
@end

@implementation XLRefreshAnimation

-(instancetype)init{
    if (self = [super init]) {
        _layer = [XLRefreshAnimationLayer layer];
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
    _progress = progress;
    //旋转
    if (_progress > 1) {
        CGFloat angle = M_PI * (_progress - 1.0f);
        NSLog(@"angle = %f",angle);
        _layer.affineTransform = CGAffineTransformMakeRotation(angle);
    }else{//画圆
        _layer.affineTransform = CGAffineTransformIdentity;
        _layer.progress = progress;
    }
    
}

@end
