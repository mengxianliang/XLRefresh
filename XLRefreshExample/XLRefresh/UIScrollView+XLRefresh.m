//
//  UIScrollView+XLRefresh.m
//  XLRefreshExample
//
//  Created by MengXianLiang on 2017/3/27.
//  Copyright © 2017年 MengXianLiang. All rights reserved.
//

#import "UIScrollView+XLRefresh.h"
#import <objc/runtime.h>

@implementation UIScrollView (XLRefresh)

#pragma mark -
#pragma mark Header
static const char XLRefreshHeaderKey = '\0';
-(void)setXl_header:(XLRefreshHeader *)xl_header{
    if (xl_header != self.xl_header) {
        // 删除旧的，添加新的
        [self.xl_header removeFromSuperview];
        [self insertSubview:xl_header atIndex:0];
        
        // 存储新的
        [self willChangeValueForKey:@"xl_header"]; // KVO
        objc_setAssociatedObject(self, &XLRefreshHeaderKey,
                                 xl_header, OBJC_ASSOCIATION_ASSIGN);
        [self didChangeValueForKey:@"xl_header"]; // KVO
    }
}

-(XLRefreshHeader *)xl_header{
    return objc_getAssociatedObject(self, &XLRefreshHeaderKey);
}


#pragma mark -
#pragma mark Footer
static const char XLRefreshFooterKey = '\0';
-(void)setXl_footer:(XLRefreshFooter *)xl_footer{
    if (xl_footer != self.xl_footer) {
        // 删除旧的，添加新的
        [self.xl_footer removeFromSuperview];
        [self insertSubview:xl_footer atIndex:0];
        
        // 存储新的
        [self willChangeValueForKey:@"xl_footer"]; // KVO
        objc_setAssociatedObject(self, &XLRefreshFooterKey,
                                 xl_footer, OBJC_ASSOCIATION_ASSIGN);
        [self didChangeValueForKey:@"xl_footer"]; // KVO
    }
}


-(XLRefreshFooter *)xl_footer{
    return objc_getAssociatedObject(self, &XLRefreshFooterKey);
}

@end
