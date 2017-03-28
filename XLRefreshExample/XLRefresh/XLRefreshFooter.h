//
//  XLRefreshFooter.h
//  XLRefreshExample
//
//  Created by MengXianLiang on 2017/3/27.
//  Copyright © 2017年 MengXianLiang. All rights reserved.
//

#import "XLRefreshBase.h"

@interface XLRefreshFooter : XLRefreshBase

//通过block设置回调
+(XLRefreshFooter*)footerWithRefreshingBlock:(XLRefreshingBlock)block;

//通过代理设置回调
+(XLRefreshFooter*)footerWithRefreshingTarget:(id)target refreshingAction:(SEL)action;

@end
