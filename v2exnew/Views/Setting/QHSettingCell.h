//
//  QHSettingCell.h
//  v2exnew
//
//  Created by pengquanhua on 2018/10/18.
//  Copyright © 2018年 pengquanhua. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QHSettingCell : UITableViewCell

@property (nonatomic, copy) NSString *title;

@property (nonatomic, assign, getter = isTop) BOOL top;
@property (nonatomic, assign, getter = isBottom) BOOL bottom;

@end
