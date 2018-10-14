//
//  QHNodeModel.h
//  v2exnew
//
//  Created by pengquanhua on 2018/10/13.
//  Copyright © 2018年 pengquanhua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QHBaseModel.h"

@interface QHNodeModel : QHBaseModel

@property (nonatomic, copy) NSString *nodeId;
@property (nonatomic, copy) NSString *nodeName;
@property (nonatomic, copy) NSString *nodeUrl;
@property (nonatomic, copy) NSString *nodeTitle;
@property (nonatomic, copy) NSString *nodeTitleAlternative;
@property (nonatomic, copy) NSString *nodeTopicCount;
@property (nonatomic, copy) NSString *nodeHeader;
@property (nonatomic, copy) NSString *nodeFooter;
@property (nonatomic, copy) NSString *nodeCreated;

@end

@interface QHNodeList : NSObject

@property (nonatomic, strong) NSArray *list;

- (instancetype)initWithArray:(NSArray *)array;

@end
