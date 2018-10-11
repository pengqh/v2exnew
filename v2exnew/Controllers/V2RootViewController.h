//
//  V2RootViewController.h
//  v2exnew
//
//  Created by pengquanhua on 2018/9/12.
//  Copyright © 2018年 pengquanhua. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, V2SectionIndex) {
    V2SectionIndexLatest       = 0,
    V2SectionIndexCategories   = 1,
    V2SectionIndexNodes        = 2,
    V2SectionIndexFavorite     = 3,
    V2SectionIndexNotification = 4,
    V2SectionIndexProfile      = 5,
};

@interface V2RootViewController : UIViewController

@end
