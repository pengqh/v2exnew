//
//  SCActionSheetButton.h
//  v2exnew
//
//  Created by pengquanhua on 2018/10/17.
//  Copyright © 2018年 pengquanhua. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, SCActionSheetButtonType) {
    SCActionSheetButtonTypeRed,
    SCActionSheetButtonTypeNormal
};

@interface SCActionSheetButton : UIButton

@property (nonatomic, strong) UIColor *buttonBottomLineColor;
@property (nonatomic, strong) UIColor *buttonBackgroundColor;
@property (nonatomic, strong) UIColor *buttonBorderColor;

@property (nonatomic, assign) SCActionSheetButtonType type;

@end
