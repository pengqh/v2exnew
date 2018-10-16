//
//  QHReplyModel.h
//  v2exnew
//
//  Created by pengquanhua on 2018/10/16.
//  Copyright © 2018年 pengquanhua. All rights reserved.
//

#import "QHBaseModel.h"

@class QHMemberModel;

@interface QHReplyModel : QHBaseModel

@property (nonatomic, copy  ) NSString *replyId;
@property (nonatomic, copy  ) NSString *replyThanksCount;
@property (nonatomic, copy  ) NSString *replyModified;
@property (nonatomic, strong) NSNumber *replyCreated;
@property (nonatomic, copy  ) NSString *replyContent;
@property (nonatomic, copy  ) NSString *replyContentRendered;

@property (nonatomic, strong) NSArray            *quoteArray;
@property (nonatomic, copy  ) NSAttributedString *attributedString;
@property (nonatomic, strong) NSArray            *contentArray;
@property (nonatomic, strong) NSArray            *imageURLs;

@property (nonatomic, strong) QHMemberModel *replyCreator;

@end

@interface QHReplyList : NSObject

@property (nonatomic, strong) NSArray *list;

- (instancetype)initWithArray:(NSArray*) array;

@end
