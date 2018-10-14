//
//  QHTopicModel.h
//  v2exnew
//
//  Created by pengquanhua on 2018/10/13.
//  Copyright © 2018年 pengquanhua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QHBaseModel.h"
#import "QHMemberModel.h"
#import "QHNodeModel.h"

typedef NS_ENUM (NSInteger, V2TopicState) {
    
    V2TopicStateUnreadWithReply      = 1 << 0,
    V2TopicStateUnreadWithoutReply   = 1 << 1,
    V2TopicStateReadWithoutReply     = 1 << 2,
    V2TopicStateReadWithReply        = 1 << 3,
    V2TopicStateReadWithNewReply     = 1 << 4,
    V2TopicStateRepliedWithNewReply  = 1 << 5,
    
};

@interface QHTopicModel : NSObject

@property (nonatomic, copy) NSString *topicId;
@property (nonatomic, copy) NSString *topicTitle;
@property (nonatomic, copy) NSString *topicReplyCount;
@property (nonatomic, copy) NSString *topicUrl;
@property (nonatomic, copy) NSString *topicContent;
@property (nonatomic, copy) NSString *topicContentRendered;
@property (nonatomic, copy) NSNumber *topicCreated;
@property (nonatomic, copy) NSString *topicCreatedDescription;
@property (nonatomic, copy) NSString *topicModified;
@property (nonatomic, copy) NSString *topicTouched;

@property (nonatomic, strong) NSArray            *quoteArray;
@property (nonatomic, copy  ) NSAttributedString *attributedString;
@property (nonatomic, strong) NSArray            *contentArray;
@property (nonatomic, strong) NSArray            *imageURLs;

@property (nonatomic, strong) QHMemberModel *topicCreator;
@property (nonatomic, strong) QHNodeModel   *topicNode;

@property (nonatomic, assign) V2TopicState  state;
@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, assign) CGFloat titleHeight;

@end


@interface QHTopicList : QHBaseModel

@property (nonatomic, strong) NSArray *list;

- (instancetype)initWithArray:(NSArray *)array;

+ (QHTopicList *)getTopicListFromResponseObject:(id)responseObject;

@end
