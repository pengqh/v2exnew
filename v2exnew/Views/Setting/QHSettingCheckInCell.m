//
//  QHSettingCheckInCell.m
//  v2exnew
//
//  Created by pengquanhua on 2018/10/18.
//  Copyright © 2018年 pengquanhua. All rights reserved.
//

#import "QHSettingCheckInCell.h"

@interface QHSettingCheckInCell ()

@property (nonatomic, strong) UILabel *checkInCountLabel;
@property (nonatomic, strong) UIActivityIndicatorView *activityView;

@end


@implementation QHSettingCheckInCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = kBackgroundColorWhite;
        
        self.checkInCountLabel = [UILabel new];
        self.checkInCountLabel.font = [UIFont systemFontOfSize:15.0f];
        self.checkInCountLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:self.checkInCountLabel];
        
        self.activityView = [[UIActivityIndicatorView alloc] init];
        self.activityView.color = kLineColorBlackDark;
        self.activityView.hidden = YES;
        [self addSubview:self.activityView];
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.activityView.frame = (CGRect){kScreenWidth - 15 - 44, 0, 44, 44};
    self.checkInCountLabel.frame = (CGRect){kScreenWidth - 15 - 150, 0, 150, self.height};
    [self configureLabel];
    
}

- (void)configureLabel {
    
    NSString *isCheckInString = @"";
    if ([QHCheckInManager manager].isExpired) {
        isCheckInString = @" (未签到)";
        self.checkInCountLabel.textColor = kFontColorBlackDark;
    } else {
        isCheckInString = @" (已签到)";
        self.checkInCountLabel.textColor = kFontColorBlackLight;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    self.checkInCountLabel.text = [NSString stringWithFormat:@"%ld天%@", (long)[QHCheckInManager manager].checkInCount, isCheckInString];
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)beginCheckIn {
    
    self.checkInCountLabel.hidden = YES;
    self.activityView.hidden = NO;
    [self.activityView startAnimating];
    
}

- (void)endCheckIn {
    
    [self configureLabel];
    self.checkInCountLabel.hidden = NO;
    self.activityView.hidden = YES;
    [self.activityView stopAnimating];
    
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    
}

@end
