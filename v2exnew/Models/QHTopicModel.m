//
//  QHTopicModel.m
//  v2exnew
//
//  Created by pengquanhua on 2018/10/13.
//  Copyright © 2018年 pengquanhua. All rights reserved.
//

#import "QHTopicModel.h"

@implementation QHTopicModel

@end

@implementation QHTopicList

- (instancetype)initWithArray:(NSArray *)array {
    if (self = [super init]) {
        
    }
    return self;
}

- (void)dealloc {
    _list = nil;
}

+ (QHTopicList*)getTopicListFromResponseObject:(id)responseObject {
    NSMutableArray *topicArray = [[NSMutableArray alloc] init];
    
    @autoreleasepool {
        NSString *htmlString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        NSLog(@"htmlString=%@", htmlString);
    }
    
    return nil;
}

@end
