//
//  QHSettingManager.h
//  v2exnew
//
//  Created by pengquanhua on 2018/9/15.
//  Copyright © 2018年 pengquanhua. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QHSettingManager : NSObject

+ (instancetype)manager;

#pragma mark - Theme

@property (nonatomic, copy) UIColor *navigationBarColor;
@property (nonatomic, copy) UIColor *navigationBarLineColor;
@property (nonatomic, copy) UIColor *navigationBarTintColor;

@property (nonatomic, copy) UIColor *backgroundColorWhite;
@property (nonatomic, copy) UIColor *backgroundColorWhiteDark;

@property (nonatomic, copy) UIColor *lineColorBlackDark;
@property (nonatomic, copy) UIColor *lineColorBlackLight;

@property (nonatomic, copy) UIColor *fontColorBlackDark;
@property (nonatomic, copy) UIColor *fontColorBlackMid;
@property (nonatomic, copy) UIColor *fontColorBlackLight;
@property (nonatomic, copy) UIColor *fontColorBlackBlue;

@property (nonatomic, copy) UIColor *colorBlue;
@property (nonatomic, copy) UIColor *cellHighlightedColor;
@property (nonatomic, copy) UIColor *menuCellHighlightedColor;

@end
