//
//  QHTopicViewController.m
//  v2exnew
//
//  Created by pengquanhua on 2018/9/16.
//  Copyright © 2018年 pengquanhua. All rights reserved.
//

#import "QHTopicViewController.h"

@interface QHTopicViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UILabel *nodeNameLabel;

@property (nonatomic, strong) QHBarButtonItem    *leftBarItem;
@property (nonatomic, strong) QHBarButtonItem    *addBarItem;
@property (nonatomic, strong) QHBarButtonItem    *doneBarItem;
@property (nonatomic, strong) QHBarButtonItem    *activityBarItem;

//@property (nonatomic, strong)

@end

@implementation QHTopicViewController

- (void)loadView {
    [super loadView];
    
    [self configureBarItems];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.sc_navigationItem.leftBarButtonItem = self.leftBarItem;
    self.sc_navigationItem.title = @"topic";
}

#pragma mark - configure

- (void)configureBarItems {
    
    @weakify(self);
    self.leftBarItem = [[QHBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navi_back"] style:SCBarButtonItemStylePlain handler:^(id sender) {
        @strongify(self);
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    self.addBarItem = [[QHBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navi_more"] style:SCBarButtonItemStylePlain handler:^(id sender) {
        
    }];
}

- (void)configureTableView {
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}

- (void)configureHeaderView {
    self.headerView = [[UIView alloc] initWithFrame:(CGRect){0, 0, kScreenWidth, 36}];
    
    UIView *headerContainView = [[UIView alloc] initWithFrame:(CGRect){0, self.headerView.height - 36, kScreenWidth, 36}];
    headerContainView.backgroundColor = kBackgroundColorWhiteDark;
    [self.headerView addSubview:headerContainView];
    
    UIButton *headerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    headerButton.frame = (CGRect){0, 0, headerContainView.width, headerContainView.height};
    [self.headerView addSubview:headerButton];
    
    self.nodeNameLabel = [[UILabel alloc] initWithFrame:(CGRect){10, 0, 200, 36}];
    self.nodeNameLabel.textColor = kFontColorBlackLight;
    self.nodeNameLabel.font = [UIFont systemFontOfSize:15];
    self.nodeNameLabel.userInteractionEnabled = NO;
    [headerContainView addSubview:self.nodeNameLabel];
    
    UIImageView *rightArrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Arrow"]];
    rightArrowImageView.userInteractionEnabled = NO;
    rightArrowImageView.frame = (CGRect){0, 13, 5, 10};
    rightArrowImageView.x = headerContainView.width - rightArrowImageView.width - 10;
    [headerContainView addSubview:rightArrowImageView];
    
    self.tableView.tableHeaderView = self.headerView;
    
    // Handles
    @weakify(self);
    [headerButton bk_addEventHandler:^(id sender) {
        @strongify(self);
        NSLog(@"click headerButton");
    } forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - TableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 3;
    } else {
        //return self.replyList.list.count;
        return 0;
    }
}
    
@end
