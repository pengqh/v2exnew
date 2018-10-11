//
//  QHCategoriesViewController.m
//  v2exnew
//
//  Created by pengquanhua on 2018/9/16.
//  Copyright © 2018年 pengquanhua. All rights reserved.
//

#import "QHCategoriesViewController.h"
#import "QHTopicViewController.h"

@interface QHCategoriesViewController ()

@property (nonatomic, strong) QHBarButtonItem *leftBarItem;
@property (nonatomic, strong) QHBarButtonItem *rightBarItemExpend;

@end

@implementation QHCategoriesViewController

- (void)loadView {
    [super loadView];
    
    [self configureNavibarItems];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *testBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    testBtn.frame = CGRectMake(100, 100, 50, 50);
    testBtn.backgroundColor = [UIColor yellowColor];
    [testBtn setTitle:@"test" forState:UIControlStateNormal];
    [testBtn addTarget:self action:@selector(test:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:testBtn];
    
    self.sc_navigationItem.leftBarButtonItem = self.leftBarItem;
    self.sc_navigationItem.rightBarButtonItem = self.rightBarItemExpend;
    self.sc_navigationItem.title = @"好玩";
}

#pragma mark - Configure

- (void)configureNavibarItems {
    self.leftBarItem = [[QHBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navi_menu_2"] style:SCBarButtonItemStylePlain handler:^(id sender) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kShowMenuNotification object:nil];
    }];
    
    self.rightBarItemExpend = [[QHBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navi_dot"] style:SCBarButtonItemStylePlain handler:^(id sender) {
        
    }];
}

- (void)test:(id)sender {
    QHTopicViewController *topViewController = [[QHTopicViewController alloc] init];
    [self.navigationController pushViewController:topViewController animated:YES];
}


@end
