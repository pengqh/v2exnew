//
//  QHDataManager.m
//  v2exnew
//
//  Created by pengquanhua on 2018/10/12.
//  Copyright © 2018年 pengquanhua. All rights reserved.
//

#import "QHDataManager.h"
#import <AFNetworking.h>

typedef NS_ENUM(NSInteger, V2RequestMethod) {
    V2RequestMethodJSONGET    = 1,
    V2RequestMethodHTTPPOST   = 2,
    V2RequestMethodHTTPGET    = 3,
    V2RequestMethodHTTPGETPC  = 4
};

@interface QHDataManager ()

@property (nonatomic, strong) AFHTTPSessionManager *manager;

@property (nonatomic, copy) NSString *userAgentMobile;
@property (nonatomic, copy) NSString *userAgentPC;

@end

@implementation QHDataManager

- (instancetype)init {
    if (self = [super init]) {
        UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectZero];
        self.userAgentMobile = [webView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
        self.userAgentPC = @"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_2) AppleWebKit/537.75.14 (KHTML, like Gecko) Version/7.0.3 Safari/537.75.14";
        
        self.preferHttps = kSetting.preferHttps;
    }
    return self;
}

- (void)setPreferHttps:(BOOL)preferHttps {
    _preferHttps = preferHttps;
    
    NSURL *baseUrl;
    
    baseUrl = [NSURL URLWithString:@"https://www.v2ex.com"];
    
    self.manager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseUrl];
    AFHTTPRequestSerializer* serializer = [AFHTTPRequestSerializer serializer];
    self.manager.requestSerializer = serializer;
}

+ (instancetype)manager {
    static QHDataManager *manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[QHDataManager alloc] init];
    });
    return manager;
}

- (NSURLSessionDataTask *)requestWithMethod:(V2RequestMethod)method
                                  URLString:(NSString *)URLString
                                 parameters:(NSDictionary *)parameters
                                    success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                                    failure:(void (^)(NSError *error))failure  {
    // stateBar
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    // Handle Common Mission, Cache, Data Reading & etc.
    void (^responseHandleBlock)(NSURLSessionDataTask *task, id responseObject) = ^(NSURLSessionDataTask *task, id responseObject) {
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
       
        success(task, responseObject);
    };
    
    NSURLSessionDataTask *task = nil;
    
    [self.manager.requestSerializer setValue:self.userAgentMobile forHTTPHeaderField:@"User-Agent"];
    
    if (method == V2RequestMethodJSONGET) {
        AFHTTPResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializer];
        self.manager.responseSerializer = responseSerializer;
        task = [self.manager GET:URLString parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
            responseHandleBlock(task, responseObject);
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            //V2Log(@"Error: \n%@", [error description]);
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            failure(error);
        }];
    }
    
    if (method == V2RequestMethodHTTPGET) {
        AFHTTPResponseSerializer *responseSerializer = [AFHTTPResponseSerializer serializer];
        self.manager.responseSerializer = responseSerializer;
        task = [self.manager GET:URLString parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            responseHandleBlock(task, responseObject);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            failure(error);
        }];
    }
    
    return task;
}

#pragma mark - Public Request Methods - Get

- (NSURLSessionDataTask *)getTopicListWithType:(V2HotNodesType)type Success:(void (^)(QHTopicList *))success failure:(void (^)(NSError *))failure {
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    switch (type) {
        case V2HotNodesTypeTech:
            [parameters setObject:@"tech" forKey:@"tab"];
            break;
        case V2HotNodesTypeCreative:
            [parameters setObject:@"creative" forKey:@"tab"];
            break;
        case V2HotNodesTypePlay:
            [parameters setObject:@"play" forKey:@"tab"];
            break;
        case V2HotNodesTypeApple:
            [parameters setObject:@"apple" forKey:@"tab"];
            break;
        case V2HotNodesTypeJobs:
            [parameters setObject:@"jobs" forKey:@"tab"];
            break;
        case V2HotNodesTypeDeals:
            [parameters setObject:@"deals" forKey:@"tab"];
            break;
        case V2HotNodesTypeCity:
            [parameters setObject:@"city" forKey:@"tab"];
            break;
        case V2HotNodesTypeQna:
            [parameters setObject:@"qna" forKey:@"tab"];
            break;
        case V2HotNodesTypeHot:
            [parameters setObject:@"hot" forKey:@"tab"];
            break;
        case V2HotNodesTypeAll:
            [parameters setObject:@"all" forKey:@"tab"];
            break;
        case V2HotNodesTypeR2:
            [parameters setObject:@"r2" forKey:@"tab"];
            break;
        case V2HotNodesTypeNodes:
            [parameters setObject:@"nodes" forKey:@"tab"];
            break;
        case V2HotNodesTypeMembers:
            [parameters setObject:@"members" forKey:@"tab"];
            break;
        default:
            [parameters setObject:@"all" forKey:@"tab"];
            break;
    }
    
    return [self requestWithMethod:V2RequestMethodHTTPGET URLString:@"" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        QHTopicList *list = [QHTopicList getTopicListFromResponseObject:responseObject];
        if (list) {
            success(list);
        } else {
            NSError *error = [[NSError alloc] initWithDomain:self.manager.baseURL.absoluteString code:V2ErrorTypeGetTopicListFailure userInfo:nil];
            failure(error);
        }
    } failure:^(NSError *error) {
        failure(error);
    }];
}

- (NSURLSessionDataTask *)getMemberTopicListWithType:(V2HotNodesType)type
                                                page:(NSInteger)page
                                             Success:(void (^)(QHTopicList *list))success
                                             failure:(void (^)(NSError *error))failure {
    NSString *urlString;
    switch (type) {
        case V2HotNodesTypeNodes:
            urlString = @"/my/nodes";
            break;
        case V2HotNodesTypeMembers:
            urlString = @"my/following";
            break;
        case V2HotNodesTypeFav:
            urlString = @"my/topics";
            break;
        default:
            urlString = @"/my/nodes";
            break;
    }
    
    NSDictionary *parameters = @{@"p": @(page)};
    
    return [self requestWithMethod:V2RequestMethodHTTPGET URLString:urlString parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
        QHTopicList *list = [QHTopicList getTopicListFromResponseObject:responseObject];
        
        if (list) {
            success(list);
        } else {
            NSError *error = [[NSError alloc] initWithDomain:self.manager.baseURL.absoluteString code:V2ErrorTypeGetTopicListFailure userInfo:nil];
            failure(error);
        }
    } failure:^(NSError *error) {
        failure(error);
    }];
}

- (NSURLSessionDataTask *)getTopicWithTopicId:(NSString *)topicId
                                      success:(void (^)(QHTopicModel *model))success
                                      failure:(void (^)(NSError *error))failure {
    
    NSDictionary *parameters;
    if (topicId) {
        parameters = @{
                       @"id": topicId
                       };
    }
    
    return [self requestWithMethod:V2RequestMethodJSONGET URLString:@"/api/topics/show.json" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        QHTopicModel *model = [[QHTopicModel alloc] initWithDictionary:[responseObject firstObject]];
        success(model);
    } failure:^(NSError *error) {
        failure(error);
    }];
    
}

- (NSURLSessionDataTask *)getReplyListWithTopicId:(NSString *)topicId
                                          success:(void (^)(QHReplyList *list))success
                                          failure:(void (^)(NSError *error))failure {
    NSDictionary *parameters;
    if (topicId) {
        parameters = @{
                       @"topic_id": topicId
                       };
    }
    
    return [self requestWithMethod:V2RequestMethodJSONGET URLString:@"/api/replies/show.json" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        QHReplyList *list = [[QHReplyList alloc] initWithArray:responseObject];
        success(list);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

- (NSURLSessionDataTask *)getTopicListWithNodeId:(NSString *)nodeId
                                        nodename:(NSString *)name
                                        username:(NSString *)username
                                            page:(NSInteger)page
                                         success:(void (^)(QHTopicList *list))success
                                         failure:(void (^)(NSError *error))failure {
    NSDictionary *parameters;
    if (nodeId) {
        parameters = @{
                       @"node_id": nodeId,
                       @"p": @(page)
                       };
    }
    if (name) {
        parameters = @{
                       @"node_name": name,
                       @"p": @(page)
                       };
    }
    if (username) {
        parameters = @{
                       @"username": username,
                       @"p": @(page)
                       };
    }
    
    return [self requestWithMethod:V2RequestMethodJSONGET URLString:@"/api/topics/show.json" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        QHTopicList *list = [[QHTopicList alloc] initWithArray:responseObject];
        success(list);
    } failure:^(NSError *error) {
        failure(error);
    }];
    
}

@end
