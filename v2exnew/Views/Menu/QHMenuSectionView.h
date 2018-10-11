//
//  QHMenuSectionView.h
//  v2exnew
//
//  Created by pengquanhua on 2018/10/11.
//  Copyright © 2018年 pengquanhua. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QHMenuSectionView : UIView

@property (nonatomic, copy) void (^didSelectedIndexBlock)(NSInteger index);

- (void)setDidSelectedIndexBlock:(void (^)(NSInteger index))didSelectedIndexBlock;

@end
