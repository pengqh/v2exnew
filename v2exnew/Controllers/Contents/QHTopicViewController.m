//
//  QHTopicViewController.m
//  v2exnew
//
//  Created by pengquanhua on 2018/9/16.
//  Copyright © 2018年 pengquanhua. All rights reserved.
//

#import "QHTopicViewController.h"

@interface QHTopicViewController ()

@property (nonatomic, strong) QHBarButtonItem    *leftBarItem;

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
    
    self.leftBarItem = [[QHBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navi_back"] style:SCBarButtonItemStylePlain handler:^(id sender) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
}
    
@end
