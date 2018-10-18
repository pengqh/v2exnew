//
//  QHUserModel.h
//  v2exnew
//
//  Created by pengquanhua on 2018/10/18.
//  Copyright © 2018年 pengquanhua. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QHUserModel : NSObject

@property (nonatomic, strong) QHMemberModel *member;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, strong) NSURL *feedURL;

@property (nonatomic, assign, getter = isLogin) BOOL login;

@end
