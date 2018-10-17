//
//  QHActionItemView.h
//  v2exnew
//
//  Created by pengquanhua on 2018/10/17.
//  Copyright © 2018年 pengquanhua. All rights reserved.
//

#import <UIKit/UIKit.h>

static CGFloat const kItemHeight = 80;
static CGFloat const kItemHeightTitle = 100;
static CGFloat const kItemWidth = 50.;
static CGFloat const kTitleFontSize = 11;

@interface QHActionItemView : UIView

@property (nonatomic, copy) void (^actionBlock)(UIButton *button, UILabel *label);

- (instancetype)initWithTitle:(NSString *)title imageName:(NSString *)imageName;

@end
