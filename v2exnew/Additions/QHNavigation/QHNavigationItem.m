//
//  QHNavigationItem.m
//  v2exnew
//
//  Created by pengquanhua on 2018/9/15.
//  Copyright © 2018年 pengquanhua. All rights reserved.
//

#import "QHNavigationItem.h"

@interface QHNavigationItem ()

@property (nonatomic, strong, readwrite) UILabel *titleLabel;
@property (nonatomic, assign) UIViewController *_sc_viewController;

@end

@implementation QHNavigationItem

- (instancetype)init {
    if (self = [super init]) {
        
    }
    return self;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    
    if (!title) {
        _titleLabel.text = @"";
        return;
    }
    
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        [_titleLabel setFont:[UIFont systemFontOfSize:17]];
        [_titleLabel setTextColor:kNavigationBarTintColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [__sc_viewController.sc_navigationBar addSubview:_titleLabel];
    }
    
    _titleLabel.text = title;
    [_titleLabel sizeToFit];
    NSUInteger otherButtonWidth = self.leftBarButtonItem.view.width + self.rightBarButtonItem.view.width;
    _titleLabel.width = kScreenWidth - otherButtonWidth - 20;
    _titleLabel.centerY = UIView.sc_statusBarHeight + UIView.sc_navigationBarHeighExcludeStatusBar / 2;
    _titleLabel.centerX = kScreenWidth/2;
}

- (void)setLeftBarButtonItem:(QHBarButtonItem *)leftBarButtonItem {
    
    if (__sc_viewController) {
        [_leftBarButtonItem.view removeFromSuperview];
        leftBarButtonItem.view.x = 0;
        leftBarButtonItem.view.centerY = UIView.sc_statusBarHeight + UIView.sc_navigationBarHeighExcludeStatusBar / 2;
        [__sc_viewController.sc_navigationBar addSubview:leftBarButtonItem.view];
    }
    
    _leftBarButtonItem = leftBarButtonItem;
}

- (void)setRightBarButtonItem:(QHBarButtonItem *)rightBarButtonItem {
    
    if (__sc_viewController) {
        [_rightBarButtonItem.view removeFromSuperview];
        rightBarButtonItem.view.x = kScreenWidth - rightBarButtonItem.view.width;
        rightBarButtonItem.view.centerY = UIView.sc_statusBarHeight + UIView.sc_navigationBarHeighExcludeStatusBar / 2;
        [__sc_viewController.sc_navigationBar addSubview:rightBarButtonItem.view];
    }
    
    _rightBarButtonItem = rightBarButtonItem;
    
}

@end
