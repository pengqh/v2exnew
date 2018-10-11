//
//  QHBarButtonItem.m
//  v2exnew
//
//  Created by pengquanhua on 2018/9/15.
//  Copyright © 2018年 pengquanhua. All rights reserved.
//

#import "QHBarButtonItem.h"

@interface QHBarButtonItem ()

@property (nonatomic, strong) UIImage *buttonImage;

@end

@implementation QHBarButtonItem

- (instancetype)initWithTitle:(NSString *)title style:(SCBarButtonItemStyle)style handler:(void (^)(id sender))action {
    
    if ([self init]) {
        
        UIButton *button = [[UIButton alloc] init];
        [button setTitle:title forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [button setTitleColor:kNavigationBarTintColor forState:UIControlStateNormal];
        [button sizeToFit];
        button.height = UIView.sc_navigationBarHeighExcludeStatusBar;
        button.width += 30;
        button.centerY = UIView.sc_statusBarHeight + UIView.sc_navigationBarHeighExcludeStatusBar / 2;
        button.x = 0;
        self.view = button;
        
        [button bk_addEventHandler:^(id sender) {
            action(sender);
            [UIView animateWithDuration:0.2 animations:^{
                button.alpha = 1.0;
            }];
            
        } forControlEvents:UIControlEventTouchUpInside];
        
        [button bk_addEventHandler:^(id sender) {
            button.alpha = 0.3;
        } forControlEvents:UIControlEventTouchDown];
        [button bk_addEventHandler:^(id sender) {
            [UIView animateWithDuration:0.3 animations:^{
                button.alpha = 1.0;
            }];
        } forControlEvents:UIControlEventTouchCancel|UIControlEventTouchUpOutside|UIControlEventTouchDragOutside];
        
    }
    
    return self;
}

- (instancetype)initWithImage:(UIImage *)image style:(SCBarButtonItemStyle)style handler:(void (^)(id sender))action {
    
    if ([self init]) {
        
        self.buttonImage = image;
        
        //image = image.imageForCurrentTheme;
        
        UIButton *button = [[UIButton alloc] init];
        [button setImage:image forState:UIControlStateNormal];
        [button setImage:image forState:UIControlStateHighlighted];
        [button sizeToFit];
        button.height = UIView.sc_navigationBarHeighExcludeStatusBar;
        button.width += 30;
        button.centerY = UIView.sc_statusBarHeight + UIView.sc_navigationBarHeighExcludeStatusBar / 2;
        button.x = 0;
        self.view = button;
        
        [button bk_addEventHandler:^(id sender) {
            action(sender);
            [UIView animateWithDuration:0.2 animations:^{
                button.alpha = 1.0;
            }];
        } forControlEvents:UIControlEventTouchUpInside];
        
        [button bk_addEventHandler:^(id sender) {
            button.alpha = 0.3;
        } forControlEvents:UIControlEventTouchDown];
        
        [button bk_addEventHandler:^(id sender) {
            [UIView animateWithDuration:0.3 animations:^{
                button.alpha = 1.0;
            }];
        } forControlEvents:UIControlEventTouchCancel|UIControlEventTouchUpOutside|UIControlEventTouchDragOutside];
        
    }
    
    return self;
}

@end
