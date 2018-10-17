//
//  QHActionCellView.h
//  v2exnew
//
//  Created by pengquanhua on 2018/10/17.
//  Copyright © 2018年 pengquanhua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCActionSheet.h"

@interface QHActionCellView : UIView

@property (nonatomic, weak) SCActionSheet *actionSheet;

- (instancetype)initWithTitles:(NSArray *)titles imageNames:(NSArray *)imageNames;

- (void)sc_setButtonHandler:(void (^)(void))block forIndex:(NSInteger)index;

@end
