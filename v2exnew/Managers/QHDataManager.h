//
//  QHDataManager.h
//  v2exnew
//
//  Created by pengquanhua on 2018/10/12.
//  Copyright © 2018年 pengquanhua. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "QHTopicModel.h"

typedef NS_ENUM (NSInteger, V2HotNodesType) {
    
    V2HotNodesTypeTech,
    V2HotNodesTypeCreative,
    V2HotNodesTypePlay,
    V2HotNodesTypeApple,
    V2HotNodesTypeJobs,
    V2HotNodesTypeDeals,
    V2HotNodesTypeCity,
    V2HotNodesTypeQna,
    V2HotNodesTypeHot,
    V2HotNodesTypeAll,
    V2HotNodesTypeR2,
    V2HotNodesTypeNodes,
    V2HotNodesTypeMembers,
    V2HotNodesTypeFav,
    
};

@interface QHDataManager : NSObject

+ (instancetype)manager;

@property (nonatomic, assign) BOOL preferHttps;

#pragma mark - GET

- (NSURLSessionDataTask *)getTopicListWithType:(V2HotNodesType)type
                                       Success:(void (^)(NSArray *list))success
                                       failure:(void (^)(NSError *error))failure;

@end
