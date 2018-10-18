//
//  QHSettingViewController.m
//  v2exnew
//
//  Created by pengquanhua on 2018/10/18.
//  Copyright © 2018年 pengquanhua. All rights reserved.
//

#import "QHSettingViewController.h"
#import "QHSettingCheckInCell.h"
#import "QHSettingSwitchCell.h"
#import "QHSettingWeiboCell.h"
#import "SCActionSheet.h"

typedef NS_ENUM(NSInteger, V2SettingSection) {
    V2SettingSectionDisplay      = 0,
    V2SettingSectionTraffic      = 1,
    V2SettingSectionCheckIn      = 2,
    V2SettingSectionWeibo        = 3,
    V2SettingSectionAbout        = 4,
    V2SettingSectionFour         = 5,
};

@interface QHSettingViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray *headerTitleArray;

@property (nonatomic, strong) QHBarButtonItem *backBarItem;

@property (nonatomic, strong) SCActionSheet      *actionSheet;

@end

@implementation QHSettingViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.headerTitleArray = @[@"提醒", @"显示", @"流量", @"签到", @"绑定", @"关于"];
    }
    return self;
}

- (void)loadView {
    [super loadView];
    
    [self configureBarItems];
    [self configureTableView];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.sc_navigationItem.leftBarButtonItem = self.backBarItem;
    self.sc_navigationItem.title = @"设置";
}

#pragma mark - Layout

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    self.tableView.contentInsetTop = UIView.sc_navigationBarHeight;
    self.tableView.contentInsetBottom = 15;
    
}

#pragma mark - Configure

- (void)configureBarItems {
    @weakify(self);
    self.backBarItem = [[QHBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navi_back"] style:SCBarButtonItemStyleDone handler:^(id sender) {
        @strongify(self);
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }];
}

- (void)configureTableView {
    
    self.tableView                 = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate        = self;
    self.tableView.dataSource      = self;
    [self.view addSubview:self.tableView];
    
}

#pragma mark - TableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == V2SettingSectionAbout) {
        return 2;
    }
    if (section == V2SettingSectionDisplay) {
        return 3;
    }
    if (section == V2SettingSectionTraffic) {
        return 2;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *checkInCellIdentifier = @"CheckInSettingIdentifier";
    QHSettingCheckInCell *checkInCell = (QHSettingCheckInCell *)[tableView dequeueReusableCellWithIdentifier:checkInCellIdentifier];
    if (!checkInCell) {
        checkInCell = [[QHSettingCheckInCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:checkInCellIdentifier];
    }
    
    static NSString *weiboCellIdentifier = @"WeiboSettingIdentifier";
    QHSettingWeiboCell *weiboCell = (QHSettingWeiboCell *)[tableView dequeueReusableCellWithIdentifier:weiboCellIdentifier];
    if (!weiboCell) {
        weiboCell = [[QHSettingWeiboCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:weiboCellIdentifier];
    }
    
    static NSString *switchCellIdentifier = @"SwitchSettingIdentifier";
    QHSettingSwitchCell *switchCell = (QHSettingSwitchCell *)[tableView dequeueReusableCellWithIdentifier:switchCellIdentifier];
    if (!switchCell) {
        switchCell = [[QHSettingSwitchCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:switchCellIdentifier];
    }
    
    static NSString *CellIdentifier = @"SettingIdentifier";
    QHSettingCell *settingCell = (QHSettingSwitchCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!settingCell) {
        settingCell = [[QHSettingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if (indexPath.section == V2SettingSectionDisplay) {
        
        if (indexPath.row == 0) {
            switchCell.title = @"夜间模式";
            switchCell.isOn = kSetting.theme == V2ThemeNight;
            switchCell.top = YES;
        }
        
        if (indexPath.row == 1) {
            switchCell.title = @"自动选择夜间模式";
            switchCell.isOn = kSetting.themeAutoChange;
        }
        
        if (indexPath.row == 2) {
            switchCell.title = @"自动隐藏导航栏";
            switchCell.isOn = kSetting.navigationBarAutoHidden;
            switchCell.bottom = YES;
        }
        
        return switchCell;
    }
    
    if (indexPath.section == V2SettingSectionTraffic) {
        
        if (indexPath.row == 0) {
            switchCell.title = @"使用 HTTPS";
            switchCell.isOn = kSetting.preferHttps;
            switchCell.top = YES;
            switchCell.bottom = NO;
        }
        
        if (indexPath.row == 1) {
            switchCell.title = @"省流量模式";
            switchCell.isOn = kSetting.trafficSaveModeOnSetting;
            switchCell.top = NO;
            switchCell.bottom = YES;
        }
        
        return switchCell;
    }
    
    if (indexPath.section == V2SettingSectionCheckIn) {
        
        checkInCell.title = @"签到";
        checkInCell.top = YES;
        checkInCell.bottom = YES;
        
        return checkInCell;
    }
    
    if (indexPath.section == V2SettingSectionWeibo) {
        
        if (indexPath.row == 0) {
            weiboCell.title = @"微博";
            weiboCell.top = YES;
            weiboCell.bottom = YES;
        }
        
        return weiboCell;
    }
    
    if (indexPath.section == V2SettingSectionAbout) {
        
        if (indexPath.row == 0) {
            settingCell.title = @"关于作者";
            settingCell.top = YES;
        }
        
        if (indexPath.row == 1) {
            settingCell.title = @"关于V2EX";
            settingCell.bottom = YES;
        }
        
        return settingCell;
    }
    
    UITableViewCell *blackCell = [UITableViewCell new];
    blackCell.backgroundColor = kBackgroundColorWhite;
    
    return blackCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    @weakify(self);
    
    QHSettingCell *settingCell = (QHSettingCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    
    if ([settingCell isKindOfClass:[QHSettingSwitchCell class]]) {
        
        QHSettingSwitchCell *switchCell = (QHSettingSwitchCell *)settingCell;
        
        switchCell.isOn = !switchCell.isOn;
        
        //        if (indexPath.section == V2SettingSectionNotification) {
        //
        //            if (indexPath.row == 0) {
        //                kSetting.checkInNotiticationOn = switchCell.isOn;
        //            }
        //
        //            if (indexPath.row == 1) {
        //                kSetting.newNotificationOn = switchCell.isOn;
        //            }
        //
        //        }
        
        if (indexPath.section == V2SettingSectionDisplay) {
            
            if (indexPath.row == 0) {
                if (switchCell.isOn) {
                    kSetting.theme = V2ThemeNight;
                } else {
                    kSetting.theme = V2ThemeDefault;
                }
            }
            
            if (indexPath.row == 1) {
                kSetting.themeAutoChange = switchCell.isOn;
            }
            
            if (indexPath.row == 2) {
                kSetting.navigationBarAutoHidden = switchCell.isOn;
            }
            
        }
        
        if (indexPath.section == V2SettingSectionTraffic) {
            
            if (indexPath.row == 0) {
                kSetting.preferHttps = switchCell.isOn;
            }
            
            if (indexPath.row == 1) {
                kSetting.trafficSaveModeOn = switchCell.isOn;
            }
            
        }
        
    }
}

@end
