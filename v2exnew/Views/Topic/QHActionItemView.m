//
//  QHActionItemView.m
//  v2exnew
//
//  Created by pengquanhua on 2018/10/17.
//  Copyright © 2018年 pengquanhua. All rights reserved.
//

#import "QHActionItemView.h"

@interface QHActionItemView ()

@property (nonatomic, strong) UIButton *imageButton;
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation QHActionItemView

- (instancetype)initWithTitle:(NSString *)title imageName:(NSString *)imageName {
    
    if (self = [super initWithFrame:(CGRect){0, 0, kItemWidth, kItemHeight}]) {
        self.imageButton = [[UIButton alloc] init];
        [self.imageButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        self.imageButton.layer.cornerRadius = 5;
        self.imageButton.clipsToBounds = YES;
        [self addSubview:self.imageButton];
        
        if (title) {
            self.height = kItemHeightTitle;
            
            self.titleLabel = [[UILabel alloc] init];
            self.titleLabel.font = [UIFont systemFontOfSize:kTitleFontSize];
            self.titleLabel.text = title;
            self.titleLabel.textColor = kFontColorBlackLight;
            self.titleLabel.textAlignment = NSTextAlignmentCenter;
            [self addSubview:self.titleLabel];
            
            self.imageButton.frame = (CGRect){0, 15, kItemWidth, kItemWidth};
            self.titleLabel.frame = (CGRect){0, 0, kItemWidth + 20, 15};
            self.titleLabel.bottom = self.bottom - 15;
            self.titleLabel.centerX = self.centerX;
            
        } else {
            self.height = kItemHeight;
            self.imageButton.frame = (CGRect){0, 15, kItemWidth, kItemWidth};
        }
    }
    
    return self;
}

- (void)setActionBlock:(void (^)(UIButton *button, UILabel *label))actionBlock {
    _actionBlock = actionBlock;
    
    [self.imageButton bk_removeEventHandlersForControlEvents:UIControlEventTouchUpInside];
    [self.imageButton bk_addEventHandler:^(id sender) {
        if (self.actionBlock) {
            self.actionBlock(self.imageButton, self.titleLabel);
        }
    } forControlEvents:UIControlEventTouchUpInside];
    
}

@end
