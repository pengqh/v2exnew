//
//  QHTopicToolBarView.m
//  v2exnew
//
//  Created by pengquanhua on 2018/10/17.
//  Copyright © 2018年 pengquanhua. All rights reserved.
//

#import "QHTopicToolBarView.h"
#import "SCMetionTextView.h"

@interface QHTopicToolBarView ()

@property (nonatomic, strong) NSArray          *itemTitleArray;
@property (nonatomic, strong) NSArray          *itemImageArray;

@property (nonatomic, strong) SCMetionTextView *textView;

@property (nonatomic, strong) UIImageView      *backgroundImageView;
@property (nonatomic, strong) UIButton         *backgroundButton;
@property (nonatomic, strong) UIButton         *imageInsertButton;

@property (nonatomic, assign) NSInteger        sharpIndex;
@property (nonatomic, assign) NSInteger        keyboardHeight;

@property (nonatomic, assign) BOOL isShowing;

@end

@implementation QHTopicToolBarView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor        = [UIColor clearColor];
        self.userInteractionEnabled = NO;
        
        self.isShowing = NO;
        
        self.itemTitleArray         = @[@"评论", @"收藏"];
        self.itemImageArray         = @[@"icon_reply", @"icon_fav"];
    
        [self configureViews];
        [self configureImageInsertView];
        [self configureBlocks];
        [self configureNotifications];
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.backgroundImageView.frame = self.frame;
    self.backgroundButton.frame    = self.frame;
    
    self.imageInsertButton.centerY = (kScreenHeight - self.keyboardHeight - self.textView.y - self.textView.height) / 2 + self.textView.y + self.textView.height;
    
    if (self.isCreate) {
        self.textView.placeholder      = @"输入主题内容";
        [self.backgroundButton bk_removeEventHandlersForControlEvents:UIControlEventTouchUpInside];
    } else {
        self.textView.placeholder      = @"让回复对别人有帮助";
    }
}

#pragma mark - Configure

- (void)configureViews {
    
    self.backgroundImageView = [[UIImageView alloc] init];
    self.backgroundImageView.backgroundColor = kBackgroundColorWhite;
    self.backgroundImageView.alpha           = 0.0;
    [self addSubview:self.backgroundImageView];
    
    self.backgroundButton                    = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:self.backgroundButton];
    
    self.textView                            = [[SCMetionTextView alloc] initWithFrame:CGRectMake(10, 368 - kScreenHeight, kScreenWidth - 20, kScreenHeight - 368)];
    self.textView.textColor                  = kFontColorBlackDark;
    self.textView.layer.borderColor          = kLineColorBlackLight.CGColor;
    self.textView.backgroundColor            = kBackgroundColorWhite;
    self.textView.layer.borderWidth          = 0.5;
    self.textView.font                       = [UIFont systemFontOfSize:17];
    self.textView.returnKeyType              = UIReturnKeyDefault;
    self.textView.autocapitalizationType     = UITextAutocapitalizationTypeNone;
    self.textView.autocorrectionType         = UITextAutocorrectionTypeNo;
    self.textView.contentInsetTop            = 2;
    self.textView.contentInsetLeft           = 5;
    self.textView.showsHorizontalScrollIndicator = NO;
    self.textView.alwaysBounceHorizontal = NO;
    [self addSubview:self.textView];
    
    if (kCurrentTheme == V2ThemeNight) {
        self.textView.keyboardAppearance         = UIKeyboardAppearanceDark;
        // self.textView.placeholderColor           = [UIColor colorWithRed:0.820 green:0.820 blue:0.840 alpha:0.240];
    } else {
        self.textView.keyboardAppearance         = UIKeyboardAppearanceDefault;
        // self.textView.placeholderColor           = [UIColor colorWithRed:0.82f green:0.82f blue:0.84f alpha:1.00f];
        
    }
    
    // handles
    @weakify(self);
    
    [self.textView setTextViewShouldChangeBlock:^BOOL(UITextView *textView, NSString *text) {
        @strongify(self);
        
        if ([text isEqualToString:@"&"]) {
            
            self.sharpIndex = textView.text.length + 1;
            [self showImageInsertView];
            
        } else {
            
            self.sharpIndex = NSNotFound;
            [self hideImageInsertView];
            
        }
        
        return YES;
    }];
    
    [self.textView setTextViewDidChangeBlock:^(UITextView *textView) {
        @strongify(self);
        
        if (self.contentIsEmptyBlock) {
            self.contentIsEmptyBlock(textView.text.length == 0);
        }
        
    }];
}

- (void)configureImageInsertView {
    
    self.imageInsertButton = [[UIButton alloc] initWithFrame:(CGRect){0, 0, 100, 36}];
    self.imageInsertButton.backgroundColor = kFontColorBlackDark;
    self.imageInsertButton.alpha = 0.3;
    self.imageInsertButton.layer.cornerRadius = 3;
    self.imageInsertButton.clipsToBounds = YES;
    [self.imageInsertButton setTitle:@"插入图片" forState:UIControlStateNormal];
    [self.imageInsertButton setTitleColor:kLineColorBlackDark forState:UIControlStateNormal];
    [self addSubview:self.imageInsertButton];
    
    self.imageInsertButton.centerX = 160;
    [self hideImageInsertView];
    
    // Handles
    @weakify(self);
    [self.imageInsertButton bk_addEventHandler:^(id sender) {
        @strongify(self);
        
        self.textView.text = [self.textView.text substringToIndex:self.sharpIndex - 1];
        [self hideImageInsertView];
        
        if (self.insertImageBlock) {
            [self.textView resignFirstResponder];
            self.insertImageBlock();
        }
        
    } forControlEvents:UIControlEventTouchUpInside];
}

- (void)configureBlocks {
    
    [self.backgroundButton bk_addEventHandler:^(id sender) {
        
        [self hideToolBar];
        
    } forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)configureNotifications {
    
    @weakify(self);
    [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillShowNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
        @strongify(self);
        
        CGRect keyboardFrame;
        [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardFrame];
        
        self.keyboardHeight = keyboardFrame.size.height;
        
        
    }];
}

#pragma mark - Public Methods

- (void)showReplyViewWithQuotes:(NSArray *)quotes animated:(BOOL)animated {
    
    self.userInteractionEnabled = YES;
    self.isShowing = YES;
    
//    if (quotes.count) {
//        for (SCQuote *quote in quotes) {
//            [self.textView addQuote:quote];
//        }
//    }
    
    if (animated) {
        [UIView animateWithDuration:0.1 animations:^{
//            self.circleView.x = 321;
//            for (V2TopicToolBarItemView *item in self.toolBarItemArray) {
//                item.alpha = 0.0;
//            }
        } completion:^(BOOL finished) {
            //[[NSNotificationCenter defaultCenter] postNotificationName:kShowReplyTextViewNotification object:nil];
            
            [self.textView becomeFirstResponder];
            
            [UIView animateWithDuration:0.8 delay:0 usingSpringWithDamping:0.75 initialSpringVelocity:0.95 options:UIViewAnimationOptionCurveEaseIn animations:^{
                //                    self.backgroundImageView.alpha = 1;
                self.textView.y = UIView.sc_navigationBarHeight + 10;
            } completion:^(BOOL finished) {
                self.imageInsertButton.centerY = (kScreenHeight - self.keyboardHeight - self.textView.y - self.textView.height) / 2 + self.textView.y + self.textView.height;
            }];
            
            [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                self.backgroundImageView.alpha = 1;
                //                    self.textView.y = 74;
            } completion:^(BOOL finished) {
                ;
            }];
        }];
    } else {
        
//        self.circleView.x = 321;
//        for (V2TopicToolBarItemView *item in self.toolBarItemArray) {
//            item.alpha = 0.0;
//        }
//        [[NSNotificationCenter defaultCenter] postNotificationName:kShowReplyTextViewNotification object:nil];
        
        [self.textView becomeFirstResponder];
        
        self.textView.y = UIView.sc_navigationBarHeight + 10;
        
        self.imageInsertButton.centerY = (kScreenHeight - self.keyboardHeight - self.textView.y - self.textView.height) / 2 + self.textView.y + self.textView.height;
        
        self.backgroundImageView.alpha = 1;
        
    }
    
}


#pragma mark - Privates

- (void)hideToolBar {
    self.isShowing = NO;
    
    self.userInteractionEnabled = NO;
    
    //[[NSNotificationCenter defaultCenter] postNotificationName:kHideReplyTextViewNotification object:nil];
    [self hideImageInsertView];
    
    if (self.textView.y > 0) {
        [UIView animateWithDuration:0.1 animations:^{
            self.textView.y = UIView.sc_navigationBarHeight + 20;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.7 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:1.05 options:UIViewAnimationOptionCurveEaseOut animations:^{
                self.textView.y = -self.textView.height;
            } completion:nil];
        }];
    }
}

- (void)showImageInsertView {
    
    self.imageInsertButton.userInteractionEnabled = YES;
    [UIView animateWithDuration:0.2 animations:^{
        self.imageInsertButton.alpha = 0.3;
    }];
    
}

- (void)hideImageInsertView {
    
    self.imageInsertButton.userInteractionEnabled = NO;
    [UIView animateWithDuration:0.2 animations:^{
        self.imageInsertButton.alpha = 0.0;
    }];
    
}
@end
