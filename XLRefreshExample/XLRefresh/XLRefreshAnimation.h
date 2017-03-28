//
//  XLRefreshAnimation.h
//  XLRefreshExample
//
//  Created by MengXianLiang on 2017/3/27.
//  Copyright © 2017年 MengXianLiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XLRefreshAnimation : UIView

@property (nonatomic, assign) CGFloat progress;

-(void)startAnimation;

-(void)endAnimation;

@end
