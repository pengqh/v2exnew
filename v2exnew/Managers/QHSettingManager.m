//
//  QHSettingManager.m
//  v2exnew
//
//  Created by pengquanhua on 2018/9/15.
//  Copyright © 2018年 pengquanhua. All rights reserved.
//

#import "QHSettingManager.h"

#define userDefaults [NSUserDefaults standardUserDefaults]

#define kLineColorBlackDarkDefault    RGB(0xdbdbdb, 1.0)
#define kLineColorBlackLightDefault   RGB(0xebebeb, 1.0)

#define kFontColorBlackDarkDefault    RGB(0x333333, 1.0)
#define kFontColorBlackDarkMiddle     RGB(0x777777, 1.0)
#define kFontColorBlackLightDefault   RGB(0x999999, 1.0)
#define kFontColorBlackBlueDefault    RGB(0x778087, 1.0)
#define kColorBlueDefault             RGB(0x3fb7fc, 1.0)

@implementation QHSettingManager

+ (instancetype)manager {
    static QHSettingManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[QHSettingManager alloc] init];
    });
    return manager;
}

- (instancetype)init {
    if (self = [super init]) {
        self.navigationBarTintColor = [UIColor blackColor];
        self.navigationBarColor = [UIColor colorWithWhite:1.00 alpha:0.980];
        self.navigationBarLineColor = [UIColor colorWithWhite:0.869 alpha:1];
        
        self.backgroundColorWhite = [UIColor whiteColor];
        self.backgroundColorWhiteDark = [UIColor colorWithWhite:0.98 alpha:1.000];
        
        self.lineColorBlackDark = kLineColorBlackDarkDefault;
        self.lineColorBlackLight = kLineColorBlackLightDefault;
        
        self.fontColorBlackDark = kFontColorBlackDarkDefault;
        self.fontColorBlackMid = kFontColorBlackDarkMiddle;
        self.fontColorBlackLight = kFontColorBlackLightDefault;
        self.fontColorBlackBlue = kFontColorBlackBlueDefault;
        
        self.colorBlue = kColorBlueDefault;
        self.cellHighlightedColor = RGB(0xdbdbdb, 0.6f);
        self.menuCellHighlightedColor = RGB(0xf6f6f6,1.0);
    }
    return self;
}

@end
