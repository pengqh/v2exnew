//
//  QHTopicBodyCell.h
//  v2exnew
//
//  Created by pengquanhua on 2018/10/16.
//  Copyright © 2018年 pengquanhua. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QHTopicBodyCell : UITableViewCell

@property (nonatomic, strong) QHTopicModel *model;
@property (nonatomic, assign) UINavigationController *navi;

@property (nonatomic, copy) void (^reloadCellBlock)(void);

+ (CGFloat)getCellHeightWithTopicModel:(QHTopicModel *)model;

@end
