//
//  QHNavigationController.h
//  v2exnew
//
//  Created by pengquanhua on 2018/9/15.
//  Copyright © 2018年 pengquanhua. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QHNavigationController : UINavigationController

@property (nonatomic, assign) BOOL enableInnerInactiveGesture;

+ (void)createNavigationBarForViewController:(UIViewController *)viewController;

@end
