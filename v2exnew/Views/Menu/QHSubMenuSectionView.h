//
//  QHSubMenuSectionView.h
//  v2exnew
//
//  Created by pengquanhua on 2018/10/12.
//  Copyright © 2018年 pengquanhua. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QHSubMenuSectionView : UIView

@property (nonatomic, strong) NSArray *sectionTitleArray;
@property (nonatomic, assign, getter = isFavorite) BOOL favorite;

//@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, copy) void (^didSelectedIndexBlock)(NSInteger index);

- (void)setDidSelectedIndexBlock:(void (^)(NSInteger index))didSelectedIndexBlock;

@end
