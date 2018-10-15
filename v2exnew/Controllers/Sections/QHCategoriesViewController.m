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

@interface QHCategoriesViewController () <UITableViewDataSource, UITableViewDelegate, UIViewControllerPreviewingDelegate>

@property (nonatomic, strong) QHSubMenuSectionView             *sectionView;
@property (nonatomic, strong) UIScreenEdgePanGestureRecognizer *edgePanRecognizer;
@property (nonatomic, strong) UIImageView                      *leftShadowImageView;
@property (nonatomic, strong) UIView                           *leftShdowImageMaskView;

@property (nonatomic, strong) UIButton                         *aboveTableViewButton;

@property (nonatomic, strong) QHBarButtonItem *leftBarItem;
@property (nonatomic, strong) QHBarButtonItem *rightBarItemExpend;

@property (nonatomic, strong) QHTopicList *topicList;

@end

@implementation QHCategoriesViewController

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
    
    self.sc_navigationItem.leftBarButtonItem = self.leftBarItem;
    self.sc_navigationItem.rightBarButtonItem = self.rightBarItemExpend;
    self.sc_navigationItem.title = @"好玩";
    [self.tableView scrollRectToVisible:(CGRect){0, 0, 1, 1} animated:YES];
    [[QHDataManager manager] getTopicListWithType:V2HotNodesTypeTech Success:^(QHTopicList *list) {
        self.topicList = list;
    } failure:^(NSError *error) {
        
    }];
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
    //topicViewController.model = model;
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


@end
