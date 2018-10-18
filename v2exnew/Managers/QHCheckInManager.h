//
//  QHCheckInManager.h
//  v2exnew
//
//  Created by pengquanhua on 2018/10/18.
//  Copyright © 2018年 pengquanhua. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QHCheckInManager : NSObject

@property (nonatomic, assign) NSInteger checkInCount;
@property (nonatomic, assign, getter = isExpired) BOOL expired;

+ (instancetype)manager;

- (void)resetStatus;

- (void)updateStatus;

- (void)removeStatus;

@end
