//
//  QHBarButtonItem.h
//  v2exnew
//
//  Created by pengquanhua on 2018/9/15.
//  Copyright © 2018年 pengquanhua. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, SCBarButtonItemStyle) {  // for future use
    SCBarButtonItemStylePlain,
    SCBarButtonItemStyleBordered,
    SCBarButtonItemStyleDone,
};

@interface QHBarButtonItem : NSObject

@property (nonatomic, strong) UIView *view;

@property (nonatomic, assign, getter = isEnabled) BOOL enabled;

- (instancetype)initWithTitle:(NSString *)title style:(SCBarButtonItemStyle)style handler:(void (^)(id sender))action;

- (instancetype)initWithImage:(UIImage *)image style:(SCBarButtonItemStyle)style handler:(void (^)(id sender))action;
@end
