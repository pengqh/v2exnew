//
//  QHTopicViewController.h
//  v2exnew
//
//  Created by pengquanhua on 2018/9/16.
//  Copyright © 2018年 pengquanhua. All rights reserved.
//

#import "SCPullRefreshViewController.h"

@interface QHTopicViewController : SCPullRefreshViewController

@property (nonatomic, assign, getter=isCreate) BOOL create;

@property (nonatomic, strong) QHTopicModel *model;

@end
