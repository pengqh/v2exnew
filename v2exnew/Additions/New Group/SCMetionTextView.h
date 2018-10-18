//
//  SCMetionTextView.h
//  v2exnew
//
//  Created by pengquanhua on 2018/10/17.
//  Copyright © 2018年 pengquanhua. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCMetionTextView : UITextView

@property (nonatomic, copy) UIColor *textBackgroundColor;

@property (nonatomic, readonly) UILabel *placeHolderLabel;
@property (nonatomic, copy) NSString *placeholder;
@property (nonatomic, strong) UIColor *placeholderColor;

@property (nonatomic, copy) BOOL (^textViewShouldBeginEditingBlock)(UITextView *textView);
@property (nonatomic, copy) BOOL (^textViewShouldChangeBlock)(UITextView *textView, NSString *text);
@property (nonatomic, copy) void (^textViewDidChangeBlock)(UITextView *textView);

@property (nonatomic, copy) void (^textViewDidAddQuoteSuccessBlock)(void);

// getter
@property (nonatomic, copy) NSString *renderedString;


@end
