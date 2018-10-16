//
//  UIImage+Tint.m
//  v2exnew
//
//  Created by pengquanhua on 2018/10/10.
//  Copyright © 2018年 pengquanhua. All rights reserved.
//

#import "UIImage+Tint.h"

@implementation UIImage (Tint)

- (UIImage *)imageForCurrentTheme {
//    UIImage *image = self;
//    if (kCurrentTheme == V2ThemeNight) {
//        image = [image imageWithTintColor:[UIColor whiteColor]];
//    }
//    return image;
    return self;
}

- (UIImage *)imageWithTintColor:(UIColor *)tintColor {
    if (tintColor) {
        
        UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextTranslateCTM(context, 0, self.size.height);
        CGContextScaleCTM(context, 1.0, -1.0);
        CGContextSetBlendMode(context, kCGBlendModeNormal);
        CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
        CGContextClipToMask(context, rect, self.CGImage);
        [tintColor setFill];
        CGContextFillRect(context, rect);
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return newImage;
        
    }
    
    return self;
    
}

- (CGSize)fitWidth:(CGFloat)fitWidth {
    
    CGFloat height = self.size.height;
    CGFloat width = self.size.width;
    
    if (width > fitWidth) {
        height *= fitWidth/width;
        width = fitWidth;
    }
    
    return CGSizeMake(width, height);
}

@end
