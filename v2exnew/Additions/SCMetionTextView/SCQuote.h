//
//  SCQuote.h
//  v2exnew
//
//  Created by pengquanhua on 2018/10/16.
//  Copyright © 2018年 pengquanhua. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, SCQuoteType) {
    SCQuoteTypeNone,
    SCQuoteTypeUser,
    SCQuoteTypeEmail,
    SCQuoteTypeLink,
    SCQuoteTypeAppStore,
    SCQuoteTypeImage,
    SCQuoteTypeVedio,
    SCQuoteTypeTopic,
    SCQuoteTypeNode,
};

@interface SCQuote : NSObject

@property (nonatomic, copy) NSString *string;
@property (nonatomic, copy) NSString *identifier;
@property (nonatomic, assign)  SCQuoteType type;

@property (nonatomic, assign) NSRange range;
@property (nonatomic, strong) NSMutableArray *backgroundArray;

- (NSString *)quoteString;

@end
