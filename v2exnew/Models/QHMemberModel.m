//
//  QHMemberModel.m
//  v2exnew
//
//  Created by pengquanhua on 2018/10/14.
//  Copyright © 2018年 pengquanhua. All rights reserved.
//

#import "QHMemberModel.h"

@implementation QHMemberModel

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    if (self = [super initWithDictionary:dict]) {
        
        self.memberId            = [dict objectForSafeKey:@"id"];
        self.memberName          = [dict objectForSafeKey:@"username"];
        self.memberAvatarMini    = [dict objectForSafeKey:@"avatar_mini"];
        self.memberAvatarNormal  = [dict objectForSafeKey:@"avatar_normal"];
        self.memberAvatarLarge   = [dict objectForSafeKey:@"avatar_large"];
        self.memberTagline = [dict objectForSafeKey:@"tagline"];
        
        if ([self.memberAvatarMini hasPrefix:@"//"]) {
            self.memberAvatarMini = [@"http:" stringByAppendingString:self.memberAvatarMini];
        }
        
        if ([self.memberAvatarNormal hasPrefix:@"//"]) {
            self.memberAvatarNormal = [@"http:" stringByAppendingString:self.memberAvatarNormal];
        }
        
        if ([self.memberAvatarLarge hasPrefix:@"//"]) {
            self.memberAvatarLarge = [@"http:" stringByAppendingString:self.memberAvatarLarge];
        }
        
        self.memberBio = [dict objectForSafeKey:@"bio"];
        self.memberCreated = [dict objectForSafeKey:@"created"];
        self.memberLocation = [dict objectForSafeKey:@"location"];
        self.memberStatus = [dict objectForSafeKey:@"status"];
        self.memberTwitter = [dict objectForSafeKey:@"twitter"];
        self.memberUrl = [dict objectForSafeKey:@"url"];
        self.memberWebsite = [dict objectForSafeKey:@"website"];
        
    }
    
    return self;
}

@end
