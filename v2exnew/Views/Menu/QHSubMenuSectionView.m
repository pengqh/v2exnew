//
//  QHSubMenuSectionView.m
//  v2exnew
//
//  Created by pengquanhua on 2018/10/12.
//  Copyright © 2018年 pengquanhua. All rights reserved.
//

#import "QHSubMenuSectionView.h"
#import "QHSubMenuSectionCell.h"

@interface QHSubMenuSectionView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;


@end

@implementation QHSubMenuSectionView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self configureTableView];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveThemeChangeNotification) name:kThemeDidChangeNotification object:nil];
        
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)configureTableView {
    
    self.tableView                 = [[UITableView alloc] initWithFrame:CGRectZero];
    self.tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate        = self;
    self.tableView.dataSource      = self;
    self.tableView.contentInsetTop = 44;
    [self addSubview:self.tableView];
    
}

#pragma mark - Layout

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.tableView.frame = (CGRect){0, 0, self.width, self.height};
    self.tableView.backgroundColor = kBackgroundColorWhiteDark;
    
    NSUInteger row = 0;
    if (self.isFavorite) {
        row = [QHSettingManager manager].favoriteSelectedSectionIndex;
    } else {
        row = [QHSettingManager manager].categoriesSelectedSectionIndex;
    }
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
}


#pragma mark - Setters

- (void)setSectionTitleArray:(NSArray *)sectionTitleArray {
    _sectionTitleArray = sectionTitleArray;
    
    [self.tableView reloadData];
}

#pragma mark - TableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.sectionTitleArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self heightCellForIndexPath:indexPath];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"CellIdentifier";
    QHSubMenuSectionCell *cell = (QHSubMenuSectionCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[QHSubMenuSectionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    return [self configureWithCell:cell IndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.didSelectedIndexBlock) {
        self.didSelectedIndexBlock(indexPath.row);
    }
    
}

#pragma mark - Configure TableCell

- (CGFloat)heightCellForIndexPath:(NSIndexPath *)indexPath {
    
    return [QHSubMenuSectionCell getCellHeight];
    
}

- (QHSubMenuSectionCell *)configureWithCell:(QHSubMenuSectionCell *)cell IndexPath:(NSIndexPath *)indexPath {
    
    cell.title     = self.sectionTitleArray[indexPath.row];
    
    return cell;
    
}

#pragma mark - Notifications

- (void)didReceiveThemeChangeNotification {
    
    [self.tableView reloadData];
    [self setNeedsLayout];
    //    NSIndexPath *selectedIndex = [self.tableView indexPathForSelectedRow];
    //    [self.tableView reloadData];
    //    [self.tableView selectRowAtIndexPath:selectedIndex animated:NO scrollPosition:UITableViewScrollPositionNone];
    
}

@end
