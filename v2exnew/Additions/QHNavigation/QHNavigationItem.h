//
//  QHNavigationItem.h
//  v2exnew
//
//  Created by pengquanhua on 2018/9/15.
//  Copyright © 2018年 pengquanhua. All rights reserved.
//

#import <Foundation/Foundation.h>

@class QHBarButtonItem;
@interface QHNavigationItem : NSObject

@property (nonatomic, strong) QHBarButtonItem *leftBarButtonItem;
@property (nonatomic, strong) QHBarButtonItem *rightBarButtonItem;
@property (nonatomic, copy) NSString        *title;

@property (nonatomic, readonly) UIView          *titleView;
@property (nonatomic, readonly) UILabel         *titleLabel;

@end
