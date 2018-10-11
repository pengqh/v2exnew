//
//  QHNavigationPushAnimation.m
//  v2exnew
//
//  Created by pengquanhua on 2018/9/16.
//  Copyright © 2018年 pengquanhua. All rights reserved.
//

#import "QHNavigationPushAnimation.h"

@implementation QHNavigationPushAnimation

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromVC = (UIViewController*)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = (UIViewController*)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *fromView = (UIView*)[transitionContext viewForKey:UITransitionContextFromViewKey];
    UIView *toView = (UIView*)[transitionContext viewForKey:UITransitionContextToViewKey];
    
    UIView *containerView = [transitionContext containerView];
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    
    [containerView addSubview:fromView];
    [containerView addSubview:toView];
    fromView.frame = CGRectMake(0, 0, kScreenWidth, CGRectGetHeight(fromView.frame));
    toView.frame = CGRectMake(kScreenWidth, 0, kScreenWidth, CGRectGetHeight(toView.frame));
    
    // Configure Navi Transition
    
    UIView *naviBarView;
    
    UIView *toNaviLeft;
    UIView *toNaviRight;
    UIView *toNaviTitle;
    
    UIView *fromNaviLeft;
    UIView *fromNaviRight;
    UIView *fromNaviTitle;
    
    if (FALSE) {
        
    } else {
        naviBarView = [[UIView alloc] initWithFrame:(CGRect){0, 0, kScreenWidth, UIView.sc_navigationBarHeight}];
        naviBarView.backgroundColor = kNavigationBarColor;
        [containerView addSubview:naviBarView];
        
        UIView *lineView = [[UIView alloc] initWithFrame:(CGRect){0, UIView.sc_navigationBarHeight, kScreenWidth, 0.5}];
        lineView.backgroundColor = kNavigationBarLineColor;
        [naviBarView addSubview:lineView];
        
        toNaviLeft = toVC.sc_navigationItem.leftBarButtonItem.view;
        toNaviRight = toVC.sc_navigationItem.rightBarButtonItem.view;
        toNaviTitle = toVC.sc_navigationItem.titleLabel;
        
        fromNaviLeft = fromVC.sc_navigationItem.leftBarButtonItem.view;
        fromNaviRight = fromVC.sc_navigationItem.rightBarButtonItem.view;
        fromNaviTitle = fromVC.sc_navigationItem.titleLabel;
        
        [containerView addSubview:toNaviLeft];
        [containerView addSubview:toNaviTitle];
        [containerView addSubview:toNaviRight];
        
        [containerView addSubview:fromNaviLeft];
        [containerView addSubview:fromNaviTitle];
        [containerView addSubview:fromNaviRight];
        
        fromNaviLeft.alpha = 1.0;
        fromNaviRight.alpha =  1.0;
        fromNaviTitle.alpha = 1.0;
        
        toNaviLeft.alpha = 0.0;
        toNaviRight.alpha = 0.0;
        toNaviTitle.alpha = 0.0;
        toNaviTitle.centerX = 44;
        
        toNaviLeft.x = 0;
        toNaviTitle.centerX = kScreenWidth;
        toNaviRight.x = kScreenWidth + 50 - toNaviRight.width;
    }
    
    // End configure
    
    [UIView animateWithDuration:duration animations:^{
        toView.x = 0;
        fromView.x = -120;
        
        fromNaviLeft.alpha = 0;
        fromNaviRight.alpha =  0;
        fromNaviTitle.alpha = 0;
        fromNaviTitle.centerX = 0;
        
        toNaviLeft.alpha = 1.0;
        toNaviRight.alpha = 1.0;
        toNaviTitle.alpha = 1.0;
        toNaviTitle.centerX = kScreenWidth/2;
        toNaviLeft.x = 0;
        toNaviRight.x = kScreenWidth - toNaviRight.width;
        
        
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
        
        fromNaviLeft.alpha = 1.0;
        fromNaviRight.alpha = 1.0;
        fromNaviTitle.alpha = 1.0;
        fromNaviTitle.centerX = kScreenWidth / 2;
        fromNaviLeft.x = 0;
        fromNaviRight.x = kScreenWidth - fromNaviRight.width;
        
        [naviBarView removeFromSuperview];
        
        [toNaviLeft removeFromSuperview];
        [toNaviTitle removeFromSuperview];
        [toNaviRight removeFromSuperview];
        
        [fromNaviLeft removeFromSuperview];
        [fromNaviTitle removeFromSuperview];
        [fromNaviRight removeFromSuperview];
        
        [toVC.sc_navigationBar addSubview:toNaviLeft];
        [toVC.sc_navigationBar addSubview:toNaviTitle];
        [toVC.sc_navigationBar addSubview:toNaviRight];
        
        [fromVC.sc_navigationBar addSubview:fromNaviLeft];
        [fromVC.sc_navigationBar addSubview:fromNaviTitle];
        [fromVC.sc_navigationBar addSubview:fromNaviRight];
        
    }];
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.3;
}


@end
