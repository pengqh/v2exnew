//
//  QHCategoriesViewController.m
//  v2exnew
//
//  Created by pengquanhua on 2018/9/16.
//  Copyright © 2018年 pengquanhua. All rights reserved.
//

#import "QHCategoriesViewController.h"
#import "QHTopicViewController.h"
#import "QHSubMenuSectionView.h"
#import "QHTopicListCell.h"

#define keyFromCategoriesType(type) [NSString stringWithFormat:@"categoriesKey%zd", type]
#define keyFromFavoriteType(type) [NSString stringWithFormat:@"categoriesKey%zd", type]

@interface QHCategoriesViewController () <UITableViewDataSource, UITableViewDelegate, UIViewControllerPreviewingDelegate>

@property (nonatomic, strong) QHSubMenuSectionView             *sectionView;
@property (nonatomic, strong) UIScreenEdgePanGestureRecognizer *edgePanRecognizer;
@property (nonatomic, strong) UIImageView                      *leftShadowImageView;
@property (nonatomic, strong) UIView                           *leftShdowImageMaskView;

@property (nonatomic, strong) UIButton                         *aboveTableViewButton;

@property (nonatomic, strong) QHBarButtonItem *leftBarItem;
@property (nonatomic, strong) QHBarButtonItem *rightBarItemExpend;

@property (nonatomic, strong) QHTopicList *topicList;
@property (nonatomic, strong) NSMutableDictionary              *topicListDict;

@property (nonatomic, assign) V2HotNodesType categoriesType;
@property (nonatomic, assign) V2HotNodesType favoriteType;

@property (nonatomic, copy) NSURLSessionDataTask* (^getTopicListBlock)(V2HotNodesType type, BOOL isLoadMore);
@property (nonatomic, strong) NSURLSessionDataTask * currentTask;
@property (nonatomic, assign) NSInteger currentPage;

@property (nonatomic, assign) BOOL needsRefresh;

@end

@implementation QHCategoriesViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.topicListDict = [[NSMutableDictionary alloc] init];
        self.needsRefresh = YES;
        
        self.favorite = NO;
        self.currentPage = 1;
    }
    return self;
}

- (void)loadView {
    [super loadView];
    
    [self configureSectionView];
    [self configureTableView];
    [self configureShadowViews];
    [self configureNavibarItems];
    [self configureGesture];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureBlocks];
    
    self.sc_navigationItem.leftBarButtonItem = self.leftBarItem;
    self.sc_navigationItem.rightBarButtonItem = self.rightBarItemExpend;
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (self.needsRefresh) {
        self.needsRefresh = NO;
        
        if (self.isFavorite) {
            self.sc_navigationItem.title = self.sectionView.sectionTitleArray[[QHSettingManager manager].favoriteSelectedSectionIndex];
        } else {
            self.sc_navigationItem.title = self.sectionView.sectionTitleArray[[QHSettingManager manager].categoriesSelectedSectionIndex];
        }
        
        [self beginRefresh];
    }
}

#pragma mark - Layouts

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    self.hiddenEnabled = YES;
    
    self.leftShdowImageMaskView.frame = (CGRect){self.tableView.width, 0, 10, kScreenHeight};
    self.leftShadowImageView.frame    = (CGRect){-10, 0, 10, kScreenHeight};
    self.aboveTableViewButton.frame   = self.tableView.frame;
    
}

#pragma mark - Configure

- (void)configureNavibarItems {
    self.leftBarItem = [[QHBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navi_menu_2"] style:SCBarButtonItemStylePlain handler:^(id sender) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kShowMenuNotification object:nil];
    }];
    
    self.rightBarItemExpend = [[QHBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navi_dot"] style:SCBarButtonItemStylePlain handler:^(id sender) {
        if (self.aboveTableViewButton.hidden) {
            
            [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                [self setMenuOffset: - self.sectionView.width];
                self.aboveTableViewButton.hidden = NO;
            } completion:^(BOOL finished) {
                ;
            }];
        }
        else {
            [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                [self setMenuOffset:0];
                self.aboveTableViewButton.hidden = YES;
            } completion:^(BOOL finished) {
                ;
            }];
        }
    }];
}

- (void)configureSectionView {
    self.sectionView = [[QHSubMenuSectionView alloc] initWithFrame:(CGRect){kScreenWidth - 20, 0, 120, self.view.height}];
    if (self.isFavorite) {
        self.sectionView.favorite = YES;
        self.sectionView.sectionTitleArray = @[@"节点收藏", @"特别关注", @"主题收藏"];
    } else {
        self.sectionView.favorite = NO;
        self.sectionView.sectionTitleArray = @[@"技术", @"创意", @"好玩", @"Apple", @"酷工作", @"交易", @"城市", @"问与答", @"最热", @"全部", @"R2"];
    }
    
    [self.view addSubview:self.sectionView];
    
    @weakify(self);
    [self.sectionView setDidSelectedIndexBlock:^(NSInteger index) {
        @strongify(self);
        
        if (self.isFavorite) {
            [QHSettingManager manager].favoriteSelectedSectionIndex = index;
        } else {
            [QHSettingManager manager].categoriesSelectedSectionIndex = index;
        }
        
        self.sc_navigationItem.title = self.sectionView.sectionTitleArray[index];
        
        [UIView animateWithDuration:0.3 animations:^{
            [self setMenuOffset:0.0];
        } completion:^(BOOL finished) {
            self.aboveTableViewButton.hidden = YES;
            QHTopicList *storedList;
            if (self.isFavorite) {
                storedList = [self.topicListDict objectForSafeKey:keyFromFavoriteType(self.favoriteType)];
            } else {
                storedList = [self.topicListDict objectForSafeKey:keyFromCategoriesType(self.categoriesType)];
            }
            
            if (storedList) {
                self.topicList = storedList;
            } else {
                self.topicList = nil;
                [self sc_setNavigationBarHidden:NO animated:YES];
            }
            [self beginRefresh];
            [self.tableView scrollRectToVisible:(CGRect){0,0,1,1} animated:YES];
        }];
    }];
}

- (void)configureTableView {
    
    self.tableView                 = [[UITableView alloc] initWithFrame:self.view.frame];
    self.tableView.backgroundColor = kBackgroundColorWhiteDark;
    self.tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
    self.tableView.contentInsetTop = UIView.sc_navigationBarHeight;  // Notice
    self.tableView.delegate        = self;
    self.tableView.dataSource      = self;
    self.tableView.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:self.tableView];
    
    self.aboveTableViewButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.aboveTableViewButton.hidden = YES;
    [self.view addSubview:self.aboveTableViewButton];
    
    // Handles
    [self.aboveTableViewButton bk_addEventHandler:^(id sender) {
        
        [UIView animateWithDuration:0.3 animations:^{
            [self setMenuOffset:0];
        } completion:^(BOOL finished) {
            UIButton *button = (UIButton *)sender;
            button.hidden = YES;
        }];
        
    } forControlEvents:UIControlEventTouchUpInside];
    
    /**
     *  Notice
     *
     *  if tableView is not the bottom of vc.view, contenTnsetTop will be differ.
     */
    
}

- (void)configureShadowViews {
    
    self.leftShdowImageMaskView               = [[UIView alloc] init];
    self.leftShdowImageMaskView.clipsToBounds = YES;
    [self.view addSubview:self.leftShdowImageMaskView];
    
    UIImage *shadowImage               = [UIImage imageNamed:@"Navi_Shadow"];
    self.leftShadowImageView           = [[UIImageView alloc] initWithImage:shadowImage];
    self.leftShadowImageView.transform = CGAffineTransformMakeRotation(M_PI);
    self.leftShadowImageView.alpha     = 0.0;
    [self.leftShdowImageMaskView addSubview:self.leftShadowImageView];
    
}

- (void)configureGesture {
    self.edgePanRecognizer = [[UIScreenEdgePanGestureRecognizer alloc]  bk_initWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) {
        
        UIScreenEdgePanGestureRecognizer *recognizer = (UIScreenEdgePanGestureRecognizer*)sender;
        
        CGFloat progress = -[recognizer translationInView:self.view].x / (self.view.bounds.size.width * 0.5);
        NSLog(@"x=%f", [recognizer translationInView:self.view].x);
        progress = MIN(1.0, MAX(0.0, progress));
        
        if (recognizer.state == UIGestureRecognizerStateBegan) {
            
        } else if (recognizer.state == UIGestureRecognizerStateChanged) {
            if (self.aboveTableViewButton.hidden) {
                [self setMenuOffset: - self.sectionView.width * progress];
            }
        } else if (recognizer.state == UIGestureRecognizerStateEnded || recognizer.state == UIGestureRecognizerStateCancelled) {
            
            CGFloat velocity = [recognizer velocityInView:self.view].x;
            
            if (velocity < -10 || progress > 0.5) {
                [UIView animateWithDuration:0.3 animations:^{
                    [self setMenuOffset: - self.sectionView.width];
                    self.aboveTableViewButton.hidden = NO;
                } completion:^(BOOL finished) {
                    
                }];
            } else {
                [UIView animateWithDuration:0.3 animations:^{
                    [self setMenuOffset:0];
                    self.aboveTableViewButton.hidden = YES;
                }];
            }
        }
    }];
    self.edgePanRecognizer.edges = UIRectEdgeRight;
    [self.view addGestureRecognizer:self.edgePanRecognizer];
    
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] bk_initWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) {
        
        UIPanGestureRecognizer *recognizer = (UIPanGestureRecognizer*)sender;
        if (self.aboveTableViewButton.hidden) {
            return ;
        }
        
        CGFloat progress = [recognizer translationInView:self.view].x / (self.view.bounds.size.width * 0.5);
        progress = MIN(1.0, MAX(0.0, progress));
        
        if (recognizer.state == UIGestureRecognizerStateBegan) {
            
        }
        else if (recognizer.state == UIGestureRecognizerStateChanged) {
            
            [self setMenuOffset: - self.sectionView.width * (1 - progress)];
            
        }
        else if (recognizer.state == UIGestureRecognizerStateEnded || recognizer.state == UIGestureRecognizerStateCancelled) {
            CGFloat velocity = [recognizer velocityInView:self.view].x;
            
            if (velocity < -10 || progress > 0.5) {
                
                [UIView animateWithDuration:0.3 animations:^{
                    [self setMenuOffset:0];
                    self.aboveTableViewButton.hidden = YES;
                } completion:^(BOOL finished) {
                    ;
                }];
            }
            else {
                [UIView animateWithDuration:0.3 animations:^{
                    [self setMenuOffset: - self.sectionView.width];
                    self.aboveTableViewButton.hidden = NO;
                } completion:^(BOOL finished) {
                    ;
                }];
            }

            
        }
    }];
    [self.aboveTableViewButton addGestureRecognizer:panRecognizer];
}

- (void)configureBlocks {
    
    @weakify(self);
    self.getTopicListBlock = ^(V2HotNodesType type, BOOL isLoadMore) {
        @strongify(self);
        
        if (self.currentTask) {
            [self.currentTask cancel];
        }
        
        if (self.isFavorite && self.favoriteType != V2HotNodesTypeNodes) {
            type = self.favoriteType;
            NSInteger page = 1;
            
            if (isLoadMore) {
                page = self.currentPage + 1;
            }
            
            self.currentTask = [[QHDataManager manager] getMemberTopicListWithType:type page:page Success:^(QHTopicList *list) {
                @strongify(self);
                
                if (isLoadMore) {
                    self.currentPage = page;
                    NSMutableArray *newList = [NSMutableArray arrayWithArray:self.topicList.list];
                    [newList addObjectsFromArray:list.list];
                    list.list = newList;
                } else {
                    self.currentPage = 1;
                }
                
                self.topicList = list;
                [self.topicListDict setObject:list forKey:keyFromFavoriteType(type)];
                
                if (isLoadMore) {
                    [self endLoadMore];
                } else {
                    [self endRefresh];
                }
                
            } failure:^(NSError *error) {
                @strongify(self);
                
                if (isLoadMore) {
                    [self endLoadMore];
                } else {
                    [self endRefresh];
                }
                
            }];
        } else {
            
            if (self.isFavorite) {
                type = V2HotNodesTypeNodes;
            } else {
                type = self.categoriesType;
            }
            
            self.currentTask = [[QHDataManager manager] getTopicListWithType:type Success:^(QHTopicList *list) {
                
                self.topicList = list;
                [self.topicListDict setObject:list forKey:keyFromCategoriesType(type)];
                if (isLoadMore) {
                    [self endLoadMore];
                } else {
                    [self endRefresh];
                }
                
            } failure:^(NSError *error) {
                @strongify(self);
                if (isLoadMore) {
                    [self endLoadMore];
                } else {
                    [self endRefresh];
                }
            }];
        }
        
        return self.currentTask;
    };
    
    self.refreshBlock = ^{
        @strongify(self);
        
        if (self.isFavorite) {
            self.getTopicListBlock(self.favoriteType, NO);
        } else {
            self.getTopicListBlock(self.categoriesType, NO);
        }
    };
    
    if (self.isFavorite) {
        self.loadMoreBlock = ^{
            @strongify(self);
            self.getTopicListBlock(self.favoriteType, YES);
        };
    }
    
}

#pragma mark - Data

- (void)setTopicList:(QHTopicList *)topicList {
    _topicList = topicList;
    [self.tableView reloadData];
}

#pragma mark - TableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.topicList.list.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = [self heightOfTopicCellForIndexPath:indexPath];
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"CellIdentifier";
    QHTopicListCell *cell = (QHTopicListCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[QHTopicListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];

        // register for 3D Touch (if available)
        if(NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_8_4) {
            if (self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable) {
                [self registerForPreviewingWithDelegate:self sourceView:cell];
            }
        }
    }
    cell.backgroundColor = [UIColor greenColor];
    return [self configureTopicCellWithCell:cell IndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    QHTopicModel *model = self.topicList.list[indexPath.row];
    QHTopicViewController *topicViewController = [[QHTopicViewController alloc] init];
    topicViewController.model = model;
    [self.navigationController pushViewController:topicViewController animated:YES];
    
}

#pragma mark - Configure TableCell

- (CGFloat)heightOfTopicCellForIndexPath:(NSIndexPath *)indexPath {
    QHTopicModel *model = self.topicList.list[indexPath.row];
    return [QHTopicListCell getCellHeightWithTopicModel:model];;
}

- (QHTopicListCell *)configureTopicCellWithCell:(QHTopicListCell *)cell IndexPath:(NSIndexPath *)indexPath {
    
    QHTopicModel *model = self.topicList.list[indexPath.row];
    
    cell.model = model;
    cell.isTop = !indexPath.row;
    
    return cell;
}

#pragma mark - Private Methods

- (void)setMenuOffset:(CGFloat)offset {
    
    self.tableView.x               = offset;
    self.aboveTableViewButton.x    = offset;
    self.leftShdowImageMaskView.x  = kScreenWidth + offset;
    self.leftShadowImageView.x     = (MIN((-offset / 110), 1.0)) * 10 - 10;
    self.leftShadowImageView.alpha = MIN((-offset / 200), 0.3);
    self.sectionView.x             = kScreenWidth - 20 + (offset / self.sectionView.width) * (self.sectionView.width - 20);
    
}

- (V2HotNodesType)categoriesType {
    
    V2HotNodesType type = V2HotNodesTypeHot;
    
    switch ([QHSettingManager manager].categoriesSelectedSectionIndex) {
        case 0:
            type = V2HotNodesTypeTech;
            break;
        case 1:
            type = V2HotNodesTypeCreative;
            break;
        case 2:
            type = V2HotNodesTypePlay;
            break;
        case 3:
            type = V2HotNodesTypeApple;
            break;
        case 4:
            type = V2HotNodesTypeJobs;
            break;
        case 5:
            type = V2HotNodesTypeDeals;
            break;
        case 6:
            type = V2HotNodesTypeCity;
            break;
        case 7:
            type = V2HotNodesTypeQna;
            break;
        case 8:
            type = V2HotNodesTypeHot;
            break;
        case 9:
            type = V2HotNodesTypeAll;
            break;
        case 10:
            type = V2HotNodesTypeR2;
            break;
        default:
            type = V2HotNodesTypeAll;
            break;
    }
    
    return type;
}

- (V2HotNodesType)favoriteType {
    V2HotNodesType type = V2HotNodesTypeAll;
    
    switch ([QHSettingManager manager].favoriteSelectedSectionIndex) {
        case 0:
            type = V2HotNodesTypeNodes;
            break;
        case 1:
            type = V2HotNodesTypeMembers;
            break;
        case 2:
            type = V2HotNodesTypeFav;
            break;
        default:
            break;
    }
    
    return type;
}


@end
