//
//  QHProfileViewController.h
//  v2exnew
//
//  Created by pengquanhua on 2018/10/18.
//  Copyright © 2018年 pengquanhua. All rights reserved.
//

#import "SCPullRefreshViewController.h"

@interface QHProfileViewController : SCPullRefreshViewController

@property (nonatomic, assign) BOOL isSelf;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, strong) QHMemberModel *member;

@end
