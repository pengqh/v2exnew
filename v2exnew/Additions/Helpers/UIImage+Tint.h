//
//  UIImage+Tint.h
//  v2exnew
//
//  Created by pengquanhua on 2018/10/10.
//  Copyright © 2018年 pengquanhua. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Tint)

@property (nonatomic, strong) UIImage *imageForCurrentTheme;
- (UIImage *)imageWithTintColor:(UIColor *)tintColor;

- (CGSize)fitWidth:(CGFloat)fitWidth;

@end
