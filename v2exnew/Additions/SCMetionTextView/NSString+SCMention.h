//
//  NSString+SCMention.h
//  v2exnew
//
//  Created by pengquanhua on 2018/10/16.
//  Copyright © 2018年 pengquanhua. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (SCMention)

- (NSString *)enumerateMetionObjectsUsingBlock:(void (^)(id object, NSRange range))block;

- (NSString *)metionPlainString;

- (NSString *)mentionStringFromHtmlString:(NSString *)htmlString;

- (NSArray *)quoteArray;

@end
