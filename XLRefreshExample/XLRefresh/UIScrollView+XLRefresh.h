//
//  UIScrollView+XLRefresh.h
//  XLRefreshExample
//
//  Created by MengXianLiang on 2017/3/27.
//  Copyright © 2017年 MengXianLiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XLRefreshHeader.h"
#import "XLRefreshFooter.h"

@interface UIScrollView (XLRefresh)

@property (nonatomic, strong) XLRefreshHeader *xl_header;

@property (nonatomic, strong) XLRefreshFooter *xl_footer;

@end
