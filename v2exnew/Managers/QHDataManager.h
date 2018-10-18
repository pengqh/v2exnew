//
//  QHDataManager.h
//  v2exnew
//
//  Created by pengquanhua on 2018/10/12.
//  Copyright © 2018年 pengquanhua. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "QHTopicModel.h"
#import "QHReplyModel.h"
#import "QHUserModel.h"

typedef NS_ENUM(NSInteger, V2ErrorType) {
    
    V2ErrorTypeNoOnceAndNext          = 700,
    V2ErrorTypeLoginFailure           = 701,
    V2ErrorTypeRequestFailure         = 702,
    V2ErrorTypeGetFeedURLFailure      = 703,
    V2ErrorTypeGetTopicListFailure    = 704,
    V2ErrorTypeGetNotificationFailure = 705,
    V2ErrorTypeGetFavUrlFailure       = 706,
    V2ErrorTypeGetMemberReplyFailure  = 707,
    V2ErrorTypeGetTopicTokenFailure   = 708,
    V2ErrorTypeGetCheckInURLFailure   = 709,
    
};

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

@property (nonatomic, strong) QHUserModel *user;
@property (nonatomic, assign) BOOL preferHttps;

#pragma mark - GET

- (NSURLSessionDataTask *)getTopicListWithType:(V2HotNodesType)type
                                       Success:(void (^)(QHTopicList *list))success
                                       failure:(void (^)(NSError *error))failure;


- (NSURLSessionDataTask *)getMemberTopicListWithType:(V2HotNodesType)type
                                                page:(NSInteger)page
                                             Success:(void (^)(QHTopicList *list))success
                                             failure:(void (^)(NSError *error))failure;

- (NSURLSessionDataTask *)getTopicWithTopicId:(NSString *)topicId
                                      success:(void (^)(QHTopicModel *model))success
                                      failure:(void (^)(NSError *error))failure;

- (NSURLSessionDataTask *)getReplyListWithTopicId:(NSString *)topicId
                                          success:(void (^)(QHReplyList *list))success
                                          failure:(void (^)(NSError *error))failure;


- (NSURLSessionDataTask *)getTopicListWithNodeId:(NSString *)nodeId
                                        nodename:(NSString *)name
                                        username:(NSString *)username
                                            page:(NSInteger)page
                                         success:(void (^)(QHTopicList *list))success
                                         failure:(void (^)(NSError *error))failure;

- (NSURLSessionDataTask *)getMemberNodeListSuccess:(void (^)(NSArray *list))success
                                           failure:(void (^)(NSError *error))failure;


- (NSURLSessionDataTask *)getMemberProfileWithUserId:(NSString *)userid
                                            username:(NSString *)username
                                             success:(void (^)(QHMemberModel *member))success
                                             failure:(void (^)(NSError *error))failure;

#pragma mark - Action

- (NSURLSessionDataTask *)favNodeWithName:(NSString *)nodeName
                                  success:(void (^)(NSString *message))success
                                  failure:(void (^)(NSError *error))failure;

- (NSURLSessionDataTask *)topicIgnoreWithTopicId:(NSString *)topicId
                                         success:(void (^)(NSString *message))success
                                         failure:(void (^)(NSError *error))failure;

- (NSURLSessionDataTask *)topicFavWithTopicId:(NSString *)topicId
                                        token:(NSString *)token
                                      success:(void (^)(NSString *message))success
                                      failure:(void (^)(NSError *error))failure;

- (NSURLSessionDataTask *)topicFavCancelWithTopicId:(NSString *)topicId
                                              token:(NSString *)token
                                            success:(void (^)(NSString *message))success
                                            failure:(void (^)(NSError *error))failure;

- (NSURLSessionDataTask *)topicThankWithTopicId:(NSString *)topicId
                                          token:(NSString *)token
                                        success:(void (^)(NSString *message))success
                                        failure:(void (^)(NSError *error))failure;


- (NSURLSessionDataTask *)replyThankWithReplyId:(NSString *)replyId
                                          token:(NSString *)token
                                        success:(void (^)(NSString *message))success
                                        failure:(void (^)(NSError *error))failure;

#pragma mark - Token

- (NSURLSessionDataTask *)getTopicTokenWithTopicId:(NSString *)topicId
                                           success:(void (^)(NSString *token))success
                                           failure:(void (^)(NSError *error))failure;

#pragma mark - Public Request Methods - Login & Profile

- (NSURLSessionDataTask *)UserLoginWithUsername:(NSString *)username password:(NSString *)password
                                        success:(void (^)(NSString *message))success
                                        failure:(void (^)(NSError *error))failure;
@end
