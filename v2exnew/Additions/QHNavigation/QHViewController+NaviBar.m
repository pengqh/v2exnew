//
//  UIViewController+SCNavigation.m
//  v2exnew
//
//  Created by pengquanhua on 2018/9/15.
//  Copyright © 2018年 pengquanhua. All rights reserved.
//

#import "QHViewController+NaviBar.h"
#import <objc/runtime.h>

static char const * const kNaviBar = "kSPNaviBar";
static char const * const kNaviBarView = "kNaviBarView";

@implementation UIViewController (SCNavigation)

@dynamic sc_navigationItem;
@dynamic sc_navigationBar;

- (QHNavigationItem *)sc_navigationItem {
    return objc_getAssociatedObject(self, kNaviBar);
}

- (void)setSc_navigationItem:(QHNavigationItem *)sc_navigationItem {
    objc_setAssociatedObject(self, kNaviBar, sc_navigationItem, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)sc_navigationBar {
    return objc_getAssociatedObject(self, kNaviBarView);
}

- (void)setSc_navigationBar:(UIView *)sc_navigationBar {
    objc_setAssociatedObject(self, kNaviBarView, sc_navigationBar, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
