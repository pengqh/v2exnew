//
//  QHActionCellView.m
//  v2exnew
//
//  Created by pengquanhua on 2018/10/17.
//  Copyright © 2018年 pengquanhua. All rights reserved.
//

#import "QHActionCellView.h"
#import "QHActionItemView.h"

@interface QHActionCellView ()

@property (nonatomic, strong) NSArray *itemArray;
@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) NSArray *imageNames;

@end

@implementation QHActionCellView

- (instancetype)initWithTitles:(NSArray *)titles imageNames:(NSArray *)imageNames {
    if (self = [super initWithFrame:(CGRect){0, 0, kScreenWidth, kItemHeight}]) {
        
        if (titles.count) {
            self.height = kItemHeightTitle;
        } else {
            self.height = kItemHeight;
        }
        
        CGFloat startX = 15;
        CGFloat space = (kScreenWidth - 2 * startX - kItemWidth * 4) / 5;
        
        NSMutableArray *itemArray = [NSMutableArray new];
        for (NSInteger i = 0; i < imageNames.count; i ++) {
            NSString *title;
            if (i < titles.count) {
                title = titles[i];
            }
            QHActionItemView *itemView = [[QHActionItemView alloc] initWithTitle:title imageName:imageNames[i]];
            [self addSubview:itemView];
            [itemArray addObject:itemView];
            itemView.x = startX + space + (space + kItemWidth) * i;
        }
        
        self.itemArray = itemArray;
    }
    return self;
}

- (void)sc_setButtonHandler:(void (^)(void))block forIndex:(NSInteger)index {
    
    if (index >= self.itemArray.count || !block) {
        return;
    }
    
    QHActionItemView *itemView = self.itemArray[index];
    
    [itemView setActionBlock:^(UIButton *button, UILabel *item) {
        if (self.actionSheet) {
            [self.actionSheet sc_hide:YES];
        }
        block();
    }];
    
}

@end
