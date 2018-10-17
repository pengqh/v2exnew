//
//  QHTopicToolBarItemView.h
//  v2exnew
//
//  Created by pengquanhua on 2018/10/17.
//  Copyright © 2018年 pengquanhua. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QHTopicToolBarItemView : UIView

@property (nonatomic, copy  ) NSString           *itemTitle;
@property (nonatomic, strong) UIImage            *itemImage;
@property (nonatomic, copy) void (^buttonPressedBlock)(void);

@property (nonatomic, copy) UIColor *backgroundColorNormal;
@property (nonatomic, copy) UIColor *backgroundColorHighlighted;

@end
