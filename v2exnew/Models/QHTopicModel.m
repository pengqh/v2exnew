//
//  QHTopicModel.m
//  v2exnew
//
//  Created by pengquanhua on 2018/10/13.
//  Copyright © 2018年 pengquanhua. All rights reserved.
//

#import "QHTopicModel.h"
#import "HTMLParser.h"
#import "RegexKitLite.h"
#import "QHTopicListCell.h"

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
        
        NSError *error = nil;
        HTMLParser *parser = [[HTMLParser alloc] initWithString:htmlString error:&error];
        
        if (error) {
            NSLog(@"Error: %@", error);
        }
        
        HTMLNode *bodyNode = [parser body];
        NSArray *cellNodes = [bodyNode findChildTags:@"div"];
        
        for (HTMLNode *cellNode in cellNodes) {
            if ([[cellNode getAttributeNamed:@"class"] isEqualToString:@"cell item"]) {
                
                QHTopicModel *model = [[QHTopicModel alloc] init];
                model.topicCreator = [[QHMemberModel alloc] init];
                model.topicNode = [[QHNodeModel alloc] init];
                
                NSArray *tdNodes = [cellNode findChildTags:@"td"];
                NSInteger index = 0;
                for (HTMLNode *tdNode in tdNodes) {
                    NSString *content = tdNode.rawContents;
                    
                    if ([content rangeOfString:@"class=\"avatar\""].location != NSNotFound) {
                        HTMLNode *userIdNode = [tdNode findChildTag:@"a"];
                        if (userIdNode) {
                            NSString *idUrlString = [userIdNode getAttributeNamed:@"href"];
                            NSString *memberName = [[idUrlString componentsSeparatedByString:@"/"] lastObject];
                            model.topicCreator.memberName = memberName;
                        }
                        
                        HTMLNode *avatarNode = [tdNode findChildTag:@"img"];
                        if (avatarNode) {
                            NSString *avatarString = [avatarNode getAttributeNamed:@"src"];
                            if ([avatarString hasPrefix:@"//"]) {
                                avatarString = [@"http:" stringByAppendingString:avatarString];
                            }
                            NSString *memberAvatarNormal = avatarString;
                            model.topicCreator.memberAvatarNormal = memberAvatarNormal;
                        }
                    }
                    
                    if ([content rangeOfString:@"class=\"item_title\""].location != NSNotFound) {
                        NSArray *aNodes = [tdNode findChildTags:@"a"];
                        for (HTMLNode *aNode in aNodes) {
                            if ([[aNode getAttributeNamed:@"class"] isEqualToString:@"node"]) {
                                NSString *nodeUrlString = [aNode getAttributeNamed:@"href"];
                                NSString *nodeName = [[nodeUrlString componentsSeparatedByString:@"/"] lastObject];
                                model.topicNode.nodeName = nodeName;
                                NSString *nodeTitle = aNode.allContents;
                                model.topicNode.nodeTitle = nodeTitle;
                            } else {
                                if ([aNode.rawContents rangeOfString:@"reply"].location != NSNotFound) {
                                    NSString *topicTitle = aNode.allContents;
                                    model.topicTitle = topicTitle;
                                    
                                    NSString *topicIdString = [aNode getAttributeNamed:@"href"];
                                    NSArray *subArray = [topicIdString componentsSeparatedByString:@"#"];
                                    NSString *topicId = [(NSString *)subArray.firstObject stringByReplacingOccurrencesOfString:@"/t/" withString:@""];
                                    model.topicId = topicId;
                                    
                                     NSString *topicReplyCount = [(NSString *)subArray.lastObject stringByReplacingOccurrencesOfString:@"reply" withString:@""];
                                    model.topicReplyCount = topicReplyCount;
                                    
                                }
                            }
                        }
                        
                        NSArray *spanNodes = [tdNode findChildTags:@"span"];
                        for (HTMLNode *spanNode in spanNodes) {
                            if ([spanNode.rawContents rangeOfString:@"href"].location == NSNotFound) {
                                NSString *topicCreatedDescription = spanNode.allContents;
                                model.topicCreatedDescription = topicCreatedDescription;
                            }
                            
                            if ([spanNode.rawContents rangeOfString:@"最后回复"].location != NSNotFound || [spanNode.rawContents rangeOfString:@"前"].location != NSNotFound) {
                                
                                NSString *contentString = spanNode.allContents;
                                NSArray *components = [contentString componentsSeparatedByString:@"  •  "];
                                NSString *dateString;
                                
                                if (components.count > 2) {
                                    dateString = components[2];
                                } else {
                                    dateString = [contentString stringByReplacingOccurrencesOfRegex:@"  •  (.*?)$" withString:@""];
                                }
                                
                                NSArray *stringArray = [dateString componentsSeparatedByString:@" "];
                                if (stringArray.count > 1) {
                                    NSString *unitString = @"";
                                    NSString *subString = [(NSString *)stringArray[1] substringToIndex:1];
                                    if ([subString isEqualToString:@"分"]) {
                                        unitString = @"分钟前";
                                    }
                                    if ([subString isEqualToString:@"小"]) {
                                        unitString = @"小时前";
                                    }
                                    if ([subString isEqualToString:@"天"]) {
                                        unitString = @"天前";
                                    }
                                    //                                    unitString = stringArray[1];
                                    dateString = [NSString stringWithFormat:@"%@%@", stringArray[0], unitString];
                                } else {
                                    //                                    dateString = @"just now";
                                    dateString = @"刚刚";
                                }
                                NSString *topicCreatedDescription = dateString;
                                model.topicCreatedDescription = topicCreatedDescription;
                            }
                        }
                    }
                    index ++;
                }
                //model.state = [[V2TopicStateManager manager] getTopicStateWithTopicModel:model];
                model.cellHeight = [QHTopicListCell heightWithTopicModel:model];
                [topicArray addObject:model];
            }
        }
    }
    
    QHTopicList *list;
    
    if (topicArray.count) {
        list = [[QHTopicList alloc] init];
        list.list = topicArray;
    }
    
    return list;
}

@end
