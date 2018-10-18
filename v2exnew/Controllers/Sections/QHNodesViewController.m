//
//  QHNodesViewController.m
//  v2exnew
//
//  Created by pengquanhua on 2018/10/18.
//  Copyright © 2018年 pengquanhua. All rights reserved.
//

#import "QHNodesViewController.h"
#import "QHNodesViewCell.h"

@interface QHNodesViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) QHBarButtonItem    *leftBarItem;

@property (nonatomic, strong) NSArray *headerTitleArray;
@property (nonatomic, strong) NSArray *nodesArray;

@property (nonatomic, strong) NSArray *myNodesArray;
@property (nonatomic, strong) NSArray *otherNodesArray;

@property (nonatomic, copy) NSURLSessionDataTask* (^getNodeListBlock)(void);
@property (nonatomic, copy) NSString *myNodeListPath;

@end

@implementation QHNodesViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.headerTitleArray = @[@"我的节点",@"分享与探索", @"V2EX", @"iOS", @"Geek", @"游戏", @"Apple", @"生活", @"Internet", @"城市", @"品牌"];
        
        self.myNodeListPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        self.myNodeListPath = [self.myNodeListPath stringByAppendingString:@"/nodes.plist"];
        
        self.myNodesArray = [NSArray arrayWithContentsOfFile:self.myNodeListPath];
        if (!self.myNodesArray) {
            self.myNodesArray = [NSArray array];
        }
        
        self.otherNodesArray = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"NodesList" ofType:@"plist"]];
        
        [self loadData];
        
    }
    return self;
}

- (void)loadView {
    [super loadView];
    
    [self configureBarItems];
    [self configureTableView];
    [self configureBlocks];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.sc_navigationItem.title = @"节点";
    self.sc_navigationItem.leftBarButtonItem = self.leftBarItem;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (self.myNodesArray.count == 0) {
        [self beginRefresh];
    }
}

#pragma mark - Configure

- (void)configureBarItems {
    
    self.leftBarItem = [[QHBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navi_menu_2"] style:SCBarButtonItemStylePlain handler:^(id sender) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kShowMenuNotification object:nil];
    }];
    
    
}

- (void)configureTableView {
    
    self.tableView                 = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
    self.tableView.contentInsetBottom = 15;
    self.tableView.contentInsetTop = 44;
    self.tableView.delegate        = self;
    self.tableView.dataSource      = self;
    [self.view addSubview:self.tableView];
    
}

- (void)configureBlocks {
    
    @weakify(self);
    self.getNodeListBlock = ^NSURLSessionDataTask *{
        
        return [[QHDataManager manager] getMemberNodeListSuccess:^(NSArray *list) {
            @strongify(self);
            
            if ([list writeToFile:self.myNodeListPath atomically:YES]) {
                
            }
            self.myNodesArray = list;
            [self loadData];
            [self endRefresh];
            
        } failure:^(NSError *error) {
            @strongify(self);
            [self endRefresh];
        }];
    };
    
    self.refreshBlock = ^{
        @strongify(self);
        
        self.getNodeListBlock();
    };
}

#pragma mark - TableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.headerTitleArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [QHNodesViewCell getCellHeightWithNodesArray:self.nodesArray[indexPath.section]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *nodeCellIdentifier = @"nodeCellIdentifier";
    QHNodesViewCell *nodeCell = (QHNodesViewCell *)[tableView dequeueReusableCellWithIdentifier:nodeCellIdentifier];
    if (!nodeCell) {
        nodeCell = [[QHNodesViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nodeCellIdentifier];
    }
    
    nodeCell.navi = self.navigationController;
    nodeCell.nodesArray = self.nodesArray[indexPath.section];
    
    return nodeCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
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
    
    UILabel *label                       = [[UILabel alloc] initWithFrame:(CGRect){10, 0, kScreenWidth - 20, 36}];
    label.textColor                      = kFontColorBlackLight;
    label.font                           = [UIFont systemFontOfSize:15.0];
    label.text                           = self.headerTitleArray[section];
    [headerView addSubview:label];
    
    if (section == 0) {
        UIView *topBorderLineView            = [[UIView alloc] initWithFrame:(CGRect){0, 0, kScreenWidth, 0.5}];
        topBorderLineView.backgroundColor    = kLineColorBlackDark;
        [headerView addSubview:topBorderLineView];
    }
    
    UIView *bottomBorderLineView         = [[UIView alloc] initWithFrame:(CGRect){0, 35.5, kScreenWidth, 0.5}];
    bottomBorderLineView.backgroundColor = kLineColorBlackDark;
    [headerView addSubview:bottomBorderLineView];
    
    
    return headerView;
}

#pragma mark - Data

- (void)loadData {
    NSMutableArray *nodesArray = [NSMutableArray arrayWithObject:self.myNodesArray];;
    [nodesArray addObjectsFromArray:self.otherNodesArray];
    
    self.nodesArray = [self itemsWithDictArray:nodesArray];
    [self.tableView reloadData];
}

- (NSArray *)itemsWithDictArray:(NSArray *)nodesArray {
    NSMutableArray *items = [NSMutableArray new];
    
    for (NSArray *sectionDicList in nodesArray) {
        NSMutableArray *sectionItems = [NSMutableArray new];
        for (NSDictionary *dataDict in sectionDicList) {
            NSString *nodeTitle = dataDict[@"name"];
            NSString *nodeName = dataDict[@"title"];
            
            QHNodeModel *model = [[QHNodeModel alloc] init];
            model.nodeTitle = nodeTitle;
            model.nodeName = nodeName;
            
            [sectionItems addObject:model];
        }
        [items addObject:sectionItems];
    }
    
    return items;
}

@end
