//
//  V2RootViewController.m
//  v2exnew
//
//  Created by pengquanhua on 2018/9/12.
//  Copyright © 2018年 pengquanhua. All rights reserved.
//

#import "V2RootViewController.h"

#import "QHCategoriesViewController.h"
#import "QHMenuView.h"

static CGFloat const kMenuWidth = 240.0;

@interface V2RootViewController () <UIGestureRecognizerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) QHCategoriesViewController       *latestViewController;
@property (nonatomic, strong) QHCategoriesViewController   *categoriesViewController;
@property (nonatomic, strong) QHCategoriesViewController        *nodesViewController;
@property (nonatomic, strong) QHCategoriesViewController     *favouriteViewController;
@property (nonatomic, strong) QHCategoriesViewController *notificationViewController;
@property (nonatomic, strong) QHCategoriesViewController      *profileViewController;

@property (nonatomic, strong) QHNavigationController       *latestNavigationController;
@property (nonatomic, strong) QHNavigationController       *categoriesNavigationController;
@property (nonatomic, strong) QHNavigationController       *nodesNavigationController;
@property (nonatomic, strong) QHNavigationController       *favoriteNavigationController;
@property (nonatomic, strong) QHNavigationController       *nofificationNavigationController;
@property (nonatomic, strong) QHNavigationController       *profilenavigationController;

@property (nonatomic, strong) QHMenuView *menuView;
@property (nonatomic, strong) UIView *viewControllerContainView;
@property (nonatomic, assign) NSInteger currentSelectedIndex;

@property (nonatomic, strong) UIButton   *rootBackgroundButton;
@property (nonatomic, strong) UIScreenEdgePanGestureRecognizer *edgePanRecognizer;

@end

@implementation V2RootViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.currentSelectedIndex = 0;
        [QHSettingManager manager];
    }
    return self;
}

- (void)loadView {
    [super loadView];
    
    [self configureViewControllers];
    [self configureViews];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureGestures];
    [self configureNotifications];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Layouts

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    self.viewControllerContainView.frame = self.view.frame;
    self.rootBackgroundButton.frame = self.view.frame;
}

# pragma mark - Configure Views

- (void)configureViews {
    self.rootBackgroundButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.rootBackgroundButton.alpha = 0.0;
    self.rootBackgroundButton.backgroundColor = [UIColor blackColor];
    self.rootBackgroundButton.hidden = YES;
    [self.view addSubview:self.rootBackgroundButton];
    
    self.menuView = [[QHMenuView alloc] initWithFrame:(CGRect){-kMenuWidth, 0, kMenuWidth, kScreenHeight}];
    [self.view addSubview:self.menuView];
    
    // Handles
    @weakify(self);
    [self.rootBackgroundButton bk_whenTapped:^{
        @strongify(self);
        
        [UIView animateWithDuration:0.3 animations:^{
            [self setMenuOffset:0.0f];
        }];
    }];
    
    [self.menuView setDidSelectedIndexBlock:^(NSInteger index) {
        @strongify(self);
        
        [self showViewControllerAtIndex:index animated:YES];
        [QHSettingManager manager].selectedSectionIndex = index;
    }];
}

- (void)configureViewControllers {
    
    self.viewControllerContainView          = [[UIView alloc] initWithFrame:(CGRect){0, 0, kScreenWidth, kScreenHeight}];
    [self.view addSubview:self.viewControllerContainView];
    
    self.latestViewController       = [[UIViewController alloc] init];
    self.latestNavigationController = [[QHNavigationController alloc] initWithRootViewController:self.latestViewController];
    
    self.categoriesViewController = [[QHCategoriesViewController alloc] init];
    self.categoriesNavigationController = [[QHNavigationController alloc] initWithRootViewController:self.categoriesViewController];
    
    self.nodesViewController        = [[UIViewController alloc] init];
    self.nodesNavigationController = [[QHNavigationController alloc] initWithRootViewController:self.nodesViewController];
    
    self.favouriteViewController      = [[QHCategoriesViewController alloc] init];
    self.favouriteViewController.favorite = YES;
    self.favoriteNavigationController = [[QHNavigationController alloc] initWithRootViewController:self.favouriteViewController];
    
    self.notificationViewController = [[UIViewController alloc] init];
    self.nofificationNavigationController = [[QHNavigationController alloc] initWithRootViewController:self.notificationViewController];
    
    self.profileViewController      = [[UIViewController alloc] init];
    //self.profileViewController.isSelf = YES;
    self.profilenavigationController = [[QHNavigationController alloc] initWithRootViewController:self.profileViewController];
    
    self.currentSelectedIndex = [QHSettingManager manager].selectedSectionIndex;
    [self.viewControllerContainView addSubview:[self viewControllerForIndex:[QHSettingManager manager].selectedSectionIndex].view];
}

- (void)configureNotifications {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveShowMenuNotification) name:kShowMenuNotification object:nil];
}

- (void)configureGestures {
    
    self.edgePanRecognizer          = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(handleEdgePanRecognizer:)];
    self.edgePanRecognizer.edges    = UIRectEdgeLeft;
    self.edgePanRecognizer.delegate = self;
    [self.view addGestureRecognizer:self.edgePanRecognizer];
    
    UIPanGestureRecognizer *panRecoginzer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanRecognizer:)];
    panRecoginzer.delegate = self;
    [self.rootBackgroundButton addGestureRecognizer:panRecoginzer];
}

#pragma mark - Private Methods

- (void)showViewControllerAtIndex:(V2SectionIndex)index animated:(BOOL)animated {
    
    if (self.currentSelectedIndex != index) {
        
        @weakify(self);
        void (^showBlock)(void) = ^{
            @strongify(self);
            UIViewController *previousViewController = [self viewControllerForIndex:self.currentSelectedIndex];
            UIViewController *willShowViewController = [self viewControllerForIndex:index];
            
            if (willShowViewController) {
                
                BOOL isViewInRootView = NO;
                for (UIView *subView in self.view.subviews) {
                    if ([subView isEqual:willShowViewController.view]) {
                        isViewInRootView = YES;
                    }
                }
                if (isViewInRootView) {
                    willShowViewController.view.x = 320;
                    [self.viewControllerContainView bringSubviewToFront:willShowViewController.view];
                } else {
                    [self.viewControllerContainView addSubview:willShowViewController.view];
                    willShowViewController.view.x = 320;
                }
                
                if (animated) {
                    [UIView animateWithDuration:0.2 animations:^{
                        previousViewController.view.x += 20;
                    }];
                    
                    [UIView animateWithDuration:0.6 delay:0 usingSpringWithDamping:1 initialSpringVelocity:1.2 options:UIViewAnimationOptionCurveLinear animations:^{
                        willShowViewController.view.x = 0;
                    } completion:nil];
                    
                    [UIView animateWithDuration:0.3 delay:0.1 options:UIViewAnimationOptionCurveEaseOut animations:^{
                        [self setMenuOffset:0.0f];
                    } completion:nil];
                } else {
                    previousViewController.view.x += 20;
                    willShowViewController.view.x = 0;
                    [self setMenuOffset:0.0f];
                }
                self.currentSelectedIndex = index;
            }
        };
        showBlock();
    
    } else {
        UIViewController *willShowViewController = [self viewControllerForIndex:index];
        
        [UIView animateWithDuration:0.4 animations:^{
            willShowViewController.view.x = 0;
        }];
        [UIView animateWithDuration:0.5 animations:^{
            [self setMenuOffset:0.0f];
        }];
        
    }
    [self.menuView selectIndex:index];
    
}

- (UIViewController *)viewControllerForIndex:(V2SectionIndex)index {
    
    UIViewController *viewController;
    switch (index) {
        case V2SectionIndexLatest:
            viewController = self.latestNavigationController;
            break;
        case V2SectionIndexCategories:
            viewController = self.categoriesNavigationController;
            break;
        case V2SectionIndexNodes:
            viewController = self.nodesNavigationController;
            break;
        case V2SectionIndexFavorite:
            viewController = self.favoriteNavigationController;
            break;
        case V2SectionIndexNotification:
            viewController = self.nofificationNavigationController;
            break;
        case V2SectionIndexProfile:
            viewController = self.profilenavigationController;
            break;
        default:
            break;
    }
    
    return viewController;
}

- (void)setMenuOffset:(CGFloat)offset {
    self.menuView.x = offset - kMenuWidth;
    [self.menuView setOffsetProgress:offset/kMenuWidth];
    self.rootBackgroundButton.alpha = offset/kMenuWidth * 0.3;
    UIViewController *previousViewController = [self viewControllerForIndex:self.currentSelectedIndex];
    previousViewController.view.x       = offset/8.0;
}

#pragma mark - Gestures

- (void)handlePanRecognizer:(UIPanGestureRecognizer *)recognizer {
    CGFloat progress = [recognizer translationInView:self.rootBackgroundButton].x / (self.rootBackgroundButton.bounds.size.width * 0.5);
    progress = - MIN(progress, 0);
    
    [self setMenuOffset:kMenuWidth - kMenuWidth * progress];
    
    static CGFloat sumProgress = 0;
    static CGFloat lastProgress = 0;
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        
        sumProgress = 0;
        lastProgress = 0;
        
    }
    
    if (recognizer.state == UIGestureRecognizerStateChanged) {
        
        if (progress > lastProgress) {
            sumProgress += progress;
        } else {
            sumProgress -= progress;
        }
        lastProgress = progress;
        
    }
    
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        
        [UIView animateWithDuration:0.3 animations:^{
            if (sumProgress > 0.1) {
                [self setMenuOffset:0];
            } else {
                [self setMenuOffset:kMenuWidth];
            }
        } completion:^(BOOL finished) {
            if (sumProgress > 0.1) {
                self.rootBackgroundButton.hidden = YES;
            } else {
                self.rootBackgroundButton.hidden = NO;
            }
        }];
    }
}

- (void)handleEdgePanRecognizer:(UIScreenEdgePanGestureRecognizer *)recognizer {
    CGFloat progress = [recognizer translationInView:self.view].x / kMenuWidth;
    progress = MIN(1.0, MAX(0.0, progress));
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        
        //        [self setBlurredScreenShoot];
        self.rootBackgroundButton.hidden = NO;
        
    }
    else if (recognizer.state == UIGestureRecognizerStateChanged) {
        
        [self setMenuOffset:kMenuWidth * progress];
    }
    else if (recognizer.state == UIGestureRecognizerStateEnded || recognizer.state == UIGestureRecognizerStateCancelled) {
        
        
        CGFloat velocity = [recognizer velocityInView:self.view].x;
        
        if (velocity > 20 || progress > 0.5) {
            
            [UIView animateWithDuration:(1-progress)/1.5 delay:0 usingSpringWithDamping:1 initialSpringVelocity:3.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                [self setMenuOffset:kMenuWidth];
            } completion:^(BOOL finished) {
                ;
            }];
        }
        else {
            [UIView animateWithDuration:progress/3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                [self setMenuOffset:0];
            } completion:^(BOOL finished) {
                self.rootBackgroundButton.hidden = YES;
                self.rootBackgroundButton.alpha = 0.0;
            }];
        }
        
    }
    
}

#pragma mark - Notifications

- (void)didReceiveShowMenuNotification {
    
    //    [self setBlurredScreenShoot];
    
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:1.0 initialSpringVelocity:3.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        [self setMenuOffset:kMenuWidth];
        self.rootBackgroundButton.hidden = NO;
    } completion:nil];
    
}

@end
