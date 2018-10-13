//
//  QHCategoriesViewController.h
//  v2exnew
//
//  Created by pengquanhua on 2018/9/16.
//  Copyright © 2018年 pengquanhua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCPullRefreshViewController.h"

@interface QHCategoriesViewController : SCPullRefreshViewController

@property (nonatomic, assign, getter = isFavorite) BOOL favorite;

@end
