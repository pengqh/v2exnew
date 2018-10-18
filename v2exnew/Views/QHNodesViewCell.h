//
//  QHNodesViewCell.h
//  v2exnew
//
//  Created by pengquanhua on 2018/10/18.
//  Copyright © 2018年 pengquanhua. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QHNodesViewCell : UITableViewCell

@property (nonatomic, strong) NSArray *nodesArray;
@property (nonatomic, assign) UINavigationController *navi;

+ (CGFloat)getCellHeightWithNodesArray:(NSArray *)nodes;

@end
