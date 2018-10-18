//
//  QHCheckInManager.m
//  v2exnew
//
//  Created by pengquanhua on 2018/10/18.
//  Copyright © 2018年 pengquanhua. All rights reserved.
//

#import "QHCheckInManager.h"

@implementation QHCheckInManager

- (instancetype)init {
    if (self = [super init]) {
        
    }
    return self;
}

+ (instancetype)manager {
    static QHCheckInManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[QHCheckInManager alloc] init];
    });
    return manager;
}

@end
