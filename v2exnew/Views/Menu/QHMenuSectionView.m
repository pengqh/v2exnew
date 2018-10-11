//
//  QHMenuSectionView.m
//  v2exnew
//
//  Created by pengquanhua on 2018/10/11.
//  Copyright © 2018年 pengquanhua. All rights reserved.
//

#import "QHMenuSectionView.h"
#import "QHMenuSectionCell.h"

static CGFloat const kAvatarHeight = 70.0f;

@interface QHMenuSectionView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UIButton    *avatarButton;
@property (nonatomic, strong) UIImageView *divideImageView;
@property (nonatomic, strong) UILabel     *usernameLabel;

//@property (nonatomic, strong) SCActionSheet      *actionSheet;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray     *sectionImageNameArray;
@property (nonatomic, strong) NSArray     *sectionTitleArray;

@end

@implementation QHMenuSectionView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.sectionImageNameArray = @[@"section_latest", @"section_categories", @"section_nodes", @"section_fav", @"section_notification", @"section_profile"];
        self.sectionTitleArray = @[@"最新", @"分类", @"节点", @"收藏", @"提醒", @"个人"];
        
        [self configureTableView];
        [self configureProfileView];
        
    }
    return self;
}

- (void)configureTableView {
    
    self.tableView                 = [[UITableView alloc] initWithFrame:CGRectZero];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate        = self;
    self.tableView.dataSource      = self;
    self.tableView.contentInsetTop = 100 + UIView.sc_statusBarHeight;
    [self addSubview:self.tableView];
    
}

- (void)configureProfileView {
    self.avatarImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"avatar_default"]];
    self.avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.avatarImageView.clipsToBounds = YES;
    self.avatarImageView.layer.cornerRadius = 5; //kAvatarHeight / 2.0;
    self.avatarImageView.layer.borderColor = RGB(0x8a8a8a, 1.0).CGColor;
    self.avatarImageView.layer.borderWidth = 1.0f;
    [self addSubview:self.avatarImageView];
    
//    self.avatarImageView.alpha = kSetting.imageViewAlphaForCurrentTheme;
//
//    if ([V2DataManager manager].user.isLogin) {
//        [self.avatarImageView setImageWithURL:[NSURL URLWithString:[V2DataManager manager].user.member.memberAvatarLarge] placeholderImage:[UIImage imageNamed:@"avatar_default"]];
//        self.avatarImageView.layer.borderColor = RGB(0x8a8a8a, 0.1).CGColor;
//    }
    
    self.avatarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:self.avatarButton];
    
    self.divideImageView = [[UIImageView alloc] init];
    self.divideImageView.backgroundColor = kLineColorBlackDark;
    self.divideImageView.contentMode = UIViewContentModeScaleAspectFill;
    //    self.divideImageView.image = [UIImage imageNamed:@"section_divide"];
    self.divideImageView.clipsToBounds = YES;
    [self addSubview:self.divideImageView];
    
    // Handles
    [self.avatarButton bk_addEventHandler:^(id sender) {
        
    } forControlEvents:UIControlEventTouchUpInside];
    
}

#pragma mark - Layout

- (void)layoutSubviews {
    
    self.avatarImageView.frame = (CGRect){30, 10 + UIView.sc_statusBarHeight, kAvatarHeight, kAvatarHeight};
    self.avatarButton.frame = self.avatarImageView.frame;
    self.divideImageView.frame = (CGRect){-self.width, kAvatarHeight + 30 + UIView.sc_statusBarHeight, self.width * 2, 0.5};
    self.tableView.frame = (CGRect){0, 0, self.width, self.height};
    
    //[self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:[V2SettingManager manager].selectedSectionIndex inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
}

#pragma mark - TableVIewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.sectionTitleArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self heightCellForIndexPath:indexPath];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"CellIdentifier";
    QHMenuSectionCell *cell = (QHMenuSectionCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[QHMenuSectionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    return [self configureWithCell:cell IndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.didSelectedIndexBlock) {
        self.didSelectedIndexBlock(indexPath.row);
    }
}

#pragma mark - Configure TableCell

- (CGFloat)heightCellForIndexPath:(NSIndexPath *)indexPath {
    return [QHMenuSectionCell getCellHeight];
}

- (QHMenuSectionCell*)configureWithCell:(QHMenuSectionCell *) cell IndexPath:(NSIndexPath *)indexPath {
    
    cell.imageName = self.sectionImageNameArray[indexPath.row];
    cell.title     = self.sectionTitleArray[indexPath.row];
    
    cell.badge = nil;
    
    return cell;
    
}

@end
