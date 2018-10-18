//
//  QHProfileCell.h
//  v2exnew
//
//  Created by pengquanhua on 2018/10/18.
//  Copyright © 2018年 pengquanhua. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, V2ProfileCellType) {
    V2ProfileCellTypeTopic,
    V2ProfileCellTypeReply,
    V2ProfileCellTypeTwitter,
    V2ProfileCellTypeLocation,
    V2ProfileCellTypeWebsite
};

static NSString *const kProfileType = @"profileType";
static NSString *const kProfileValue = @"profileValue";

@interface QHProfileCell : UITableViewCell

@property (nonatomic, assign) V2ProfileCellType type;
@property (nonatomic, copy) NSString *title;

@property (nonatomic, assign) BOOL isTop;
@property (nonatomic, assign) BOOL isBottom;

+ (CGFloat)getCellHeight;

@end
