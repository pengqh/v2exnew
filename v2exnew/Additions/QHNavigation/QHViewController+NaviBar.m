//
//  UIViewController+SCNavigation.m
//  v2exnew
//
//  Created by pengquanhua on 2018/9/15.
//  Copyright © 2018年 pengquanhua. All rights reserved.
//

#import "QHViewController+NaviBar.h"
#import <objc/runtime.h>

static char const * const kNaviHidden = "kSPNaviHidden";
static char const * const kNaviBar = "kSPNaviBar";
static char const * const kNaviBarView = "kNaviBarView";

@implementation UIViewController (SCNavigation)

@dynamic sc_navigationItem;
@dynamic sc_navigationBar;
@dynamic sc_navigationBarHidden;

- (QHNavigationItem *)sc_navigationItem {
    return objc_getAssociatedObject(self, kNaviBar);
}

- (BOOL)sc_isNavigationBarHidden {
    return [objc_getAssociatedObject(self, kNaviHidden) boolValue];
}

- (void)setSc_navigationBarHidden:(BOOL)sc_navigationBarHidden {
    objc_setAssociatedObject(self, kNaviHidden, @(sc_navigationBarHidden), OBJC_ASSOCIATION_ASSIGN);
}

- (void)sc_setNavigationBarHidden:(BOOL)hidden animated:(BOOL)animated {
    if (hidden) {
        [UIView animateWithDuration:0.3 animations:^{
            self.sc_navigationBar.y = -UIView.sc_navigationBarHeighExcludeStatusBar;
            for (UIView *view in self.sc_navigationBar.subviews) {
                view.alpha = 0.0;
            }
        } completion:^(BOOL finished) {
            self.sc_navigationBarHidden = YES;
        }];
    } else {
        [UIView animateWithDuration:0.3 animations:^{
            self.sc_navigationBar.y = 0;
            for (UIView *view in self.sc_navigationBar.subviews) {
                view.alpha = 1.0;
            }
        } completion:^(BOOL finished) {
            self.sc_navigationBarHidden = NO;
        }];
    }
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
