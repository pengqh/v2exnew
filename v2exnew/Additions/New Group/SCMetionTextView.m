//
//  SCMetionTextView.m
//  v2exnew
//
//  Created by pengquanhua on 2018/10/17.
//  Copyright © 2018年 pengquanhua. All rights reserved.
//

#import "SCMetionTextView.h"

@interface SCMetionTextView () <UITextViewDelegate>

@property (nonatomic, readwrite, strong) UILabel *placeHolderLabel;

@property (nonatomic, strong) NSMutableArray *quoteArray;

@property (nonatomic, assign) NSInteger didChangeLength;

@property (nonatomic, assign) BOOL hasChange;
@property (nonatomic, assign) BOOL isInit;

// Test
@property (nonatomic, strong) UIView *quoteView;

@end

@implementation SCMetionTextView

- (instancetype)initWithFrame:(CGRect)frame {
    NSTextStorage* textStorage = [[NSTextStorage alloc] init];
    NSLayoutManager* layoutManager = [NSLayoutManager new];
    [textStorage addLayoutManager:layoutManager];
    NSTextContainer *textContainer = [[NSTextContainer alloc] initWithSize:frame.size];
    [layoutManager addTextContainer:textContainer];
    self = [super initWithFrame:frame textContainer:textContainer];
    
    if (self)
    {
        self.inputAccessoryView = [[UIView alloc] init];
        
        [self setPlaceholder:@""];
        [self setPlaceholderColor:[UIColor lightGrayColor]];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:nil];
        
        self.autocorrectionType = UITextAutocorrectionTypeNo;
        self.autocapitalizationType = UITextAutocapitalizationTypeNone;
    }
    
    // Init
    self.hasChange = NO;
    self.isInit = YES;
    
    self.delegate = self;
    
    self.textBackgroundColor = [UIColor colorWithRed:0.188 green:0.662 blue:1.000 alpha:0.150];
    self.placeholderColor = [UIColor lightGrayColor];
    return self;
}

#pragma mark - TextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    if (self.textViewShouldBeginEditingBlock) {
        return self.textViewShouldBeginEditingBlock(textView);
    }
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    //    SPLog(@"range: %@   text: %@", NSStringFromRange(range), text);
    
    if (self.textViewShouldChangeBlock) {
        if (!self.textViewShouldChangeBlock(textView, text)) {
            return NO;
        };
    }
    self.isInit = NO;
    
    CGRect textRect = [textView.layoutManager usedRectForTextContainer:textView.textContainer];
    CGFloat sizeAdjustment = textView.font.lineHeight * [UIScreen mainScreen].scale;
    
    if (textRect.size.height >= textView.frame.size.height - sizeAdjustment) {
        if ([text isEqualToString:@"\n"]) {
            [UIView animateWithDuration:0.2 animations:^{
                [textView setContentOffset:CGPointMake(textView.contentOffset.x, textView.contentOffset.y + sizeAdjustment)];
            }];
        }
    }
    
    return YES;
    
}

- (void)textViewDidChange:(UITextView *)textView {
    if (self.textViewDidChangeBlock) {
        self.textViewDidChangeBlock(textView);
    }
}

@end
