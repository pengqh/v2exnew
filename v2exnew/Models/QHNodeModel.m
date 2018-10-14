//
//  QHNodeModel.m
//  v2exnew
//
//  Created by pengquanhua on 2018/10/13.
//  Copyright © 2018年 pengquanhua. All rights reserved.
//

#import "QHNodeModel.h"

@implementation QHNodeModel

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    if (self = [super initWithDictionary:dict]) {
        
        self.nodeId               = [dict objectForSafeKey:@"id"];
        self.nodeName             = [dict objectForSafeKey:@"name"];
        self.nodeUrl              = [dict objectForSafeKey:@"url"];
        self.nodeTitle            = [dict objectForSafeKey:@"title"];
        self.nodeTitleAlternative = [dict objectForSafeKey:@"title_alternative"];
        self.nodeTopicCount       = [dict objectForSafeKey:@"topics"];
        self.nodeHeader           = [dict objectForSafeKey:@"header"];
        self.nodeFooter           = [dict objectForSafeKey:@"footer"];
        self.nodeCreated          = [dict objectForSafeKey:@"created"];
        
    }
    
    return self;
}

@end


@implementation QHNodeList

- (instancetype)initWithArray:(NSArray *)array {
    if (self = [super init]) {
        
        NSMutableArray *list = [[NSMutableArray alloc] init];
        
        for (NSDictionary *dict in array) {
            QHNodeModel *model = [[QHNodeModel alloc] initWithDictionary:dict];
            [list addObject:model];
        }
        
        self.list = list;
        
    }
    
    return self;
}

@end
