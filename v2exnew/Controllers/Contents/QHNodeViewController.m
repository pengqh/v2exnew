//
//  QHNodeViewController.m
//  v2exnew
//
//  Created by pengquanhua on 2018/10/17.
//  Copyright © 2018年 pengquanhua. All rights reserved.
//

#import "QHNodeViewController.h"
#import "QHTopicToolBarItemView.h"
#import "QHTopicViewController.h"
#import "QHTopicListCell.h"
#import "QHTopicModel.h"

@interface QHNodeViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) QHBarButtonItem *leftBarItem;
@property (nonatomic, strong) QHBarButtonItem *addBarItem;

@property (nonatomic, strong) UIView          *menuContainView;
@property (nonatomic, strong) UIView          *menuView;
@property (nonatomic, strong) UIButton        *menuBackgroundButton;

@property (nonatomic, strong) QHTopicList     *topicList;
@property (nonatomic, assign) NSInteger       pageCount;

@property (nonatomic, copy) NSURLSessionDataTask* (^getTopicListBlock)(NSInteger page);

@property (nonatomic, assign) BOOL isMenuShowing;
@property (nonatomic, assign) BOOL needsRefresh;

@end

@implementation QHNodeViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.pageCount = 1;
        
        self.isMenuShowing = NO;
        self.needsRefresh = YES;
        
    }
    return self;
}

- (void)loadView {
    [super loadView];
    
    [self configureNavibarItems];
    [self configureTableView];
    [self configureMenuView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.sc_navigationItem.leftBarButtonItem = self.leftBarItem;
    self.sc_navigationItem.rightBarButtonItem = self.addBarItem;
    self.sc_navigationItem.title = self.model.nodeTitle;
    
    [self configureBlocks];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (self.needsRefresh) {
        self.needsRefresh = NO;
        [self beginRefresh];
    }
    
}

#pragma mark - Layout

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    self.menuContainView.frame = self.view.bounds;
    self.menuBackgroundButton.frame = self.menuContainView.bounds;
}


#pragma mark - Configure

- (void)configureNavibarItems {
    
    @weakify(self);
    self.leftBarItem = [[QHBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navi_back"] style:SCBarButtonItemStylePlain handler:^(id sender) {
        @strongify(self);
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }];
    
    self.addBarItem = [[QHBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navi_add"] style:SCBarButtonItemStylePlain handler:^(id sender) {
        @strongify(self);
        
        if (self.isMenuShowing) {
            [self hideMenuAnimated:YES];
        }
        else {
            [self showMenuAnimated:YES];
        }
        
    }];
}

- (void)configureTableView {
    
    self.tableView                 = [[UITableView alloc] initWithFrame:self.view.frame];
    self.tableView.backgroundColor = kBackgroundColorWhiteDark;
    self.tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate        = self;
    self.tableView.dataSource      = self;
    [self.view addSubview:self.tableView];
    
}

- (void)configureMenuView {
    self.menuContainView = [[UIView alloc] init];
    self.menuContainView.userInteractionEnabled = NO;
    [self.view addSubview:self.menuContainView];
    
    self.menuBackgroundButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.menuBackgroundButton.backgroundColor = [UIColor colorWithWhite:0.667 alpha:0];
    
    @weakify(self)
    UIPanGestureRecognizer *menuBGButtonPanGesture = [UIPanGestureRecognizer bk_recognizerWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) {
        @strongify(self)
        [self hideMenuAnimated:NO];
    }];
    [self.menuBackgroundButton addGestureRecognizer:menuBGButtonPanGesture];
    [self.menuContainView addSubview:self.menuBackgroundButton];
    
    self.menuView = [[UIView alloc] init];
    self.menuView.alpha = 0.0;
    self.menuView.frame = (CGRect){200, UIView.sc_navigationBarHeight, 130, 118};
    [self.menuContainView addSubview:self.menuView];
    
    UIView *topArrowView = [[UIView alloc] init];
    topArrowView.frame = (CGRect){87, 5, 10, 10};
    topArrowView.backgroundColor = [UIColor blackColor];
    topArrowView.transform = CGAffineTransformMakeRotation(M_PI_4);
    [self.menuView addSubview:topArrowView];
    
    UIView *menuBackgroundView = [[UIView alloc] init];
    menuBackgroundView.frame = (CGRect){10, 10, 100, 88};
    menuBackgroundView.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.90];
    menuBackgroundView.layer.cornerRadius = 5.0;
    menuBackgroundView.clipsToBounds = YES;
    [self.menuView addSubview:menuBackgroundView];
    
    NSArray *itemTitleArray = @[@"发帖", @"收藏"];
    NSArray *itemImageArray = @[@"icon_post", @"icon_fav"];
    
    void (^buttonHandleBlock)(NSInteger index) = ^(NSInteger index) {
        @strongify(self);
        
        if (index == 0) {
            QHTopicViewController *topicCreateVC = [[QHTopicViewController alloc] init];
            topicCreateVC.create = YES;
            QHTopicModel *topicModel = [[QHTopicModel alloc] init];
            topicModel.topicNode = self.model;
            topicCreateVC.model = topicModel;
            [self.navigationController pushViewController:topicCreateVC animated:YES];
        }
        
        if (index == 1) {
            
        }
        
        [self hideMenuAnimated:NO];
    };
    
    for (NSInteger i = 0; i<itemTitleArray.count; i++) {
        QHTopicToolBarItemView *item = [[QHTopicToolBarItemView alloc] init];
        item.itemTitle = itemTitleArray[i];
        item.itemImage = [UIImage imageNamed:itemImageArray[i]];
        item.alpha = 1.0;
        item.buttonPressedBlock = ^{
            buttonHandleBlock(i);
        };
        item.frame = (CGRect){0, 44 * i, item.width, item.height};
        item.backgroundColorNormal = [UIColor clearColor];
        [menuBackgroundView addSubview:item];
    }
    
    // Handles
    [self.menuBackgroundButton bk_addEventHandler:^(id sender) {
        @strongify(self);
        
        [self hideMenuAnimated:YES];
        
    } forControlEvents:UIControlEventTouchUpInside];
}

- (void)configureBlocks {
    
    @weakify(self);
    self.getTopicListBlock = ^NSURLSessionDataTask *(NSInteger page) {
        @strongify(self);
        
        self.pageCount = page;
        return [[QHDataManager manager] getTopicListWithNodeId:nil nodename:self.model.nodeName username:nil page:self.pageCount success:^(QHTopicList *list) {
            @strongify(self);
            
            self.topicList = list;
            
            if (self.pageCount > 1) {
                [self endLoadMore];
            } else {
                [self endRefresh];
            }
            
        } failure:^(NSError *error) {
            @strongify(self);
            
            if (self.pageCount > 1) {
                [self endLoadMore];
            } else {
                [self endRefresh];
            }
            
        }];
    };
    
    self.refreshBlock = ^{
        @strongify(self);
        
        self.getTopicListBlock(1);
    };
}

#pragma mark - TableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.topicList.list.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self heightOfTopicCellForIndexPath:indexPath];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"CellIdentifier";
    QHTopicListCell *cell = (QHTopicListCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[QHTopicListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    return [self configureTopicCellWithCell:cell IndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    QHTopicModel *model = self.topicList.list[indexPath.row];
    QHTopicViewController *topicViewController = [[QHTopicViewController alloc] init];
    topicViewController.model = model;
    [self.navigationController pushViewController:topicViewController animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Configure TableCell

- (CGFloat)heightOfTopicCellForIndexPath:(NSIndexPath *)indexPath {
    
    QHTopicModel *model = self.topicList.list[indexPath.row];
    
    return [QHTopicListCell getCellHeightWithTopicModel:model];
    
}

- (QHTopicListCell *)configureTopicCellWithCell:(QHTopicListCell *)cell IndexPath:(NSIndexPath *)indexPath {
    
    QHTopicModel *model = self.topicList.list[indexPath.row];
    
    cell.model = model;
    cell.isTop = !indexPath.row;
    
    return cell;
}

#pragma mark - Data

- (void)setTopicList:(QHTopicList *)topicList {
    
    if (self.topicList.list.count > 0 && self.pageCount != 1) {
        
        NSMutableArray *list = [[NSMutableArray alloc] initWithArray:self.topicList.list];
        [list addObjectsFromArray:topicList.list];
        topicList.list = list;
        
    }
    
    _topicList = topicList;
    
    [self.tableView reloadData];
    
}

#pragma mark - Private Methods

- (void)showMenuAnimated:(BOOL)animated {
    if (self.isMenuShowing) {
        return;
    }
    
    self.isMenuShowing = YES;
    
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    CGRect addBarF = [self.menuContainView convertRect:self.addBarItem.view.frame fromView:window];
    self.menuView.frame = (CGRect){CGRectGetMidX(addBarF) - 72, CGRectGetMaxY(addBarF), 130, 118};
    
    if (animated) {
        self.menuView.origin = (CGPoint){CGRectGetMidX(addBarF) - 72, CGRectGetMaxY(addBarF) - 44};
        //        self.menuView.origin = (CGPoint){220, 20};
        self.menuView.transform = CGAffineTransformMakeScale(0.3, 0.3);
        
        [UIView animateWithDuration:0.3 animations:^{
            self.menuView.alpha = 1.0;
            self.menuView.transform = CGAffineTransformIdentity;
            self.menuView.frame = (CGRect){CGRectGetMidX(addBarF) - 92, CGRectGetMaxY(addBarF), 130, 118};
            //            self.menuView.frame = (CGRect){200, 64, 130, 118};
        } completion:^(BOOL finished) {
            self.menuContainView.userInteractionEnabled = YES;
        }];
    } else {
        self.menuView.alpha = 1.0;
        self.menuView.transform = CGAffineTransformIdentity;
        self.menuView.frame = (CGRect){CGRectGetMidX(addBarF) - 72, CGRectGetMaxY(addBarF), 130, 118};
        //        self.menuView.frame = (CGRect){200, 64, 130, 118};
        self.menuContainView.userInteractionEnabled = YES;
    }
}

- (void)hideMenuAnimated:(BOOL)animated {
    
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    CGRect addBarF = [self.menuContainView convertRect:self.addBarItem.view.frame fromView:window];
    
    if (animated) {
        [UIView animateWithDuration:0.2 animations:^{
            self.menuView.alpha = 0.0;
        } completion:^(BOOL finished) {
            self.menuContainView.userInteractionEnabled = NO;
        }];
        
        [UIView animateWithDuration:0.3 animations:^{
            
            self.menuView.transform = CGAffineTransformMakeScale(0.3, 0.3);
            self.menuView.origin = (CGPoint){CGRectGetMidX(addBarF) - 72 + 40, CGRectGetMaxY(addBarF)};
            //            self.menuView.origin = (CGPoint){260, 64};
            
        } completion:^(BOOL finished) {
            self.menuView.transform = CGAffineTransformIdentity;
            self.menuView.frame = (CGRect){CGRectGetMidX(addBarF) - 72, CGRectGetMaxY(addBarF), 130, 118};
            //            self.menuView.frame = (CGRect){200, 64, 130, 118};
            self.isMenuShowing = NO;
        }];
    } else {
        [UIView animateWithDuration:0.1 animations:^{
            self.menuView.alpha = 0.0;
        } completion:^(BOOL finished) {
            self.menuContainView.userInteractionEnabled = NO;
            self.isMenuShowing = NO;
        }];
    }
    
}

@end
