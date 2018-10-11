//
//  QHMenuSectionCell.h
//  v2exnew
//
//  Created by pengquanhua on 2018/10/11.
//  Copyright © 2018年 pengquanhua. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QHMenuSectionCell : UITableViewCell

@property (nonatomic, copy) NSString *imageName;
@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *badge;

+ (CGFloat)getCellHeight;

@end
