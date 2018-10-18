//
//  QHProfileViewController.m
//  v2exnew
//
//  Created by pengquanhua on 2018/10/18.
//  Copyright © 2018年 pengquanhua. All rights reserved.
//

#import "QHProfileViewController.h"
#import "QHProfileCell.h"
#import "MBProgressHUD.h"
#import "QHSettingViewController.h"

static CGFloat const kAvatarHeight = 60.0f;

@interface QHProfileViewController () <UITableViewDataSource, UITableViewDelegate, MBProgressHUDDelegate>

@property (nonatomic, strong) QHBarButtonItem    *leftBarItem;
@property (nonatomic, strong) QHBarButtonItem    *backBarItem;
@property (nonatomic, strong) QHBarButtonItem    *settingBarItem;
@property (nonatomic, strong) QHBarButtonItem    *actionBarItem;

@property (nonatomic, strong) NSArray *headerTitleArray;

@property (nonatomic, strong) UIView      *topPanel;
@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UILabel     *nameLabel;
@property (nonatomic, strong) UILabel     *signLabel;

@property (nonatomic, copy) NSURLSessionDataTask* (^getProfileBlock)(void);
@property (nonatomic, assign) BOOL didGetProfile;

@end

@implementation QHProfileViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.headerTitleArray = @[@"社区", @"信息", @"个人简介"];
        self.didGetProfile = NO;
    }
    return self;
}

- (void)loadView {
    [super loadView];
    
    [self configureBarItems];
    [self configureTableView];
    [self configureTopView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.isSelf) {
        self.sc_navigationItem.title = @"个人";
        self.sc_navigationItem.leftBarButtonItem = self.leftBarItem;
        self.sc_navigationItem.rightBarButtonItem = self.settingBarItem;
    } else {
        self.sc_navigationItem.title = @"用户";
        self.sc_navigationItem.leftBarButtonItem = self.backBarItem;
        self.sc_navigationItem.rightBarButtonItem = self.actionBarItem;
    }
}

#pragma mark - Layout

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    self.topPanel.frame = (CGRect){0, UIView.sc_navigationBarHeight, kAvatarHeight + 10, kAvatarHeight + 10};
    
}

#pragma mark - Configure

- (void)configureBarItems {
    @weakify(self);
    
    if (self.isSelf) {
        self.leftBarItem = [[QHBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navi_menu_2"] style:SCBarButtonItemStylePlain handler:^(id sender) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kShowMenuNotification object:nil];
        }];
        
        self.settingBarItem = [[QHBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"section_setting"] style:SCBarButtonItemStylePlain handler:^(id sender) {
            @strongify(self);
            
            QHSettingViewController *settingVC = [[QHSettingViewController alloc] init];
            [self.navigationController pushViewController:settingVC animated:YES];
        }];
    } else {
        
    }
}

- (void)configureTableView {
    self.tableView                 = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
    self.tableView.contentInsetTop = 124;
    self.tableView.contentInsetBottom = 15;
    self.tableView.delegate        = self;
    self.tableView.dataSource      = self;
    [self.view addSubview:self.tableView];
}

- (void)configureTopView {
    self.topPanel = [[UIView alloc] init];
    [self.view addSubview:self.topPanel];
    
    self.avatarImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"avatar_default"]];
    self.avatarImageView.contentMode        = UIViewContentModeScaleAspectFill;
    self.avatarImageView.clipsToBounds      = YES;
    self.avatarImageView.layer.cornerRadius = 5; //kAvatarHeight / 2.0;
    [self.topPanel addSubview:self.avatarImageView];
    
    self.nameLabel                          = [[UILabel alloc] init];
    self.nameLabel.textColor                = kFontColorBlackDark;
    self.nameLabel.font                     = [UIFont systemFontOfSize:17];;
    [self.topPanel addSubview:self.nameLabel];
    
    self.signLabel                          = [[UILabel alloc] init];
    self.signLabel.textColor                = kFontColorBlackLight;
    self.signLabel.font                     = [UIFont systemFontOfSize:14];
    self.signLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.signLabel.numberOfLines = 2;
    [self.topPanel addSubview:self.signLabel];
    
    // layout
    self.avatarImageView.frame = (CGRect){10, 10, kAvatarHeight, kAvatarHeight};
    self.nameLabel.frame = (CGRect){80, 20, 200, 20};
    self.signLabel.frame = (CGRect){80, 43, 200, 40};
    
    if (self.member) {
        if (self.isSelf) {
            [self.avatarImageView setImageWithURL:[NSURL URLWithString:self.member.memberAvatarLarge] placeholderImage:[UIImage imageNamed:@"avatar_default"]];
        } else {
            [self.avatarImageView setImageWithURL:[NSURL URLWithString:self.member.memberAvatarNormal] placeholderImage:[UIImage imageNamed:@"avatar_default"]];
        }
        self.nameLabel.text = self.member.memberName;
        self.signLabel.text = self.member.memberTagline;
        [self.signLabel sizeToFit];
        
        self.avatarImageView.alpha = kSetting.imageViewAlphaForCurrentTheme;
        
    }
}

- (void)configureBlocks {
    
    @weakify(self);
    self.getProfileBlock = ^(){
        @strongify(self);
        
        return [[QHDataManager manager] getMemberProfileWithUserId:nil username:self.username success:^(QHMemberModel *member) {
            @strongify(self);
            
            self.didGetProfile = YES;
            self.member = member;
            
            [self endLoadMore];
            
            self.loadMoreBlock = nil;
            
        } failure:^(NSError *error) {
            @strongify(self);
            
            [self endLoadMore];
            
        }];
        
    };
    
    
    self.loadMoreBlock = ^{
        @strongify(self);
        
        self.getProfileBlock();
        
    };
    
}

- (void)configureNotification {
    if (self.isSelf) {
        @weakify(self);
        [[NSNotificationCenter defaultCenter] addObserverForName:kLoginSuccessNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
            @strongify(self);
            
            self.username = [QHDataManager manager].user.member.memberName;
            self.getProfileBlock();
            
        }];
    }
}

#pragma mark - Setters

- (void)setIsSelf:(BOOL)isSelf {
    _isSelf = isSelf;
    
    if (isSelf) {
        //self.member = [V2DataManager manager].user.member;
    }
}

#pragma mark - ScrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [super scrollViewDidScroll:scrollView];
    
    self.topPanel.y = - (self.tableView.contentInsetTop + scrollView.contentOffsetY) + UIView.sc_navigationBarHeight;
    
}


#pragma mark - TableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *profileCellIdentifier = @"profileCellIdentifier";
    QHProfileCell *profileCell = (QHProfileCell *)[tableView dequeueReusableCellWithIdentifier:profileCellIdentifier];
    if (!profileCell) {
        profileCell = [[QHProfileCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:profileCellIdentifier];
    }
    
    if (indexPath.row == 0) {
        profileCell.type = V2ProfileCellTypeTopic;
        profileCell.title = @"主题";
        profileCell.isTop = YES;
        return profileCell;
    }
    if (indexPath.row == 1) {
        profileCell.type = V2ProfileCellTypeReply;
        profileCell.title = @"回复";
        profileCell.isBottom = YES;
        return profileCell;
    }
    return profileCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        
//        V2MemberTopicsViewController *topicsVC = [[V2MemberTopicsViewController alloc] init];
//        topicsVC.model = self.member;
//        [self.navigationController pushViewController:topicsVC animated:YES];
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 36;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headerView = [[UIView alloc] initWithFrame:(CGRect){0, 0, kScreenWidth, 36}];
    headerView.backgroundColor = kBackgroundColorWhiteDark;
    
    UILabel *label = [[UILabel alloc] initWithFrame:(CGRect){10, 0, kScreenWidth - 20, 36}];
    label.textColor = kFontColorBlackLight;
    label.font = [UIFont systemFontOfSize:15.0];
    label.text = self.headerTitleArray[section];
    [headerView addSubview:label];
    
    return headerView;
}

@end
