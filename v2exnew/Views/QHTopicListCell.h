//
//  QHTopicListCell.h
//  v2exnew
//
//  Created by pengquanhua on 2018/10/14.
//  Copyright © 2018年 pengquanhua. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QHTopicListCell : UITableViewCell

@property (nonatomic, strong) QHTopicModel *model;

@property (nonatomic, assign) BOOL         isTop;

- (void)updateStatus;

+ (CGFloat)getCellHeightWithTopicModel:(QHTopicModel *)model;
+ (CGFloat)heightWithTopicModel:(QHTopicModel *)model;

@end
