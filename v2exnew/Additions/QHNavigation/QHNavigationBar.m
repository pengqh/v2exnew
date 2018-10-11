//
//  QHNavigationBar.m
//  v2exnew
//
//  Created by pengquanhua on 2018/9/15.
//  Copyright © 2018年 pengquanhua. All rights reserved.
//

#import "QHNavigationBar.h"

@interface QHNavigationBar ()

@property (nonatomic, strong) UIView *lineView;

@end

@implementation QHNavigationBar

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = (CGRect){0, 0, kScreenWidth, UIView.sc_navigationBarHeight};
        
        self.backgroundColor = kNavigationBarColor;
        
        self.lineView = [[UIView alloc] initWithFrame:(CGRect){0, UIView.sc_navigationBarHeight, kScreenWidth, 0.5}];
        self.lineView.backgroundColor = kNavigationBarLineColor;
        [self addSubview:self.lineView];
    }
    return self;
}

- (instancetype)init {
    return [self initWithFrame:CGRectZero];
}


@end
