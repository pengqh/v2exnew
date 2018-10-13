//
//  QHTopicModel.h
//  v2exnew
//
//  Created by pengquanhua on 2018/10/13.
//  Copyright © 2018年 pengquanhua. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QHTopicModel : NSObject

@end


@interface QHTopicList : NSObject

@property (nonatomic, strong) NSArray *list;

- (instancetype)initWithArray:(NSArray *)array;

+ (QHTopicList *)getTopicListFromResponseObject:(id)responseObject;

@end
