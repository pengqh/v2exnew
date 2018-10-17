//
//  QHTopicToolBarView.h
//  v2exnew
//
//  Created by pengquanhua on 2018/10/17.
//  Copyright © 2018年 pengquanhua. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QHTopicToolBarView : UIView

@property (nonatomic, assign, getter = isCreate) BOOL create;

@property (nonatomic, copy) void (^insertImageBlock)();
@property (nonatomic, copy) void (^contentIsEmptyBlock)(BOOL isEmpty);

- (void)showReplyViewWithQuotes:(NSArray *)quotes animated:(BOOL)animated;

@end
