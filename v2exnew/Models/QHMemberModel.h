//
//  QHMemberModel.h
//  v2exnew
//
//  Created by pengquanhua on 2018/10/14.
//  Copyright © 2018年 pengquanhua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QHBaseModel.h"

@interface QHMemberModel : QHBaseModel

@property (nonatomic, copy) NSString *memberId;
@property (nonatomic, copy) NSString *memberName;
@property (nonatomic, copy) NSString *memberAvatarMini;
@property (nonatomic, copy) NSString *memberAvatarNormal;
@property (nonatomic, copy) NSString *memberAvatarLarge;
@property (nonatomic, copy) NSString *memberTagline;

@property (nonatomic, copy) NSString *memberBio;
@property (nonatomic, copy) NSString *memberCreated;
@property (nonatomic, copy) NSString *memberLocation;
@property (nonatomic, copy) NSString *memberStatus;
@property (nonatomic, copy) NSString *memberTwitter;
@property (nonatomic, copy) NSString *memberUrl;
@property (nonatomic, copy) NSString *memberWebsite;

@end
