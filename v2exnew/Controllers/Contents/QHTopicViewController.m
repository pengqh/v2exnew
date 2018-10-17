//
//  QHTopicViewController.m
//  v2exnew
//
//  Created by pengquanhua on 2018/9/16.
//  Copyright © 2018年 pengquanhua. All rights reserved.
//

#import "QHTopicViewController.h"
#import "QHTopicTitleCell.h"
#import "QHTopicInfoCell.h"
#import "QHTopicBodyCell.h"
#import "QHTopicReplyCell.h"
#import "SCActionSheet.h"

@interface QHTopicViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UILabel *nodeNameLabel;

@property (nonatomic, strong) QHBarButtonItem    *leftBarItem;
@property (nonatomic, strong) QHBarButtonItem    *addBarItem;
@property (nonatomic, strong) QHBarButtonItem    *doneBarItem;
@property (nonatomic, strong) QHBarButtonItem    *activityBarItem;

@property (nonatomic, strong) QHNodeModel *nodeModel;
@property (nonatomic, strong) QHReplyList *replyList;
@property (nonatomic, strong) QHReplyModel *selectedReplyModel;

@property (nonatomic, strong) SCActionSheet      *actionSheet;

@property (nonatomic, copy) NSURLSessionDataTask* (^getTopicBlock)();
@property (nonatomic, copy) NSURLSessionDataTask* (^getReplyListBlock)(NSInteger page);
@property (nonatomic, copy) NSURLSessionDataTask* (^replyCreateBlock)(NSString *content);

@property (nonatomic, assign) BOOL isDragging;

@end

@implementation QHTopicViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.create = NO;
        self.isDragging = NO;
    }
    return self;
}

- (void)loadView {
    [super loadView];
    
    [self configureBarItems];
    [self configureTableView];
    [self configureHeaderView];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.sc_navigationItem.leftBarButtonItem = self.leftBarItem;
    self.sc_navigationItem.rightBarButtonItem = self.addBarItem;
    
    [self configureBlocks];
    
    if (!self.model.topicContent && !self.isCreate) {
        self.getTopicBlock();
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (!self.replyList && !self.isCreate) {
        @weakify(self);
        [self bk_performBlock:^(id obj) {
            @strongify(self);
            
            [self beginLoadMore];
        } afterDelay:0.5];
    }
}

#pragma mark - configure

- (void)configureBarItems {
    
    @weakify(self);
    self.leftBarItem = [[QHBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navi_back"] style:SCBarButtonItemStylePlain handler:^(id sender) {
        @strongify(self);
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    self.addBarItem = [[QHBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navi_more"] style:SCBarButtonItemStylePlain handler:^(id sender) {
        
        self.actionSheet = [[SCActionSheet alloc] sc_initWithTitles:@[@"分享", @""] customViews:@[[UILabel new], [UILabel new]] buttonTitles:nil];
        
        [self.actionSheet sc_show:YES];
        
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

- (void)configureBlocks {
    
    @weakify(self);
    
    self.getTopicBlock = ^{
        @strongify(self);
        
        return [[QHDataManager manager] getTopicWithTopicId:self.model.topicId success:^(QHTopicModel *model) {
            @strongify(self);
            self.model = model;
        } failure:^(NSError *error) {
            
        }];
    };
    
    self.getReplyListBlock = ^(NSInteger page) {
        @strongify(self);
        
        return [[QHDataManager manager] getReplyListWithTopicId:self.model.topicId success:^(QHReplyList *list) {
            @strongify(self);
            
            self.replyList = list;
            [self endLoadMore];
            
        } failure:^(NSError *error) {
            [self endLoadMore];
        }];
    };
    
    self.loadMoreBlock = ^{
        @strongify(self);
        
        self.getReplyListBlock(1);
    };
}

#pragma mark - Data Methods

- (void)setModel:(QHTopicModel *)model {
    _model = model;
    self.sc_navigationItem.title = model.topicTitle;
    if (model.topicTitle) {
        
    }
    
    self.nodeModel = model.topicNode;
    
    [self.tableView beginUpdates];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView endUpdates];
}

- (void)setNodeModel:(QHNodeModel *)nodeModel {
    _nodeModel = nodeModel;
    
    self.nodeNameLabel.text = self.nodeModel.nodeTitle;
}

- (void)setReplyList:(QHReplyList *)replyList {
    
    BOOL isFirstSet = (_replyList == nil);
    _replyList = replyList;
    
    if (isFirstSet) {
        [self.tableView beginUpdates];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView endUpdates];
    } else {
        [self.tableView reloadData];
    }
}

#pragma mark - ScrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [super scrollViewDidScroll:scrollView];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [super scrollViewWillBeginDragging:scrollView];
    
    self.isDragging = YES;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [super scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    
    if (scrollView.contentOffsetY < - UIView.sc_navigationBarHeight + 36) {
        self.isDragging = YES;
        [UIView animateWithDuration:0.3 animations:^{
            self.tableView.contentInsetTop = UIView.sc_navigationBarHeight;
        } completion:^(BOOL finished) {
            if (!decelerate) {
                [UIView animateWithDuration:0.3 animations:^{
                    self.tableView.contentInsetTop = UIView.sc_navigationBarHeight - 36;
                }];
            }
        }];
    } else {
        self.isDragging = NO;
        self.tableView.contentInsetTop = UIView.sc_navigationBarHeight - 36;
    }
}

#pragma mark - TableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 3;
    } else {
        return self.replyList.list.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
                return [QHTopicTitleCell getCellHeightWithTopicModel:self.model];
                break;
            case 1:
                return [QHTopicInfoCell getCellHeightWithTopicModel:self.model];
                break;
            case 2:
                return [QHTopicBodyCell getCellHeightWithTopicModel:self.model];
                
            default:
                break;
        }
    }
    
    if (indexPath.section == 1) {
        QHReplyModel *model = self.replyList.list[indexPath.row];
        return [QHTopicReplyCell getCellHeightWithReplyModel:model];;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *titleCellIdentifier = @"titleCellIdentifier";
    QHTopicTitleCell *titleCell = (QHTopicTitleCell *)[tableView dequeueReusableCellWithIdentifier:titleCellIdentifier];
    if (!titleCell) {
        titleCell = [[QHTopicTitleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:titleCellIdentifier];
        titleCell.navi = self.navigationController;
    }
    
    static NSString *infoCellIdentifier = @"infoCellIdentifier";
    QHTopicInfoCell *infoCell = (QHTopicInfoCell *)[tableView dequeueReusableCellWithIdentifier:infoCellIdentifier];
    if (!infoCell) {
        infoCell = [[QHTopicInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:infoCellIdentifier];
        infoCell.navi = self.navigationController;
    }
    
    static NSString *bodyCellIdentifier = @"bodyCellIdentifier";
    QHTopicBodyCell *bodyCell = (QHTopicBodyCell *)[tableView dequeueReusableCellWithIdentifier:bodyCellIdentifier];
    if (!bodyCell) {
        bodyCell = [[QHTopicBodyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:bodyCellIdentifier];
        bodyCell.navi = self.navigationController;
    }
    
    static NSString *replyCellIdentifier = @"replyCellIdentifier";
    QHTopicReplyCell *replyCell = (QHTopicReplyCell *)[tableView dequeueReusableCellWithIdentifier:replyCellIdentifier];
    if (!replyCell) {
        replyCell = [[QHTopicReplyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:replyCellIdentifier];
        replyCell.navi = self.navigationController;
    }
    
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
                return [self configureTitleCellWithCell:titleCell IndexPath:indexPath];
                break;
            case 1:
                return [self configureInfoCellWithCell:infoCell IndexPath:indexPath];
                break;
            case 2:
                return [self configureBodyCellWithCell:bodyCell IndexPath:indexPath];
                break;
            default:
                break;
        }
    }
    
    if (indexPath.section == 1) {
        return [self configureReplyCellWithCell:replyCell IndexPath:indexPath];
    }
    
    return [UITableViewCell new];
}

#pragma mark - Configure TableCell

- (QHTopicTitleCell *)configureTitleCellWithCell:(QHTopicTitleCell *)cell IndexPath:(NSIndexPath *)indexPath {
    
    cell.model = self.model;
    
    return cell;
}

- (QHTopicInfoCell *)configureInfoCellWithCell:(QHTopicInfoCell *)cell IndexPath:(NSIndexPath *)indexPath {
    
    cell.model = self.model;
    
    return cell;
}

- (QHTopicBodyCell *)configureBodyCellWithCell:(QHTopicBodyCell *)cell IndexPath:(NSIndexPath *)indexPath {
    
    cell.model = self.model;
    
    @weakify(self);
    [cell setReloadCellBlock:^{
        @strongify(self);
        
        [self.tableView beginUpdates];
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView endUpdates];
        
    }];
    
    return cell;
}

- (QHTopicReplyCell *)configureReplyCellWithCell:(QHTopicReplyCell *)cell IndexPath:(NSIndexPath *)indexPath {
    
    QHReplyModel *model = self.replyList.list[indexPath.row];
    cell.model = model;
    cell.selectedReplyModel = self.selectedReplyModel;
    cell.replyList = self.replyList;
    
    @weakify(self);
    [cell setReloadCellBlock:^{
        @strongify(self);
        
        [self.tableView beginUpdates];
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView endUpdates];
        
    }];
    
    [cell setLongPressedBlock:^{
        @strongify(self);
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kSelectMemberNotification object:model];
        self.selectedReplyModel = model;
        
        //        if (self.actionSheet.isShowing) {
        //            return ;
        //        }
        //
        //        V2ReplyModel *model = self.replyList.list[indexPath.row];
        //        self.actionSheet = [[SCActionSheet alloc] sc_initWithTitle:model.replyCreator.memberName customView:nil buttonTitles:@"复制", @"查看回复", nil];
        //        [self.actionSheet sc_setButtonHandler:^{
        //            @strongify(self);
        //
        //        } forIndex:0];
        //        [self.actionSheet sc_show:YES];
        
    }];
    
    return cell;
}
@end
