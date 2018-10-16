//
//  AppDelegate.h
//  v2exnew
//
//  Created by pengquanhua on 2018/9/12.
//  Copyright © 2018年 pengquanhua. All rights reserved.
//

#import <UIKit/UIKit.h>
@class V2RootViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) V2RootViewController *rootViewController;
@property (nonatomic, assign) QHNavigationController *currentNavigationController;

@end

