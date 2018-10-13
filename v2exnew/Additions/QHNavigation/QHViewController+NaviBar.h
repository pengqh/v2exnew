//
//  UIViewController+SCNavigation.h
//  v2exnew
//
//  Created by pengquanhua on 2018/9/15.
//  Copyright © 2018年 pengquanhua. All rights reserved.
//

@interface UIViewController (SCNavigation)

@property (nonatomic, strong) QHNavigationItem *sc_navigationItem;
@property (nonatomic, strong) UIView *sc_navigationBar;

@property(nonatomic, getter = sc_isNavigationBarHidden) BOOL sc_navigationBarHidden;

- (void)sc_setNavigationBarHidden:(BOOL)hidden animated:(BOOL)animated;

@end
