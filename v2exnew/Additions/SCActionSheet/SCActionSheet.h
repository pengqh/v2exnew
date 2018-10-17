//
//  SCActionSheet.h
//  v2exnew
//
//  Created by pengquanhua on 2018/10/17.
//  Copyright © 2018年 pengquanhua. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SCActionSheetButton;

@interface SCActionSheet : UIView

@property (nonatomic, copy) UIColor *titleTextColor;
@property (nonatomic, copy) UIColor *deviderLineColor;
@property (nonatomic, copy) void (^endAnimationBlock)(void);

@property (nonatomic, strong) UIView *showInView;

+ (BOOL)isActionSheetShowing;

- (instancetype)sc_initWithTitles:(NSArray *)titles customViews:(NSArray *)customViews buttonTitles:(NSString *)buttonTitles, ...;

- (void)sc_setButtonHandler:(void (^)(void))block forIndex:(NSInteger)index;

- (void)sc_configureButtonWithBlock:(void (^)(SCActionSheetButton *button))block forIndex:(NSInteger)index;

- (void)sc_show:(BOOL)animated;

- (void)sc_hide:(BOOL)animated;

@end
