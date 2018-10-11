//
//  QHMenuView.m
//  v2exnew
//
//  Created by pengquanhua on 2018/10/11.
//  Copyright © 2018年 pengquanhua. All rights reserved.
//

#import "QHMenuView.h"
#import "QHMenuSectionView.h"

@interface QHMenuView ()

@property (nonatomic, strong) UIView      *backgroundContainView;
@property (nonatomic, strong) UIImageView *backgroundImageView;

@property (nonatomic, strong) UIImageView *leftShadowImageView;
@property (nonatomic, strong) UIView      *leftShdowImageMaskView;

@property (nonatomic, strong) QHMenuSectionView *sectionView;

@end

@implementation QHMenuView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = NO;
        
        [self configureViews];
        [self configureShadowViews];
    }
    return self;
}

- (void)configureViews {
    self.backgroundContainView = [[UIView alloc] init];
    self.backgroundContainView.clipsToBounds = YES;
    [self addSubview:self.backgroundContainView];
    
    self.backgroundImageView = [[UIImageView alloc] init];
    //self.backgroundImageView.backgroundColor = [UIColor yellowColor];
    [self.backgroundContainView addSubview:self.backgroundImageView];
    
    self.sectionView = [[QHMenuSectionView alloc] init];
    [self addSubview:self.sectionView];
    
    // Handles
    @weakify(self);
    [self.sectionView setDidSelectedIndexBlock:^(NSInteger index) {
        @strongify(self);
        
        if (self.didSelectedIndexBlock) {
            self.didSelectedIndexBlock(index);
        }
        
    }];
}

- (void)configureShadowViews {
    self.leftShdowImageMaskView = [[UIView alloc] init];
    self.leftShdowImageMaskView.clipsToBounds = YES;
    [self addSubview:self.leftShdowImageMaskView];
    
    UIImage *shadowImage = [UIImage imageNamed:@"Navi_Shadow"];
    shadowImage = shadowImage.imageForCurrentTheme;
    
    self.leftShadowImageView           = [[UIImageView alloc] initWithImage:shadowImage];
    self.leftShadowImageView.transform = CGAffineTransformMakeRotation(M_PI);
    self.leftShadowImageView.alpha     = 0.0;
    [self.leftShdowImageMaskView addSubview:self.leftShadowImageView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.backgroundColor = kBackgroundColorWhiteDark;
    
    self.backgroundContainView.frame  = (CGRect){0, 0, self.width, kScreenHeight};
    self.backgroundImageView.frame    = (CGRect){kScreenWidth, 0, kScreenWidth, kScreenHeight};
    
    self.leftShdowImageMaskView.frame = (CGRect){self.width, 0, 10, kScreenHeight};
    self.leftShadowImageView.frame    = (CGRect){-5, 0, 10, kScreenHeight};
    
    self.sectionView.frame  = (CGRect){0, 0, self.width, kScreenHeight};
}

#pragma mark - Public Methods

- (void)setOffsetProgress:(CGFloat)progress {
    progress = MIN(MAX(progress, 0.0), 1.0);
    
    self.backgroundImageView.x     = self.width - kScreenWidth/2 * progress;
    
    self.leftShadowImageView.alpha = progress;
    self.leftShadowImageView.x     = -5 + progress * 5;
}

@end
