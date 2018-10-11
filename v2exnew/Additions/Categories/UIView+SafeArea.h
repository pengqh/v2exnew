//
//  UIView+SafeArea.h
//  v2exnew
//
//  Created by pengquanhua on 2018/9/15.
//  Copyright © 2018年 pengquanhua. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (SafeArea)

@property (class, nonatomic, readonly) CGFloat sc_statusBarHeight; // 37 for iPhone X, 20 for Others
@property (class, nonatomic, readonly) CGFloat sc_navigationBarHeighExcludeStatusBar; // 44
@property (class, nonatomic, readonly) CGFloat sc_navigationBarHeight; // status + naviExStatus
@property (class, nonatomic, readonly) CGFloat sc_bottomInset;

@end
