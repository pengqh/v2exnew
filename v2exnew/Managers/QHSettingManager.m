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

static NSString *const kSelectedSectionIndex = @"SelectedSectionIndex";

static NSString *const kTheme = @"Theme";
static NSString *const kThemeAutoChange = @"ThemeAutoChange";

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
        self.selectedSectionIndex = [[userDefaults objectForKey:kSelectedSectionIndex] unsignedIntegerValue];
        
        _theme = [[userDefaults objectForKey:kTheme] integerValue];
        
        id themeAutoChange = [userDefaults objectForKey:kThemeAutoChange];
        if (themeAutoChange) {
            _themeAutoChange = [themeAutoChange boolValue];
        } else {
            _themeAutoChange = YES;
        }
        
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

#pragma mark - Index

- (void)setSelectedSectionIndex:(NSUInteger)selectedSectionIndex {
    _selectedSectionIndex = selectedSectionIndex;
    
    [userDefaults setObject:@(selectedSectionIndex) forKey:kSelectedSectionIndex];
    [userDefaults synchronize];
    
}



#pragma mark - Theme
- (void)setTheme:(V2Theme)theme {
    _theme = theme;
    
    [userDefaults setObject:@(theme) forKey:kTheme];
    [userDefaults synchronize];
    
    [self configureTheme:theme];
}

- (void)configureTheme:(V2Theme)theme {
    
    if (theme == V2ThemeDefault) {
        
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
        
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
        
    }
    
    if (theme == V2ThemeNight) {
        
        self.navigationBarTintColor = RGB(0xcccccc, 1.0);
        self.navigationBarColor = [UIColor colorWithWhite:0.000 alpha:0.980];
        self.navigationBarLineColor = [UIColor colorWithWhite:0.281 alpha:1.000];
        
        self.backgroundColorWhite = [UIColor blackColor];
        self.backgroundColorWhiteDark = [UIColor colorWithWhite:0.08 alpha:1.000];
        
        self.lineColorBlackDark = [UIColor colorWithWhite:0.281 alpha:1.000];
        self.lineColorBlackLight = [UIColor colorWithWhite:0.119 alpha:1.000];
        
        self.fontColorBlackDark = RGB(0x989898, 1.0);
        self.fontColorBlackMid =  RGB(0x777777, 1.0);;
        self.fontColorBlackLight = [UIColor colorWithWhite:0.272 alpha:1.000];
        self.fontColorBlackBlue = RGB(0x778087, 1.0);
        
        self.colorBlue = [UIColor colorWithWhite:1.000 alpha:0.10];
        self.cellHighlightedColor = RGB(0x333333, 1.0f);
        self.menuCellHighlightedColor = [UIColor colorWithWhite:0.119 alpha:1.000];
        
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
        
    }
    
}

@end
