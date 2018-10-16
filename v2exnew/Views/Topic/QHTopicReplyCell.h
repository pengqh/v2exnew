//
//  QHTopicReplyCell.h
//  v2exnew
//
//  Created by pengquanhua on 2018/10/16.
//  Copyright © 2018年 pengquanhua. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QHTopicReplyCell : UITableViewCell

@property (nonatomic, strong) QHReplyModel *model;
@property (nonatomic, strong) QHReplyModel *selectedReplyModel;

@property (nonatomic, assign) UINavigationController *navi;
@property (nonatomic, assign) QHReplyList *replyList;

@property (nonatomic, copy) void (^longPressedBlock)(void);
@property (nonatomic, copy) void (^reloadCellBlock)(void);

+ (CGFloat)getCellHeightWithReplyModel:(QHReplyModel *)model;


@end

static NSString * const kSelectMemberNotification = @"SelectMemberNotification";
