//
//  XLRefreshAnimationLayer.m
//  XLRefreshExample
//
//  Created by MengXianLiang on 2017/3/27.
//  Copyright © 2017年 MengXianLiang. All rights reserved.
//

#import "XLRefreshAnimationLayer.h"
#import <UIKit/UIKit.h>

@implementation XLRefreshAnimationLayer

-(void)drawInContext:(CGContextRef)ctx{
    [super drawInContext:ctx];
    
    UIGraphicsPushContext(ctx);
    CGContextRef contex = UIGraphicsGetCurrentContext();
    
    //总高度
    CGFloat H = self.bounds.size.height;
    //总宽度
    CGFloat W = self.bounds.size.width;
    //线的长度
    CGFloat h = 20;
    //线段最长移动距离
    CGFloat maxDistance = H/2 - h;
    //线段当前移动距离
    CGFloat moveDisatnce = maxDistance * _progress*2;
    //弧的半径
    CGFloat r = 10;
    //箭头长度
    CGFloat arrowLength = 2.0f;
    //箭头角度
    CGFloat arrowAngle = M_PI/6.f;
    
    
    //--------第一条：从下向上的线
    UIBezierPath *curvePath1 = [UIBezierPath bezierPath];
    curvePath1.lineCapStyle = kCGLineCapRound;
    curvePath1.lineJoinStyle = kCGLineJoinRound;
    curvePath1.lineWidth = 2.0f;
    //线的x位置
    CGFloat path1_X = W/2 - r;
    CGPoint pointA = CGPointMake(path1_X, H - moveDisatnce);
    CGPoint pointB = CGPointMake(path1_X, H - moveDisatnce - h);
    //当小于0.5座直线向上的动画
    if (_progress <= 0.5) {
        [curvePath1 moveToPoint:pointA];
        [curvePath1 addLineToPoint:pointB];
        //添加箭头
        CGPoint point = curvePath1.currentPoint;
        CGPoint arrowPoint = CGPointMake(point.x - arrowLength*cos(arrowAngle), point.y + arrowLength*sin(arrowAngle));
        UIBezierPath *arrowPath = [UIBezierPath bezierPath];
        [arrowPath moveToPoint:point];
        [arrowPath addLineToPoint:arrowPoint];
        [curvePath1 appendPath:arrowPath];
    }else{
        //当大于0.5时 添加顺时针曲线动画，且下半部逐渐缩短（保持B点不动A点逐渐上移）
        pointB = CGPointMake(path1_X, H/2.0f);
        [curvePath1 moveToPoint:pointA];
        [curvePath1 addLineToPoint:pointB];
        
        //由progress获取旋转的角度
        CGFloat moveAngle = M_PI*(_progress - 0.5)*2*0.8;
        //设置弧线
        [curvePath1 addArcWithCenter:CGPointMake(W/2, H/2) radius:r startAngle:M_PI endAngle:M_PI + moveAngle  clockwise:true];
        //添加箭头
        CGPoint point = curvePath1.currentPoint;
        CGPoint arrowPoint = CGPointMake(point.x - arrowLength*cos(arrowAngle - moveAngle), point.y + arrowLength*sin(arrowAngle - moveAngle));
        UIBezierPath *arrowPath = [UIBezierPath bezierPath];
        [arrowPath moveToPoint:point];
        [arrowPath addLineToPoint:arrowPoint];
        [curvePath1 appendPath:arrowPath];
    }
    
    //--------第二条：从上向下的线
    UIBezierPath *curvePath2 = [UIBezierPath bezierPath];
    curvePath2.lineCapStyle = kCGLineCapRound;
    curvePath2.lineJoinStyle = kCGLineJoinRound;
    curvePath2.lineWidth = 2.0f;
    
    CGFloat path2_X = W/2 + r;
    CGPoint pointC = CGPointMake(path2_X,moveDisatnce);
    CGPoint pointD = CGPointMake(path2_X,moveDisatnce + h);
    
    if (_progress <= 0.5) {
        [curvePath2 moveToPoint:pointC];
        [curvePath2 addLineToPoint:pointD];
        
        CGPoint point = curvePath2.currentPoint;
        CGPoint arrowPoint = CGPointMake(point.x + arrowLength*cos(arrowAngle), point.y - arrowLength*sin(arrowAngle));
        UIBezierPath *arrowPath = [UIBezierPath bezierPath];
        [arrowPath moveToPoint:point];
        [arrowPath addLineToPoint:arrowPoint];
        [curvePath2 appendPath:arrowPath];
    }else{
        pointD = CGPointMake(path2_X, H/2.0f);
        [curvePath2 moveToPoint:pointC];
        [curvePath2 addLineToPoint:pointD];
        
        CGFloat moveAngle = M_PI*(_progress - 0.5)*2*0.8;
        
        [curvePath2 addArcWithCenter:CGPointMake(W/2, H/2) radius:r startAngle:0 endAngle:moveAngle  clockwise:true];
        
        CGPoint point = curvePath2.currentPoint;
        CGPoint arrowPoint = CGPointMake(point.x + arrowLength*cos(arrowAngle - moveAngle), point.y - arrowLength*sin(arrowAngle - moveAngle));
        UIBezierPath *arrowPath = [UIBezierPath bezierPath];
        [arrowPath moveToPoint:point];
        [arrowPath addLineToPoint:arrowPoint];
        [curvePath2 appendPath:arrowPath];
    }
    
    CGContextSaveGState(contex);
    CGContextRestoreGState(contex);
    
    [[UIColor blackColor] setStroke];
    
    [curvePath1 stroke];
    [curvePath2 stroke];
    
    UIGraphicsPopContext();
}

-(void)setProgress:(CGFloat)progress{
    _progress = progress;
    [self setNeedsDisplay];
}

@end
